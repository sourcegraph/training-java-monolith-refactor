<%@ page import="java.util.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.dao.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.entity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    CustomerDAO customerDAO = new CustomerDAO();
    String action = request.getParameter("action");
    String message = "";
    
    if ("add".equals(action)) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        
        try {
            Customer customer = new Customer(name, email, address);
            customerDAO.save(customer);
            message = "Customer added successfully!";
        } catch (Exception e) {
            message = "Error adding customer: " + e.getMessage();
        }
    }
    
    if ("delete".equals(action)) {
        String id = request.getParameter("id");
        try {
            Long customerId = Long.parseLong(id);
            customerDAO.delete(customerId);
            message = "Customer deleted!";
        } catch (NumberFormatException e) {
            message = "Error: Invalid customer ID format";
        } catch (Exception e) {
            message = "Error deleting customer: " + e.getMessage();
        }
    }
%>
<html>
<head>
    <title>Customer Management - Big Bad Monolith</title>
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
        .btn-danger { background: #dc3545; }
        .btn-danger:hover { background: #c82333; }
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
        <h1>Customer Management</h1>
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
        
        <h2>Add New Customer</h2>
        <form method="post" action="customers.jsp">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label for="name">Customer Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address">
            </div>
            <button type="submit" class="btn">Add Customer</button>
        </form>
        
        <h2>Existing Customers</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Address</th>
                    <th>Created</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        List<Customer> customers = customerDAO.findAll();
                        customers.sort((c1, c2) -> c2.getCreatedAt().compareTo(c1.getCreatedAt()));
                        
                        for (Customer customer : customers) {
                %>
                    <tr>
                        <td><%= customer.getId() %></td>
                        <td><%= customer.getName() %></td>
                        <td><%= customer.getEmail() %></td>
                        <td><%= customer.getAddress() != null ? customer.getAddress() : "" %></td>
                        <td><%= customer.getCreatedAt().toString() %></td>
                        <td>
                            <a href="customers.jsp?action=delete&id=<%= customer.getId() %>" 
                               onclick="return confirm('Are you sure you want to delete this customer?')"
                               class="btn btn-danger" style="text-decoration: none; font-size: 12px; padding: 5px 10px;">
                                Delete
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        System.out.println("<tr><td colspan='6'>Error loading customers: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
        

    </div>
</body>
</html>
