<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.dao.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.entity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BillingCategoryDAO categoryDAO = new BillingCategoryDAO();
    String action = request.getParameter("action");
    String message = "";
    
    if ("add".equals(action)) {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String hourlyRateStr = request.getParameter("hourlyRate");
        
        try {
            BigDecimal hourlyRate = new BigDecimal(hourlyRateStr);
            BillingCategory category = new BillingCategory(name, description, hourlyRate);
            categoryDAO.save(category);
            message = "Billing category added successfully!";
        } catch (NumberFormatException e) {
            message = "Error: Invalid hourly rate format";
        } catch (Exception e) {
            message = "Error adding category: " + e.getMessage();
        }
    }
    
    if ("update".equals(action)) {
        String id = request.getParameter("id");
        String hourlyRateStr = request.getParameter("newRate");
        
        try {
            Long categoryId = Long.parseLong(id);
            BigDecimal newRate = new BigDecimal(hourlyRateStr);
            
            BillingCategory category = categoryDAO.findById(categoryId);
            if (category != null) {
                category.setHourlyRate(newRate);
                categoryDAO.update(category);
                message = "Hourly rate updated successfully!";
            } else {
                message = "Error: Category not found";
            }
        } catch (NumberFormatException e) {
            message = "Error: Invalid ID or rate format";
        } catch (Exception e) {
            message = "Error updating rate: " + e.getMessage();
        }
    }
%>
<html>
<head>
    <title>Billing Categories - Big Bad Monolith</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .header { background-color: #333; color: white; padding: 20px; text-align: center; }
        .nav { background-color: #666; padding: 10px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; }
        .nav a:hover { text-decoration: underline; }
        .content { background: white; padding: 20px; margin: 20px 0; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea { width: 300px; padding: 8px; border: 1px solid #ccc; border-radius: 3px; }
        .form-group textarea { height: 60px; resize: vertical; }
        .btn { background: #007acc; color: white; padding: 10px 15px; border: none; border-radius: 3px; cursor: pointer; }
        .btn:hover { background: #005a9e; }
        .btn-small { background: #ffc107; color: black; padding: 5px 10px; font-size: 12px; }
        .btn-small:hover { background: #e0a800; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        .message { padding: 10px; margin: 10px 0; border-radius: 3px; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .inline-form { display: inline-block; margin-left: 10px; }
        .inline-form input { width: 80px; padding: 3px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Billing Categories</h1>
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
        
        <h2>Add New Billing Category</h2>
        <form method="post" action="categories.jsp">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label for="name">Category Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description"></textarea>
            </div>
            <div class="form-group">
                <label for="hourlyRate">Hourly Rate ($):</label>
                <input type="number" id="hourlyRate" name="hourlyRate" step="0.01" min="0" required>
            </div>
            <button type="submit" class="btn">Add Category</button>
        </form>
        
        <h2>Existing Categories</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Hourly Rate</th>
                    <th>Total Hours</th>
                    <th>Total Revenue</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    BillableHourDAO billableHourDAO = new BillableHourDAO();
                    
                    try {
                        List<BillingCategory> categories = categoryDAO.findAll();
                        List<BillableHour> allBillableHours = billableHourDAO.findAll();
                        
                        categories.sort((c1, c2) -> c1.getName().compareTo(c2.getName()));
                        
                        for (BillingCategory category : categories) {
                            double totalHours = 0.0;
                            double totalRevenue = 0.0;
                            
                            for (BillableHour hour : allBillableHours) {
                                if (hour.getCategoryId().equals(category.getId())) {
                                    totalHours += hour.getHours().doubleValue();
                                    totalRevenue += hour.getHours().doubleValue() * category.getHourlyRate().doubleValue();
                                }
                            }
                %>
                    <tr>
                        <td><%= category.getId() %></td>
                        <td><%= category.getName() %></td>
                        <td><%= category.getDescription() != null ? category.getDescription() : "" %></td>
                        <td>$<%= String.format("%.2f", category.getHourlyRate()) %></td>
                        <td><%= String.format("%.2f", totalHours) %></td>
                        <td>$<%= String.format("%.2f", totalRevenue) %></td>
                        <td>
                            <form method="post" action="categories.jsp" class="inline-form">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="<%= category.getId() %>">
                                $<input type="number" name="newRate" step="0.01" value="<%= category.getHourlyRate() %>" required>
                                <button type="submit" class="btn btn-small">Update Rate</button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        System.out.println("<tr><td colspan='7'>Error loading categories: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
        

    </div>
</body>
</html>
