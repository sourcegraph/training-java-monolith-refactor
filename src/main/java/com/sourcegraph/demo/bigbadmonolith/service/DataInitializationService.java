package com.sourcegraph.demo.bigbadmonolith.service;

import com.sourcegraph.demo.bigbadmonolith.dao.BillableHourDAO;
import com.sourcegraph.demo.bigbadmonolith.dao.BillingCategoryDAO;
import com.sourcegraph.demo.bigbadmonolith.dao.CustomerDAO;
import com.sourcegraph.demo.bigbadmonolith.dao.UserDAO;
import com.sourcegraph.demo.bigbadmonolith.entity.BillableHour;
import com.sourcegraph.demo.bigbadmonolith.entity.BillingCategory;
import com.sourcegraph.demo.bigbadmonolith.entity.Customer;
import com.sourcegraph.demo.bigbadmonolith.entity.User;
import org.joda.time.LocalDate;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class DataInitializationService {
    
    private UserDAO userDAO = new UserDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private BillingCategoryDAO categoryDAO = new BillingCategoryDAO();
    private BillableHourDAO billableHourDAO = new BillableHourDAO();
    
    public void initializeSampleData() throws SQLException {
        // Check if data already exists
        List<User> existingUsers = userDAO.findAll();
        if (!existingUsers.isEmpty()) {
            return; // Data already initialized
        }
        
        // Create sample users
        User user1 = userDAO.save(new User("john.doe@example.com", "John Doe"));
        User user2 = userDAO.save(new User("jane.smith@example.com", "Jane Smith"));
        
        // Create sample customers
        Customer customer1 = customerDAO.save(new Customer("Acme Corp", "billing@acme.com", "123 Business St"));
        Customer customer2 = customerDAO.save(new Customer("TechStart Inc", "finance@techstart.com", "456 Innovation Ave"));
        Customer customer3 = customerDAO.save(new Customer("MegaCorp Ltd", "accounts@megacorp.com", "789 Enterprise Blvd"));
        
        // Create billing categories
        BillingCategory devCategory = categoryDAO.save(new BillingCategory("Development", "Software development work", new BigDecimal("150.00")));
        BillingCategory consultingCategory = categoryDAO.save(new BillingCategory("Consulting", "Business consulting services", new BigDecimal("200.00")));
        BillingCategory supportCategory = categoryDAO.save(new BillingCategory("Support", "Technical support and maintenance", new BigDecimal("100.00")));
        
        // Create sample billable hours
        billableHourDAO.save(new BillableHour(customer1.getId(), user1.getId(), devCategory.getId(), 
                new BigDecimal("8.50"), "Implemented user authentication module", LocalDate.now().minusDays(5)));
        
        billableHourDAO.save(new BillableHour(customer1.getId(), user2.getId(), consultingCategory.getId(), 
                new BigDecimal("4.00"), "Requirements gathering session", LocalDate.now().minusDays(3)));
        
        billableHourDAO.save(new BillableHour(customer2.getId(), user1.getId(), devCategory.getId(), 
                new BigDecimal("6.75"), "Database schema design and implementation", LocalDate.now().minusDays(2)));
        
        billableHourDAO.save(new BillableHour(customer2.getId(), user2.getId(), supportCategory.getId(), 
                new BigDecimal("2.25"), "Bug fix in payment processing", LocalDate.now().minusDays(1)));
        
        billableHourDAO.save(new BillableHour(customer3.getId(), user1.getId(), consultingCategory.getId(), 
                new BigDecimal("3.50"), "Architecture review and recommendations", LocalDate.now()));
        
        billableHourDAO.save(new BillableHour(customer3.getId(), user2.getId(), devCategory.getId(), 
                new BigDecimal("7.25"), "API endpoint development", LocalDate.now()));
    }
}
