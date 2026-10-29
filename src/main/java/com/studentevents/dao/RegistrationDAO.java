package com.studentevents.dao;

import com.studentevents.DatabaseConnection;
import com.studentevents.model.Registration;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Demonstrates:
 * 1. CallableStatement calling PL/SQL Procedure SP_REGISTER_STUDENT_EVENT with multiple OUT parameters
 * 2. CallableStatement calling PL/SQL Procedure SP_CANCEL_REGISTRATION
 * 3. PreparedStatement querying registrations joined with students and events
 */
public class RegistrationDAO {

    public static class RegistrationResult {
        public int registrationId;
        public String ticketCode;
        public String statusMessage;

        public RegistrationResult(int registrationId, String ticketCode, String statusMessage) {
            this.registrationId = registrationId;
            this.ticketCode = ticketCode;
            this.statusMessage = statusMessage;
        }
    }

    /**
     * PL/SQL PROCEDURE CALL: Calls SP_REGISTER_STUDENT_EVENT.
     * Demonstrates 3 IN parameters and 3 OUT parameters (ID, Ticket Code, Status Message).
     */
    public RegistrationResult registerStudentViaPLSQL(int studentId, int eventId, double feePaid) throws SQLException {
        String plsql = "{CALL SP_REGISTER_STUDENT_EVENT(?, ?, ?, ?, ?, ?)}";

        try (Connection conn = DatabaseConnection.getConnection();
             CallableStatement cs = conn.prepareCall(plsql)) {

            // Bind IN parameters
            cs.setInt(1, studentId);
            cs.setInt(2, eventId);
            cs.setDouble(3, feePaid);

            // Register OUT parameters
            cs.registerOutParameter(4, Types.INTEGER); // p_reg_id
            cs.registerOutParameter(5, Types.VARCHAR); // p_ticket_code
            cs.registerOutParameter(6, Types.VARCHAR); // p_status_msg

            // Execute stored procedure
            cs.execute();

            int regId = cs.getInt(4);
            String ticketCode = cs.getString(5);
            String statusMsg = cs.getString(6);

            return new RegistrationResult(regId, ticketCode, statusMsg);
        }
    }

    /**
     * PL/SQL PROCEDURE CALL: Calls SP_CANCEL_REGISTRATION.
     * Cancels registration, decrements counter, promotes waitlisted student, and returns refund amount.
     */
    public double cancelRegistrationViaPLSQL(int registrationId) throws SQLException {
        String plsql = "{CALL SP_CANCEL_REGISTRATION(?, ?)}";

        try (Connection conn = DatabaseConnection.getConnection();
             CallableStatement cs = conn.prepareCall(plsql)) {

            cs.setInt(1, registrationId);
            cs.registerOutParameter(2, Types.NUMERIC);

            cs.execute();

            return cs.getDouble(2); // refund amount
        }
    }

    /**
     * SELECT all registrations joined with students and events.
     */
    public List<Registration> getAllRegistrations() throws SQLException {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.registration_id, r.student_id, r.event_id, " +
                     "s.full_name AS student_name, e.title AS event_title, " +
                     "r.registration_date, r.status, r.fee_paid, r.ticket_code " +
                     "FROM registrations r " +
                     "JOIN students s ON r.student_id = s.student_id " +
                     "JOIN events e ON r.event_id = e.event_id " +
                     "ORDER BY r.registration_id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(new Registration(
                    rs.getInt("registration_id"),
                    rs.getInt("student_id"),
                    rs.getInt("event_id"),
                    rs.getString("student_name"),
                    rs.getString("event_title"),
                    rs.getTimestamp("registration_date"),
                    rs.getString("status"),
                    rs.getDouble("fee_paid"),
                    rs.getString("ticket_code")
                ));
            }
        }
        return list;
    }
}
