package com.studentevents;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Singleton database connection manager for Oracle Free Database.
 * Connects to Pluggable Database (FREEPDB1) with user student_admin.
 */
public class DatabaseConnection {

    private static String url;
    private static String user;
    private static String password;
    private static String driver;

    static {
        try (InputStream input = DatabaseConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                // Default fallback values for Oracle Free 23c
                System.out.println("[INFO] db.properties not found in classpath, using Oracle Free defaults.");
                url = "jdbc:oracle:thin:@localhost:1521/XE";
                user = "student_admin";
                password = "StudentPass123#";
                driver = "oracle.jdbc.OracleDriver";
            } else {
                prop.load(input);
                url = prop.getProperty("db.url");
                user = prop.getProperty("db.user");
                password = prop.getProperty("db.password");
                driver = prop.getProperty("db.driver", "oracle.jdbc.OracleDriver");
            }

            // Register Oracle JDBC Driver
            Class.forName(driver);
        } catch (Exception ex) {
            System.err.println("[ERROR] Failed to initialize Oracle JDBC Driver: " + ex.getMessage());
        }
    }

    /**
     * Obtains an active connection to Oracle Free database.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Tests the database connection and prints diagnostic information.
     */
    public static boolean testConnection() {
        System.out.println("Testing connection to: " + url + " as user: " + user + "...");
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println(">>> SUCCESS: Connected to Oracle Database successfully!");
                System.out.println(">>> Oracle DB Product: " + conn.getMetaData().getDatabaseProductVersion());
                System.out.println(">>> JDBC Driver:       " + conn.getMetaData().getDriverVersion());
                return true;
            }
        } catch (SQLException e) {
            System.err.println(">>> FAILED to connect to Oracle Database!");
            System.err.println(">>> Error Code: " + e.getErrorCode());
            System.err.println(">>> SQL State:   " + e.getSQLState());
            System.err.println(">>> Message:     " + e.getMessage());
            explainCommonErrors(e.getErrorCode());
        }
        return false;
    }

    private static void explainCommonErrors(int errorCode) {
        switch (errorCode) {
            case 17002 -> System.err.println("[HELP] ORA-12541 / Connection refused: Ensure your Oracle container/service is running on port 1521.");
            case 1017  -> System.err.println("[HELP] ORA-01017: Invalid username/password. Check db.properties or run sql/01_oracle_free_setup.sql.");
            case 12514 -> System.err.println("[HELP] ORA-12514: Service name mismatch. Use 'FREEPDB1' for Oracle 23c Free or 'XE' for Oracle XE.");
            default    -> {}
        }
    }
}
