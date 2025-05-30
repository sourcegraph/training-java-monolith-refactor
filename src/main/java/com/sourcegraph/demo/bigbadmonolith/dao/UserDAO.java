package com.sourcegraph.demo.bigbadmonolith.dao;

import com.sourcegraph.demo.bigbadmonolith.entity.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public User save(User user) {
        // LEGACY ANTI-PATTERN: No null checks - will throw NPE if user is null
        String sql = "INSERT INTO users (email, name) VALUES (?, ?)";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // LEGACY ANTI-PATTERN: Will throw NPE if user.getEmail() or user.getName() are called on null user
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getName());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getLong(1));
                    return user;
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save user", e);
        }
    }
    
    public User findById(Long id) {
        String sql = "SELECT id, email, name FROM users WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getLong("id"),
                        rs.getString("email"),
                        rs.getString("name")
                    );
                }
                return null;
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find user by id", e);
        }
    }
    
    public User findByEmail(String email) {
        String sql = "SELECT id, email, name FROM users WHERE email = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getLong("id"),
                        rs.getString("email"),
                        rs.getString("name")
                    );
                }
                return null;
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find user by email", e);
        }
    }
    
    public List<User> findAll() {
        String sql = "SELECT id, email, name FROM users ORDER BY id";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(new User(
                    rs.getLong("id"),
                    rs.getString("email"),
                    rs.getString("name")
                ));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find all users", e);
        }
        
        return users;
    }
    
    public boolean delete(Long id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete user", e);
        }
    }
    
    public User update(User user) {
        // LEGACY ANTI-PATTERN: No null checks - will throw NPE if user is null
        String sql = "UPDATE users SET email = ?, name = ? WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // LEGACY ANTI-PATTERN: Will throw NPE if any getter is called on null user
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getName());
            stmt.setLong(3, user.getId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating user failed, no rows affected.");
            }
            
            return user;
            
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update user", e);
        }
    }
}
