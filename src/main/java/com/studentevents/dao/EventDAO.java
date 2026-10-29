package com.studentevents.dao;

import com.studentevents.DatabaseConnection;
import com.studentevents.model.CampusEvent;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    /**
     * SELECT all events ordered by event_date.
     */
    public List<CampusEvent> getAllEvents() throws SQLException {
        List<CampusEvent> list = new ArrayList<>();
        String sql = "SELECT event_id, title, category, event_date, max_capacity, " +
                     "current_registrations, registration_fee, venue " +
                     "FROM events ORDER BY event_date ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(new CampusEvent(
                    rs.getInt("event_id"),
                    rs.getString("title"),
                    rs.getString("category"),
                    rs.getDate("event_date"),
                    rs.getInt("max_capacity"),
                    rs.getInt("current_registrations"),
                    rs.getDouble("registration_fee"),
                    rs.getString("venue")
                ));
            }
        }
        return list;
    }

    /**
     * INSERT a new event via PreparedStatement using Oracle sequence SEQ_EVENT_ID.NEXTVAL.
     */
    public boolean createEvent(CampusEvent event) throws SQLException {
        String sql = "INSERT INTO events (event_id, title, category, event_date, max_capacity, current_registrations, registration_fee, venue) " +
                     "VALUES (seq_event_id.NEXTVAL, ?, ?, ?, ?, 0, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, event.getTitle());
            stmt.setString(2, event.getCategory());
            stmt.setDate(3, event.getEventDate());
            stmt.setInt(4, event.getMaxCapacity());
            stmt.setDouble(5, event.getRegistrationFee());
            stmt.setString(6, event.getVenue());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * PL/SQL FUNCTION CALL: Calls FN_CALCULATE_EVENT_REVENUE(p_event_id).
     * Demonstrates invoking an Oracle stored function using JDBC CallableStatement.
     */
    public double getEventRevenueViaPLSQL(int eventId) throws SQLException {
        String plsql = "{? = CALL FN_CALCULATE_EVENT_REVENUE(?)}";

        try (Connection conn = DatabaseConnection.getConnection();
             CallableStatement cs = conn.prepareCall(plsql)) {

            // Register return parameter (index 1)
            cs.registerOutParameter(1, Types.NUMERIC);
            // Bind input parameter (index 2)
            cs.setInt(2, eventId);

            cs.execute();

            return cs.getDouble(1);
        }
    }
}
