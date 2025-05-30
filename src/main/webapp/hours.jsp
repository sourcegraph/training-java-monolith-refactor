<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.joda.time.LocalDate" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.dao.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.entity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BillableHourDAO billableHourDAO = new BillableHourDAO();
    CustomerDAO customerDAO = new CustomerDAO();
    UserDAO userDAO = new UserDAO();
    BillingCategoryDAO categoryDAO = new BillingCategoryDAO();
    
    String action = request.getParameter("action");
    String message = "";
    
    if ("log".equals(action)) {
        String customerIdStr = request.getParameter("customerId");
        String userIdStr = request.getParameter("userId");
        String categoryIdStr = request.getParameter("categoryId");
        String hoursStr = request.getParameter("hours");
        String note = request.getParameter("note");
        String dateStr = request.getParameter("date");
        
        boolean isValid = true;
        StringBuilder errors = new StringBuilder();
        
        if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
            errors.append("Customer is required. ");
            isValid = false;
        }
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            errors.append("User is required. ");
            isValid = false;
        }
        if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            errors.append("Category is required. ");
            isValid = false;
        }
        if (hoursStr == null || hoursStr.trim().isEmpty()) {
            errors.append("Hours is required. ");
            isValid = false;
        }
        
        if (isValid) {
            try {
                LocalDate logDate;
                if (dateStr != null && !dateStr.trim().isEmpty()) {
                    logDate = LocalDate.parse(dateStr);
                } else {
                    logDate = LocalDate.now();
                }
                
                Long customerId = Long.parseLong(customerIdStr);
                Long userId = Long.parseLong(userIdStr);
                Long categoryId = Long.parseLong(categoryIdStr);
                BigDecimal hours = new BigDecimal(hoursStr);
                
                BillableHour billableHour = new BillableHour(customerId, userId, categoryId, hours, note, logDate);
                billableHourDAO.save(billableHour);
                message = "Hours logged successfully!";
            } catch (Exception e) {
                message = "Error logging hours: " + e.getMessage();
            }
        } else {
            message = "Validation errors: " + errors.toString();
        }
    }
