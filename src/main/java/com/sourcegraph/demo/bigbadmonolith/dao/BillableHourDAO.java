package com.sourcegraph.demo.bigbadmonolith.dao;

import com.sourcegraph.demo.bigbadmonolith.entity.BillableHour;
import org.joda.time.DateTime;
import org.joda.time.LocalDate;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillableHourDAO {
    
    public BillableHour save(BillableHour billableHour) throws SQLException {
        String sql = "INSERT INTO billable_hours (customer_id, user_id, category_id, hours, note, date_logged, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, billableHour.getCustomerId());
            stmt.setLong(2, billableHour.getUserId());
            stmt.setLong(3, billableHour.getCategoryId());
            stmt.setBigDecimal(4, billableHour.getHours());
            stmt.setString(5, billableHour.getNote());
            stmt.setDate(6, new Date(billableHour.getDateLogged().toDateTimeAtStartOfDay().getMillis()));
            stmt.setTimestamp(7, new Timestamp((billableHour.getCreatedAt() != null ? billableHour.getCreatedAt() : DateTime.now()).getMillis()));
            
            stmt.executeUpdate();
            
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    billableHour.setId(keys.getLong(1));
                }
            }
        }
        return billableHour;
    }
    
    public BillableHour findById(Long id) throws SQLException {
        String sql = "SELECT * FROM billable_hours WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToBillableHour(rs);
                }
            }
        }
        return null;
    }
    
    public List<BillableHour> findByCustomerId(Long customerId) throws SQLException {
        String sql = "SELECT * FROM billable_hours WHERE customer_id = ? ORDER BY date_logged DESC";
        List<BillableHour> hours = new ArrayList<>();
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    hours.add(mapRowToBillableHour(rs));
                }
            }
        }
        return hours;
    }
    
    public List<BillableHour> findByUserId(Long userId) throws SQLException {
        String sql = "SELECT * FROM billable_hours WHERE user_id = ? ORDER BY date_logged DESC";
        List<BillableHour> hours = new ArrayList<>();
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    hours.add(mapRowToBillableHour(rs));
                }
            }
        }
        return hours;
    }
    
    public List<BillableHour> findAll() throws SQLException {
        String sql = "SELECT * FROM billable_hours ORDER BY date_logged DESC";
        List<BillableHour> hours = new ArrayList<>();
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                hours.add(mapRowToBillableHour(rs));
            }
        }
        return hours;
    }
    
    public boolean update(BillableHour billableHour) throws SQLException {
        String sql = "UPDATE billable_hours SET customer_id = ?, user_id = ?, category_id = ?, hours = ?, note = ?, date_logged = ? WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, billableHour.getCustomerId());
            stmt.setLong(2, billableHour.getUserId());
            stmt.setLong(3, billableHour.getCategoryId());
            stmt.setBigDecimal(4, billableHour.getHours());
            stmt.setString(5, billableHour.getNote());
            stmt.setDate(6, new Date(billableHour.getDateLogged().toDateTimeAtStartOfDay().getMillis()));
            stmt.setLong(7, billableHour.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM billable_hours WHERE id = ?";
        
        try (Connection conn = LibertyConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private BillableHour mapRowToBillableHour(ResultSet rs) throws SQLException {
        return new BillableHour(
            rs.getLong("id"),
            rs.getLong("customer_id"),
            rs.getLong("user_id"),
            rs.getLong("category_id"),
            rs.getBigDecimal("hours"),
            rs.getString("note"),
            LocalDate.fromDateFields(rs.getDate("date_logged")),
            new DateTime(rs.getTimestamp("created_at"))
        );
    }
}
