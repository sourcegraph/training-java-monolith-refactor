package com.sourcegraph.demo.bigbadmonolith.dao;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Liberty-specific connection manager that uses JNDI data sources
 * This is a more enterprise-appropriate approach for Liberty deployment
 */
public class LibertyConnectionManager {
    private static final String JNDI_NAME = "jdbc/DefaultDataSource";
    private static DataSource dataSource;
    
    static {
        try {
            initializeDataSource();
        } catch (Exception e) {
            // Fall back to embedded ConnectionManager for development
            System.err.println("Failed to initialize Liberty DataSource, falling back to embedded Derby: " + e.getMessage());
        }
    }
    
    private static void initializeDataSource() throws NamingException {
        InitialContext ctx = new InitialContext();
        dataSource = (DataSource) ctx.lookup(JNDI_NAME);
        System.out.println("Successfully initialized Liberty DataSource from JNDI: " + JNDI_NAME);
    }
    
    public static Connection getConnection() throws SQLException {
        if (dataSource != null) {
            return dataSource.getConnection();
        } else {
            // Fall back to embedded ConnectionManager
            return ConnectionManager.getConnection();
        }
    }
    
    public static boolean isLibertyDataSourceAvailable() {
        return dataSource != null;
    }
    
    // Initialize database schema if using Liberty DataSource
    public static void initializeDatabaseSchema() {
        if (!isLibertyDataSourceAvailable()) {
            return; // Let the embedded ConnectionManager handle this
        }
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Create users table if it doesn't exist
            String createUsersTableSQL = """
                CREATE TABLE users (
                    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
                    email VARCHAR(255) NOT NULL UNIQUE,
                    name VARCHAR(255) NOT NULL,
                    PRIMARY KEY (id)
                )
                """;
            
            // Create customers table if it doesn't exist
            String createCustomersTableSQL = """
                CREATE TABLE customers (
                    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
                    name VARCHAR(255) NOT NULL,
                    email VARCHAR(255) NOT NULL,
                    address VARCHAR(500),
                    created_at TIMESTAMP NOT NULL,
                    PRIMARY KEY (id)
                )
                """;
            
            // Create billing_categories table if it doesn't exist
            String createBillingCategoriesTableSQL = """
                CREATE TABLE billing_categories (
                    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
                    name VARCHAR(255) NOT NULL,
                    description VARCHAR(500),
                    hourly_rate DECIMAL(10,2) NOT NULL,
                    PRIMARY KEY (id)
                )
                """;
            
            // Create billable_hours table if it doesn't exist
            String createBillableHoursTableSQL = """
                CREATE TABLE billable_hours (
                    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
                    customer_id BIGINT NOT NULL,
                    user_id BIGINT NOT NULL,
                    category_id BIGINT NOT NULL,
                    hours DECIMAL(8,2) NOT NULL,
                    note VARCHAR(1000),
                    date_logged DATE NOT NULL,
                    created_at TIMESTAMP NOT NULL,
                    PRIMARY KEY (id),
                    FOREIGN KEY (customer_id) REFERENCES customers(id),
                    FOREIGN KEY (user_id) REFERENCES users(id),
                    FOREIGN KEY (category_id) REFERENCES billing_categories(id)
                )
                """;
            
            createTableIfNotExists(stmt, createUsersTableSQL);
            createTableIfNotExists(stmt, createCustomersTableSQL);
            createTableIfNotExists(stmt, createBillingCategoriesTableSQL);
            createTableIfNotExists(stmt, createBillableHoursTableSQL);
            
            System.out.println("Database schema initialized successfully via Liberty DataSource");
            
        } catch (SQLException e) {
            System.err.println("Failed to initialize database schema via Liberty DataSource: " + e.getMessage());
            throw new RuntimeException("Failed to initialize database", e);
        }
    }
    
    private static void createTableIfNotExists(Statement stmt, String createTableSQL) throws SQLException {
        try {
            stmt.executeUpdate(createTableSQL);
        } catch (SQLException e) {
            // Table might already exist, ignore error
            if (!e.getSQLState().equals("X0Y32")) {
                throw e;
            }
        }
    }
}