%>
<html>
<head>
    <title>Log Hours - Big Bad Monolith</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .header { background-color: #333; color: white; padding: 20px; text-align: center; }
        .nav { background-color: #666; padding: 10px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; }
        .nav a:hover { text-decoration: underline; }
        .content { background: white; padding: 20px; margin: 20px 0; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group select, .form-group textarea { 
            width: 300px; padding: 8px; border: 1px solid #ccc; border-radius: 3px; 
        }
        .form-group textarea { height: 80px; resize: vertical; }
        .btn { background: #28a745; color: white; padding: 10px 15px; border: none; border-radius: 3px; cursor: pointer; }
        .btn:hover { background: #218838; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        .message { padding: 10px; margin: 10px 0; border-radius: 3px; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Log Billable Hours</h1>
    </div>
    
    <div class="nav">
        <a href="index.jsp">Dashboard</a>
        <a href="customers.jsp">Customers</a>
        <a href="users.jsp">Users</a>
        <a href="categories.jsp">Billing Categories</a>
        <a href="hours.jsp">Log Hours</a>
        <a href="reports.jsp">Reports</a>
    </div>
    
    <div class="content">
        <% if (!message.isEmpty()) { %>
            <div class="message <%= message.contains("Error") || message.contains("Validation") ? "error" : "success" %>">
                <%= message %>
            </div>
        <% } %>
        
        <h2>Log New Hours</h2>
        <form method="post" action="hours.jsp">
            <input type="hidden" name="action" value="log">
            
            <div class="form-group">
                <label for="customerId">Customer:</label>
                <select id="customerId" name="customerId" required>
                    <option value="">Select Customer</option>
                    <%
                        try {
                            List<Customer> customers = customerDAO.findAll();
                            for (Customer customer : customers) {
                                System.out.println("<option value='" + customer.getId() + "'>" + 
                                          customer.getName() + "</option>");
                            }
                        } catch (Exception e) {
                            System.out.println("<option value=''>Error loading customers</option>");
                        }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="userId">User:</label>
                <select id="userId" name="userId" required>
                    <option value="">Select User</option>
                    <%
                        try {
                            List<User> users = userDAO.findAll();
                            for (User user : users) {
                                System.out.println("<option value='" + user.getId() + "'>" + 
                                          user.getName() + "</option>");
                            }
                        } catch (Exception e) {
                            System.out.println("<option value=''>Error loading users</option>");
                        }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="categoryId">Billing Category:</label>
                <select id="categoryId" name="categoryId" required>
                    <option value="">Select Category</option>
                    <%
                        try {
                            List<BillingCategory> categories = categoryDAO.findAll();
                            for (BillingCategory category : categories) {
                                System.out.println("<option value='" + category.getId() + "'>" + 
                                          category.getName() + " ($" + category.getHourlyRate() + "/hr)</option>");
                            }
                        } catch (Exception e) {
                            System.out.println("<option value=''>Error loading categories</option>");
                        }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="hours">Hours Worked:</label>
                <input type="number" id="hours" name="hours" step="0.25" min="0" max="24" required>
            </div>
            
            <div class="form-group">
                <label for="date">Date:</label>
                <input type="date" id="date" name="date" value="<%= LocalDate.now().toString() %>">
            </div>
            
            <div class="form-group">
                <label for="note">Work Description:</label>
                <textarea id="note" name="note" placeholder="Describe the work performed..."></textarea>
            </div>
            
            <button type="submit" class="btn">Log Hours</button>
        </form>
        
        <h2>Recent Hours</h2>
        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Customer</th>
                    <th>User</th>
                    <th>Category</th>
                    <th>Hours</th>
                    <th>Rate</th>
                    <th>Total</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        List<BillableHour> recentHours = billableHourDAO.findAll();
                        List<Customer> customers = customerDAO.findAll();
                        List<User> users = userDAO.findAll();
                        List<BillingCategory> categories = categoryDAO.findAll();
                        
                        Map<Long, Customer> customerMap = new HashMap<>();
                        Map<Long, User> userMap = new HashMap<>();
                        Map<Long, BillingCategory> categoryMap = new HashMap<>();
                        
                        for (Customer customer : customers) {
                            customerMap.put(customer.getId(), customer);
                        }
                        for (User user : users) {
                            userMap.put(user.getId(), user);
                        }
                        for (BillingCategory category : categories) {
                            categoryMap.put(category.getId(), category);
                        }
                        
                        recentHours.sort((h1, h2) -> {
                            int dateCompare = h2.getDateLogged().compareTo(h1.getDateLogged());
                            if (dateCompare != 0) return dateCompare;
                            return h2.getCreatedAt().compareTo(h1.getCreatedAt());
                        });
                        
                        int count = 0;
                        for (BillableHour hour : recentHours) {
                            if (count >= 20) break;
                            
                            Customer customer = customerMap.get(hour.getCustomerId());
                            User user = userMap.get(hour.getUserId());
                            BillingCategory category = categoryMap.get(hour.getCategoryId());
                            
                            if (customer != null && user != null && category != null) {
                                double total = hour.getHours().doubleValue() * category.getHourlyRate().doubleValue();
                %>
                    <tr>
                        <td><%= hour.getDateLogged().toString() %></td>
                        <td><%= customer.getName() %></td>
                        <td><%= user.getName() %></td>
                        <td><%= category.getName() %></td>
                        <td><%= hour.getHours() %></td>
                        <td>$<%= String.format("%.2f", category.getHourlyRate()) %></td>
                        <td>$<%= String.format("%.2f", total) %></td>
                        <td><%= hour.getNote() != null ? hour.getNote() : "" %></td>
                    </tr>
                <%
                                count++;
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("<tr><td colspan='8'>Error loading recent hours: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
        

    </div>
</body>
</html>
