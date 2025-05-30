<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.joda.time.LocalDate" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.dao.*" %>
<%@ page import="com.sourcegraph.demo.bigbadmonolith.entity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // LEGACY ANTI-PATTERN: Complex reporting logic and DAO instantiation in JSP
    CustomerDAO customerDAO = new CustomerDAO();
    UserDAO userDAO = new UserDAO();
    BillableHourDAO billableHourDAO = new BillableHourDAO();
    BillingCategoryDAO categoryDAO = new BillingCategoryDAO();
    
    String reportType = request.getParameter("reportType");
    String customerId = request.getParameter("customerId");
    String month = request.getParameter("month");
    String year = request.getParameter("year");
    
    // Database connection URL for legacy JDBC code
    String dbUrl = "jdbc:derby:./data/bigbadmonolith;create=true";
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<html>
<head>
    <title>Reports - Big Bad Monolith</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .header { background-color: #333; color: white; padding: 20px; text-align: center; }
        .nav { background-color: #666; padding: 10px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; }
        .nav a:hover { text-decoration: underline; }
        .content { background: white; padding: 20px; margin: 20px 0; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin-bottom: 15px; display: inline-block; margin-right: 20px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group select, .form-group input { padding: 8px; border: 1px solid #ccc; border-radius: 3px; }
        .btn { background: #007acc; color: white; padding: 10px 15px; border: none; border-radius: 3px; cursor: pointer; }
        .btn:hover { background: #005a9e; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        .report-section { margin: 30px 0; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .summary-box { background: #e7f3ff; padding: 15px; margin: 15px 0; border-radius: 5px; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Billing Reports</h1>
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
        <h2>Generate Reports</h2>
        <form method="get" action="reports.jsp">
            <div class="form-group">
                <label for="reportType">Report Type:</label>
                <select id="reportType" name="reportType">
                    <option value="">Select Report Type</option>
                    <option value="customer" <%= "customer".equals(reportType) ? "selected" : "" %>>Customer Bill</option>
                    <option value="monthly" <%= "monthly".equals(reportType) ? "selected" : "" %>>Monthly Summary</option>
                    <option value="revenue" <%= "revenue".equals(reportType) ? "selected" : "" %>>Revenue Summary</option>
                </select>
            </div>
            
            <% if ("customer".equals(reportType)) { %>
            <div class="form-group">
                <label for="customerId">Customer:</label>
                <select id="customerId" name="customerId">
                    <option value="">Select Customer</option>
                    <%
                        // LEGACY ANTI-PATTERN: Data access for form population in JSP
                        try {
                            List<Customer> customers = customerDAO.findAll();
                            for (Customer customer : customers) {
                                String selected = customer.getId().toString().equals(customerId) ? "selected" : "";
                                out.println("<option value='" + customer.getId() + "' " + selected + ">" + 
                                          customer.getName() + "</option>");
                            }
                        } catch (Exception e) {
                            out.println("<option value=''>Error loading customers</option>");
                        }
                    %>
                </select>
            </div>
            <% } %>
            
            <% if ("monthly".equals(reportType)) { %>
            <div class="form-group">
                <label for="year">Year:</label>
                <input type="number" id="year" name="year" value="<%= year != null ? year : "2024" %>" min="2020" max="2030">
            </div>
            <div class="form-group">
                <label for="month">Month:</label>
                <select id="month" name="month">
                    <% 
                        String[] months = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"};
                        String[] monthNames = {"January", "February", "March", "April", "May", "June", 
                                             "July", "August", "September", "October", "November", "December"};
                        for (int i = 0; i < months.length; i++) {
                            String selected = months[i].equals(month) ? "selected" : "";
                            out.println("<option value='" + months[i] + "' " + selected + ">" + monthNames[i] + "</option>");
                        }
                    %>
                </select>
            </div>
            <% } %>
            
            <button type="submit" class="btn">Generate Report</button>
        </form>
        
        <%
            // LEGACY ANTI-PATTERN: Massive conditional logic in JSP for different reports
            if ("customer".equals(reportType) && customerId != null && !customerId.trim().isEmpty()) {
        %>
        <div class="report-section">
            <h2>Customer Bill Report</h2>
            <%
                // LEGACY ANTI-PATTERN: Complex business logic for billing calculations
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                String customerName = "";
                String customerEmail = "";
                double totalAmount = 0.0;
                double totalHours = 0.0;
                
                try {
                    Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                    conn = DriverManager.getConnection(dbUrl);
                    
                    // Get customer info
                    pstmt = conn.prepareStatement("SELECT name, email FROM customers WHERE id = ?");
                    pstmt.setInt(1, Integer.parseInt(customerId));
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
                        customerName = rs.getString("name");
                        customerEmail = rs.getString("email");
                    }
                    rs.close();
                    pstmt.close();
                    
                    // Get billing details
                    pstmt = conn.prepareStatement(
                        "SELECT bh.date_logged, u.name as user_name, bc.name as category_name, " +
                        "bh.hours, bc.hourly_rate, bh.hours * bc.hourly_rate as line_total, bh.note " +
                        "FROM billable_hours bh " +
                        "JOIN users u ON bh.user_id = u.id " +
                        "JOIN billing_categories bc ON bh.category_id = bc.id " +
                        "WHERE bh.customer_id = ? " +
                        "ORDER BY bh.date_logged DESC"
                    );
                    pstmt.setInt(1, Integer.parseInt(customerId));
                    rs = pstmt.executeQuery();
            %>
            
            <div class="summary-box">
                <h3>Bill To:</h3>
                <p><strong><%= customerName %></strong><br>
                Email: <%= customerEmail %></p>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>User</th>
                        <th>Category</th>
                        <th>Hours</th>
                        <th>Rate</th>
                        <th>Amount</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            double lineTotal = rs.getDouble("line_total");
                            double hours = rs.getDouble("hours");
                            totalAmount += lineTotal;
                            totalHours += hours;
                    %>
                        <tr>
                            <td><%= rs.getDate("date_logged") %></td>
                            <td><%= rs.getString("user_name") %></td>
                            <td><%= rs.getString("category_name") %></td>
                            <td class="text-right"><%= df.format(hours) %></td>
                            <td class="text-right">$<%= df.format(rs.getDouble("hourly_rate")) %></td>
                            <td class="text-right">$<%= df.format(lineTotal) %></td>
                            <td><%= rs.getString("note") != null ? rs.getString("note") : "" %></td>
                        </tr>
                    <%
                        }
                    %>
                    <tr style="background-color: #f8f9fa; font-weight: bold;">
                        <td colspan="3">TOTAL</td>
                        <td class="text-right"><%= df.format(totalHours) %></td>
                        <td></td>
                        <td class="text-right">$<%= df.format(totalAmount) %></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
            
            <%
                } catch (Exception e) {
                    out.println("<p>Error generating customer report: " + e.getMessage() + "</p>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
        <%
            } else if ("monthly".equals(reportType) && year != null && month != null) {
        %>
        <div class="report-section">
            <h2>Monthly Summary - <%= month %>/<%= year %></h2>
            <%
                // LEGACY ANTI-PATTERN: Date manipulation and complex aggregations in JSP
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                    conn = DriverManager.getConnection(dbUrl);
                    
                    // LEGACY ANTI-PATTERN: Manual date string construction
                    String startDate = year + "-" + month + "-01";
                    String endDate = year + "-" + month + "-31"; // Simplified - doesn't handle month lengths properly
                    
                    pstmt = conn.prepareStatement(
                        "SELECT c.name as customer_name, " +
                        "SUM(bh.hours) as total_hours, " +
                        "SUM(bh.hours * bc.hourly_rate) as total_amount " +
                        "FROM billable_hours bh " +
                        "JOIN customers c ON bh.customer_id = c.id " +
                        "JOIN billing_categories bc ON bh.category_id = bc.id " +
                        "WHERE bh.date_logged >= ? AND bh.date_logged <= ? " +
                        "GROUP BY c.name " +
                        "ORDER BY total_amount DESC"
                    );
                    pstmt.setDate(1, java.sql.Date.valueOf(startDate));
                    pstmt.setDate(2, java.sql.Date.valueOf(endDate));
                    rs = pstmt.executeQuery();
            %>
            
            <table>
                <thead>
                    <tr>
                        <th>Customer</th>
                        <th>Total Hours</th>
                        <th>Total Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        double monthlyTotal = 0.0;
                        double monthlyHours = 0.0;
                        
                        while (rs.next()) {
                            double customerTotal = rs.getDouble("total_amount");
                            double customerHours = rs.getDouble("total_hours");
                            monthlyTotal += customerTotal;
                            monthlyHours += customerHours;
                    %>
                        <tr>
                            <td><%= rs.getString("customer_name") %></td>
                            <td class="text-right"><%= df.format(customerHours) %></td>
                            <td class="text-right">$<%= df.format(customerTotal) %></td>
                        </tr>
                    <%
                        }
                    %>
                    <tr style="background-color: #f8f9fa; font-weight: bold;">
                        <td>MONTHLY TOTAL</td>
                        <td class="text-right"><%= df.format(monthlyHours) %></td>
                        <td class="text-right">$<%= df.format(monthlyTotal) %></td>
                    </tr>
                </tbody>
            </table>
            
            <%
                } catch (Exception e) {
                    out.println("<p>Error generating monthly report: " + e.getMessage() + "</p>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
        <%
            } else if ("revenue".equals(reportType)) {
        %>
        <div class="report-section">
            <h2>Revenue Summary</h2>
            <%
                // LEGACY ANTI-PATTERN: Multiple database queries for different metrics
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                
                try {
                    Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                    conn = DriverManager.getConnection(dbUrl);
                    stmt = conn.createStatement();
            %>
            
            <h3>By Customer</h3>
            <table>
                <thead>
                    <tr>
                        <th>Customer</th>
                        <th>Total Hours</th>
                        <th>Total Revenue</th>
                        <th>Average Rate</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        rs = stmt.executeQuery(
                            "SELECT c.name, " +
                            "SUM(bh.hours) as total_hours, " +
                            "SUM(bh.hours * bc.hourly_rate) as total_revenue, " +
                            "AVG(bc.hourly_rate) as avg_rate " +
                            "FROM customers c " +
                            "LEFT JOIN billable_hours bh ON c.id = bh.customer_id " +
                            "LEFT JOIN billing_categories bc ON bh.category_id = bc.id " +
                            "GROUP BY c.name " +
                            "ORDER BY total_revenue DESC"
                        );
                        
                        while (rs.next()) {
                            double totalHours = rs.getDouble("total_hours");
                            double totalRevenue = rs.getDouble("total_revenue");
                            double avgRate = rs.getDouble("avg_rate");
                    %>
                        <tr>
                            <td><%= rs.getString("name") %></td>
                            <td class="text-right"><%= df.format(totalHours) %></td>
                            <td class="text-right">$<%= df.format(totalRevenue) %></td>
                            <td class="text-right">$<%= df.format(avgRate) %></td>
                        </tr>
                    <%
                        }
                        rs.close();
                    %>
                </tbody>
            </table>
            
            <h3>By Category</h3>
            <table>
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Hourly Rate</th>
                        <th>Total Hours</th>
                        <th>Total Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        rs = stmt.executeQuery(
                            "SELECT bc.name, bc.hourly_rate, " +
                            "COALESCE(SUM(bh.hours), 0) as total_hours, " +
                            "COALESCE(SUM(bh.hours * bc.hourly_rate), 0) as total_revenue " +
                            "FROM billing_categories bc " +
                            "LEFT JOIN billable_hours bh ON bc.id = bh.category_id " +
                            "GROUP BY bc.name, bc.hourly_rate " +
                            "ORDER BY total_revenue DESC"
                        );
                        
                        while (rs.next()) {
                    %>
                        <tr>
                            <td><%= rs.getString("name") %></td>
                            <td class="text-right">$<%= df.format(rs.getDouble("hourly_rate")) %></td>
                            <td class="text-right"><%= df.format(rs.getDouble("total_hours")) %></td>
                            <td class="text-right">$<%= df.format(rs.getDouble("total_revenue")) %></td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            
            <%
                } catch (Exception e) {
                    out.println("<p>Error generating revenue summary: " + e.getMessage() + "</p>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
        <%
            }
        %>
        
        <div style="margin-top: 30px; padding: 20px; background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px;">
            <h3>🚨 Training Exercise: Identify Legacy Anti-Patterns</h3>
            <p><strong>Challenge:</strong> This reports module contains multiple architectural issues. Can you spot them?</p>
            
            <h4>🔍 Investigation Hints:</h4>
            <ul>
                <li><strong>Code Organization:</strong> Look for where business logic, data access, and presentation are located</li>
                <li><strong>Resource Management:</strong> Examine how database connections are created and closed</li>
                <li><strong>Security Concerns:</strong> Check how user input is handled and used in database queries</li>
                <li><strong>Error Handling:</strong> See what happens when things go wrong</li>
                <li><strong>Performance:</strong> Count how many database queries execute for one page load</li>
                <li><strong>Maintainability:</strong> Consider what happens when requirements change</li>
            </ul>
            
            <h4>🔬 Sourcegraph Search Example:</h4>
            <p>Try this search to find potential SQL injection vulnerabilities across the codebase:</p>
            <code style="background: #f4f4f4; padding: 5px; display: block; margin: 10px 0;">
                repo:^your-repo$ SELECT.*\+.*request\.getParameter lang:java
            </code>
            <p><em>This searches for SQL queries that concatenate user input from request parameters.</em></p>
            
            <p><strong>Discussion Questions:</strong></p>
            <ul>
                <li>What architectural pattern would better separate these concerns?</li>
                <li>How could you make this code more testable?</li>
                <li>What security vulnerabilities do you see?</li>
            </ul>
        </div>
    </div>
</body>
</html>
