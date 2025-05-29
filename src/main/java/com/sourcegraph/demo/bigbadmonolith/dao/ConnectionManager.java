package com.sourcegraph.demo.bigbadmonolith.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class ConnectionManager {
    private static final String DB_URL = "jdbc:derby:./data/bigbadmonolith;create=true";
    private static final String DB_USER = "app";
    private static final String DB_PASSWORD = "app";
    
    static {
        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            initializeDatabase();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Derby driver not found", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    private static void initializeDatabase() {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Create users table if it doesn't exist
            String createTableSQL = """
                CREATE TABLE users (
                    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
                    email VARCHAR(255) NOT NULL UNIQUE,
                    name VARCHAR(255) NOT NULL,
                    PRIMARY KEY (id)
                )
                """;
            
            try {
                stmt.executeUpdate(createTableSQL);
            } catch (SQLException e) {
                // Table might already exist, ignore error
                if (!e.getSQLState().equals("X0Y32")) {
                    throw e;
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize database", e);
        }
    }
    
    public static void shutdown() {
        try {
            DriverManager.getConnection("jdbc:derby:;shutdown=true");
        } catch (SQLException e) {
            // Expected exception on shutdown
        }
    }
}
