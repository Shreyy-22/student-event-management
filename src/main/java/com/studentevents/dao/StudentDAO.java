package com.studentevents.dao;

import com.studentevents.DatabaseConnection;
import com.studentevents.model.Student;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public List<Student> getAllStudents() throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT student_id, full_name, email, major, year_of_study, phone FROM students ORDER BY student_id ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(new Student(
                    rs.getInt("student_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("major"),
                    rs.getInt("year_of_study"),
                    rs.getString("phone")
                ));
            }
        }
        return list;
    }

    public boolean addStudent(Student student) throws SQLException {
        String sql = "INSERT INTO students (student_id, full_name, email, major, year_of_study, phone) " +
                     "VALUES (seq_student_id.NEXTVAL, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, student.getFullName());
            stmt.setString(2, student.getEmail());
            stmt.setString(3, student.getMajor());
            stmt.setInt(4, student.getYearOfStudy());
            stmt.setString(5, student.getPhone());

            return stmt.executeUpdate() > 0;
        }
    }
}
