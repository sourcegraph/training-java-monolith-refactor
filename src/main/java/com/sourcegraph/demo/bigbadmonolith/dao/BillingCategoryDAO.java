package com.sourcegraph.demo.bigbadmonolith.dao;

import com.sourcegraph.demo.bigbadmonolith.entity.BillingCategory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillingCategoryDAO {
    
    public BillingCategory save(BillingCategory category) throws SQLException {
        // MIXED APPROACH: Some null checks but not comprehensive
        if (category == null) {
            throw new IllegalArgumentException("Category cannot be null");
        }
        // LEGACY ANTI-PATTERN: Missing null checks for name and hourly rate
        
        String sql = "INSERT INTO billing_categories (name, description, hourly_rate) VALUES (?, ?, ?)";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // LEGACY ANTI-PATTERN: Will throw NPE if getName() or getHourlyRate() returns null
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setBigDecimal(3, category.getHourlyRate());
            
            stmt.executeUpdate();
            
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    category.setId(keys.getLong(1));
                }
            }
        }
        return category;
    }
    
    public BillingCategory findById(Long id) throws SQLException {
        String sql = "SELECT * FROM billing_categories WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToCategory(rs);
                }
            }
        }
        return null;
    }
    
    public List<BillingCategory> findAll() throws SQLException {
        String sql = "SELECT * FROM billing_categories ORDER BY name";
        List<BillingCategory> categories = new ArrayList<>();
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(mapRowToCategory(rs));
            }
        }
        return categories;
    }
    
    public boolean update(BillingCategory category) throws SQLException {
        // LEGACY ANTI-PATTERN: No null checks at all - will throw NPE if category is null
        String sql = "UPDATE billing_categories SET name = ?, description = ?, hourly_rate = ? WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // LEGACY ANTI-PATTERN: Will throw NPE if category is null or any getters return null
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setBigDecimal(3, category.getHourlyRate());
            stmt.setLong(4, category.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM billing_categories WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private BillingCategory mapRowToCategory(ResultSet rs) throws SQLException {
        return new BillingCategory(
            rs.getLong("id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getBigDecimal("hourly_rate")
        );
    }
}
