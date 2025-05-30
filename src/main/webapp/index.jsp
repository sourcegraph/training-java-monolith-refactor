<%@ page import="java.util.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.dao.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.entity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // LEGACY ANTI-PATTERN: DAO instantiation and business logic in JSP
    CustomerDAO customerDAO = new CustomerDAO();
    UserDAO userDAO = new UserDAO();
    BillableHourDAO billableHourDAO = new BillableHourDAO();
    BillingCategoryDAO categoryDAO = new BillingCategoryDAO();
    
    int totalCustomers = 0;
    int totalUsers = 0;
    double totalRevenue = 0.0;
    
    try {
        // LEGACY ANTI-PATTERN: Business logic calculations in presentation layer
        List<Customer> customers = customerDAO.findAll();
        totalCustomers = customers.size();
        
        List<User> users = userDAO.findAll();
        totalUsers = users.size();
        
        // LEGACY ANTI-PATTERN: Complex revenue calculation in JSP
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
        // LEGACY ANTI-PATTERN: Poor error handling
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
        <p><strong>Training Mission:</strong> This application is a perfect example of how NOT to build modern web applications. Your task is to identify and understand the anti-patterns before learning to fix them.</p>
        
        <div style="background: #f8f9fa; padding: 15px; margin: 15px 0; border-radius: 5px;">
            <h3>🎓 Learning Objectives</h3>
            <p>As you explore each page, look for:</p>
            <ul>
                <li><strong>Architectural Issues:</strong> Where is business logic located?</li>
                <li><strong>Security Vulnerabilities:</strong> How is user input handled?</li>
                <li><strong>Performance Problems:</strong> When and how often does database access occur?</li>
                <li><strong>Maintainability Issues:</strong> How hard would it be to make changes?</li>
                <li><strong>Testing Challenges:</strong> How would you unit test this code?</li>
            </ul>
        </div>
        
        <div style="background: #e7f3ff; padding: 10px; margin: 10px 0; border-radius: 5px;">
            <strong>🔬 Pro Tip:</strong> Use Sourcegraph search queries like <code>content:"DriverManager.getConnection" file:.jsp</code> to find database connections in presentation layers across the codebase.
        </div>
        
        <p><strong>Explore the Anti-Patterns:</strong></p>
        <p>
            <a href="customers.jsp" style="background: #007acc; color: white; padding: 10px 15px; text-decoration: none; border-radius: 3px;">Customer Management</a>
            <a href="hours.jsp" style="background: #28a745; color: white; padding: 10px 15px; text-decoration: none; border-radius: 3px; margin-left: 10px;">Hours Logging</a>
            <a href="reports.jsp" style="background: #ffc107; color: black; padding: 10px 15px; text-decoration: none; border-radius: 3px; margin-left: 10px;">Reporting Module</a>
        </p>
    </div>
</body>
</html>
