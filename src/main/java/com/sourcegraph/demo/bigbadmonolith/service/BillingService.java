package com.sourcegraph.demo.bigbadmonolith.service;

import com.sourcegraph.demo.bigbadmonolith.dao.BillableHourDAO;
import com.sourcegraph.demo.bigbadmonolith.dao.BillingCategoryDAO;
import com.sourcegraph.demo.bigbadmonolith.dao.CustomerDAO;
import com.sourcegraph.demo.bigbadmonolith.entity.BillableHour;
import com.sourcegraph.demo.bigbadmonolith.entity.BillingCategory;
import com.sourcegraph.demo.bigbadmonolith.entity.Customer;
import com.sourcegraph.demo.bigbadmonolith.util.DateTimeUtils;
import org.joda.time.LocalDate;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BillingService {
    
    private BillableHourDAO billableHourDAO = new BillableHourDAO();
    private BillingCategoryDAO categoryDAO = new BillingCategoryDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    
    public Map<String, Object> generateCustomerBill(Long customerId) throws SQLException {
        Customer customer = customerDAO.findById(customerId);
        if (customer == null) {
            throw new RuntimeException("Customer not found");
        }
        
        List<BillableHour> hours = billableHourDAO.findByCustomerId(customerId);
        
        BigDecimal totalAmount = BigDecimal.ZERO;
        BigDecimal totalHours = BigDecimal.ZERO;
        
        for (BillableHour hour : hours) {
            BillingCategory category = categoryDAO.findById(hour.getCategoryId());
            if (category != null) {
                BigDecimal lineAmount = hour.getHours().multiply(category.getHourlyRate());
                totalAmount = totalAmount.add(lineAmount);
                totalHours = totalHours.add(hour.getHours());
            }
        }
        
        Map<String, Object> bill = new HashMap<>();
        bill.put("customer", customer);
        bill.put("billableHours", hours);
        bill.put("totalHours", totalHours);
        bill.put("totalAmount", totalAmount);
        bill.put("generatedDate", DateTimeUtils.getCurrentDateAndLog());
        
        return bill;
    }
    
    public Map<String, Object> generateMonthlyReport(int year, int month) throws SQLException {
        List<BillableHour> allHours = billableHourDAO.findAll();
        
        BigDecimal totalRevenue = BigDecimal.ZERO;
        BigDecimal totalHours = BigDecimal.ZERO;
        Map<String, BigDecimal> revenueByCategory = new HashMap<>();
        
        for (BillableHour hour : allHours) {
            LocalDate dateLogged = hour.getDateLogged();
            if (dateLogged.getYear() == year && dateLogged.getMonthOfYear() == month) {
                BillingCategory category = categoryDAO.findById(hour.getCategoryId());
                if (category != null) {
                    BigDecimal lineAmount = hour.getHours().multiply(category.getHourlyRate());
                    totalRevenue = totalRevenue.add(lineAmount);
                    totalHours = totalHours.add(hour.getHours());
                    
                    String categoryName = category.getName();
                    BigDecimal categoryRevenue = revenueByCategory.getOrDefault(categoryName, BigDecimal.ZERO);
                    revenueByCategory.put(categoryName, categoryRevenue.add(lineAmount));
                }
            }
        }
        
        Map<String, Object> report = new HashMap<>();
        report.put("year", year);
        report.put("month", month);
        report.put("totalRevenue", totalRevenue);
        report.put("totalHours", totalHours);
        report.put("revenueByCategory", revenueByCategory);
        report.put("generatedDate", LocalDate.now());
        
        return report;
    }
    
    // This method intentionally has poor error handling for training purposes
    public String validateBillableHour(BillableHour hour) {
        String validationErrors = "";
        
        try {
            Customer customer = customerDAO.findById(hour.getCustomerId());
            if (customer == null) {
                validationErrors += "Invalid customer ID. ";
            }
        } catch (SQLException e) {
            validationErrors += "Database error checking customer. ";
        }
        
        try {
            BillingCategory category = categoryDAO.findById(hour.getCategoryId());
            if (category == null) {
                validationErrors += "Invalid category ID. ";
            }
        } catch (SQLException e) {
            validationErrors += "Database error checking category. ";
        }
        
        if (hour.getHours() == null || hour.getHours().compareTo(BigDecimal.ZERO) <= 0) {
            validationErrors += "Hours must be greater than zero. ";
        }
        
        if (hour.getDateLogged() == null) {
            validationErrors += "Date logged is required. ";
        } else if (hour.getDateLogged().isAfter(LocalDate.now())) {
            validationErrors += "Date logged cannot be in the future. ";
        } else if (!DateTimeUtils.isWorkingDay(hour.getDateLogged())) {
            validationErrors += "Warning: Hours logged on weekend. ";
        }
        
        return validationErrors.trim();
    }
}
