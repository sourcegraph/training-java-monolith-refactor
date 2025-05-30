<%@ page import="java.util.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.dao.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.entity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    UserDAO userDAO = new UserDAO();
    String action = request.getParameter("action");
    String message = "";
    
    if ("add".equals(action)) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        
        try {
            User user = new User(name, email);
            userDAO.save(user);
            message = "User added successfully!";
        } catch (Exception e) {
            message = "Error adding user: " + e.getMessage();
        }
    }
%>
<html>
<head>
    <title>User Management - Big Bad Monolith</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .header { background-color: #333; color: white; padding: 20px; text-align: center; }
        .nav { background-color: #666; padding: 10px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; }
        .nav a:hover { text-decoration: underline; }
        .content { background: white; padding: 20px; margin: 20px 0; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 300px; padding: 8px; border: 1px solid #ccc; border-radius: 3px; }
        .btn { background: #007acc; color: white; padding: 10px 15px; border: none; border-radius: 3px; cursor: pointer; }
        .btn:hover { background: #005a9e; }
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
        <h1>User Management</h1>
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
            <div class="message <%= message.contains("Error") ? "error" : "success" %>">
                <%= message %>
            </div>
        <% } %>
        
        <h2>Add New User</h2>
        <form method="post" action="users.jsp">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label for="name">User Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <button type="submit" class="btn">Add User</button>
        </form>
        
        <h2>Existing Users</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Total Hours</th>
                    <th>Total Revenue</th>
                </tr>
            </thead>
            <tbody>
                <%
                    BillableHourDAO billableHourDAO = new BillableHourDAO();
                    BillingCategoryDAO categoryDAO = new BillingCategoryDAO();
                    
                    try {
                        List<User> users = userDAO.findAll();
                        List<BillableHour> allBillableHours = billableHourDAO.findAll();
                        List<BillingCategory> categories = categoryDAO.findAll();
                        
                        Map<Long, BillingCategory> categoryMap = new HashMap<>();
                        for (BillingCategory category : categories) {
                            categoryMap.put(category.getId(), category);
                        }
                        
                        for (User user : users) {
                            double totalHours = 0.0;
                            double totalRevenue = 0.0;
                            
                            for (BillableHour hour : allBillableHours) {
                                if (hour.getUserId().equals(user.getId())) {
                                    totalHours += hour.getHours().doubleValue();
                                    BillingCategory category = categoryMap.get(hour.getCategoryId());
                                    if (category != null) {
                                        totalRevenue += hour.getHours().doubleValue() * category.getHourlyRate().doubleValue();
                                    }
                                }
                            }
                %>
                    <tr>
                        <td><%= user.getId() %></td>
                        <td><%= user.getName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= String.format("%.2f", totalHours) %></td>
                        <td>$<%= String.format("%.2f", totalRevenue) %></td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        System.out.println("<tr><td colspan='5'>Error loading users: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
        

    </div>
</body>
</html>
