<%@ page import="java.util.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.dao.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.entity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    CustomerDAO customerDAO = new CustomerDAO();
    UserDAO userDAO = new UserDAO();
    BillableHourDAO billableHourDAO = new BillableHourDAO();
    BillingCategoryDAO categoryDAO = new BillingCategoryDAO();
    
    int totalCustomers = 0;
    int totalUsers = 0;
    double totalRevenue = 0.0;
    
    try {
        List<Customer> customers = customerDAO.findAll();
        totalCustomers = customers.size();
        
        List<User> users = userDAO.findAll();
        totalUsers = users.size();
        
        List<BillableHour> billableHours = billableHourDAO.findAll();
        List<BillingCategory> categories = categoryDAO.findAll();
        
        // Create a map for quick category lookup
        Map<Long, BillingCategory> categoryMap = new HashMap<>();
        for (BillingCategory category : categories) {
            categoryMap.put(category.getId(), category);
        }
        
        // Calculate total revenue
        for (BillableHour hour : billableHours) {
            BillingCategory category = categoryMap.get(hour.getCategoryId());
            if (category != null && hour.getHours() != null) {
                totalRevenue += hour.getHours().doubleValue() * category.getHourlyRate().doubleValue();
            }
        }
        
    } catch (Exception e) {
        out.println("Database error: " + e.getMessage());
    }
%>
<html>
<head>
    <title>Big Bad Monolith - Time Tracker</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .header { background-color: #333; color: white; padding: 20px; text-align: center; }
        .nav { background-color: #666; padding: 10px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; }
        .nav a:hover { text-decoration: underline; }
        .dashboard { display: flex; gap: 20px; margin: 20px 0; }
        .card { background: white; border: 1px solid #ddd; padding: 20px; border-radius: 5px; flex: 1; }
        .card h3 { margin-top: 0; color: #333; }
        .number { font-size: 2em; font-weight: bold; color: #007acc; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Big Bad Monolith Time Tracker</h1>
        <p>Legacy JSP Interface - Needs Modernization!</p>
    </div>
    
    <div class="nav">
        <a href="index.jsp">Dashboard</a>
        <a href="customers.jsp">Customers</a>
        <a href="users.jsp">Users</a>
        <a href="categories.jsp">Billing Categories</a>
        <a href="hours.jsp">Log Hours</a>
        <a href="reports.jsp">Reports</a>
    </div>
    
    <div class="dashboard">
        <div class="card">
            <h3>Total Customers</h3>
            <div class="number"><%= totalCustomers %></div>
        </div>
        <div class="card">
            <h3>Total Users</h3>
            <div class="number"><%= totalUsers %></div>
        </div>
        <div class="card">
            <h3>Total Revenue</h3>
            <div class="number">$<%= String.format("%.2f", totalRevenue) %></div>
        </div>
    </div>
    
    <div style="background: white; padding: 20px; border: 1px solid #ddd; border-radius: 5px;">
        <h2>Welcome to the Legacy Time Tracker</h2>

    </div>
</body>
</html>
