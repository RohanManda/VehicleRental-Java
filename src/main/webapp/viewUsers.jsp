<%@ page import="java.util.List" %>
<%@ page import="com.MyApp.Rohan9063_CA2.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    // Check if user is admin
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null || 
        !"Admin".equals(userSession.getAttribute("userRole"))) {
        response.sendRedirect("login.jsp?error=Access denied. Admin login required.");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Users - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            background: #f8fafc;
            min-height: 100vh;
            color: #1a202c;
            line-height: 1.6;
        }
        
        .container { 
            max-width: 1400px; 
            margin: 30px auto; 
            padding: 0 25px;
        }
        
        .header {
            background: white;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        
        .header-content {
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .header h2 {
            color: #2d3748;
            font-size: 2.2em;
            font-weight: 700;
            margin: 0;
        }
        
        .back-link { 
            color: #9f7aea; 
            text-decoration: none; 
            font-weight: 600; 
            padding: 12px 24px;
            border: 2px solid #9f7aea;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        
        .back-link:hover { 
            background: #9f7aea;
            color: white;
            transform: translateY(-2px);
        }
        
        .stats-section {
            background: white;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .stat-card {
            background: #f7fafc;
            padding: 25px 20px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .stat-card:nth-child(1) { border-left: 4px solid #9f7aea; }
        .stat-card:nth-child(2) { border-left: 4px solid #48bb78; }
        .stat-card:nth-child(3) { border-left: 4px solid #e53e3e; }
        .stat-card:nth-child(4) { border-left: 4px solid #4299e1; }
        
        .stat-number {
            font-size: 2.2em;
            font-weight: 700;
            margin-bottom: 8px;
            color: #2d3748;
        }
        
        .stat-label {
            font-size: 0.9em;
            color: #718096;
            font-weight: 500;
        }
        
        .table-container {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            overflow-x: auto;
        }
        
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 10px;
        }
        
        th, td { 
            border: 1px solid #e2e8f0; 
            padding: 15px 12px; 
            text-align: left; 
            font-size: 0.9em;
        }
        
        th { 
            background: #f7fafc; 
            font-weight: 600; 
            color: #2d3748; 
            border-bottom: 2px solid #e2e8f0;
        }
        
        tr:nth-child(even) { 
            background-color: #f9fafb; 
        }
        
        tr:hover { 
            background-color: #f9f5ff; 
            transition: all 0.2s ease;
        }
        
        .role-admin { 
            color: #c53030; 
            font-weight: 600; 
            background: #fed7d7;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        
        .role-user { 
            color: #38a169; 
            font-weight: 600; 
            background: #c6f6d5;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        
        .user-id {
            background: #f9f5ff;
            color: #805ad5;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.8em;
        }
        
        .email { 
            color: #4299e1;
            font-weight: 500;
        }
        
        .booking-count { 
            background: #ebf8ff; 
            color: #3182ce;
            padding: 4px 10px; 
            border-radius: 8px; 
            font-size: 0.8em; 
            font-weight: 500;
        }
        
        .no-data { 
            text-align: center; 
            padding: 60px 20px; 
            color: #718096; 
            background: #f7fafc;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        
        .no-data h3 {
            color: #2d3748;
            margin-bottom: 15px;
            font-size: 1.3em;
            font-weight: 600;
        }
        
        .contact-info {
            max-width: 150px;
            word-wrap: break-word;
        }
        
        .user-stats {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .user-stats .booking-count {
            align-self: flex-start;
        }
        
        @media (max-width: 900px) {
            .header-content {
                flex-direction: column;
                text-align: center;
            }
            
            .back-link {
                margin-top: 20px;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 600px) {
            .container {
                padding: 0 15px;
                margin: 20px auto;
            }
            
            .header, .stats-section, .table-container {
                padding: 20px;
            }
            
            .header h2 {
                font-size: 1.8em;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-content">
                <h2>👥 User Management</h2>
                <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>
            </div>
        </div>
        
        <% 
        List<User> users = (List<User>) request.getAttribute("users"); 
        int totalUsers = 0;
        int adminCount = 0;
        int userCount = 0;
        int totalBookings = 0;
        
        if (users != null) {
            totalUsers = users.size();
            for (User user : users) {
                if ("Admin".equals(user.getRole())) adminCount++;
                else userCount++;
                if (user.getBookings() != null) {
                    totalBookings += user.getBookings().size();
                }
            }
        }
        %>
        
        <!-- Statistics Section -->
        <div class="stats-section">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><%= totalUsers %></div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= userCount %></div>
                    <div class="stat-label">Customers</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= adminCount %></div>
                    <div class="stat-label">Administrators</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= totalBookings %></div>
                    <div class="stat-label">Total Bookings</div>
                </div>
            </div>
        </div>
        
        <div class="table-container">
            <% if (users != null && !users.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>👤 User ID</th>
                            <th>👤 Name</th>
                            <th>📧 Email</th>
                            <th>🎭 Role</th>
                            <th>📞 Phone</th>
                            <th>📍 Address</th>
                            <th>📋 Activity</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User user : users) { %>
                            <tr>
                                <td><span class="user-id">USER-<%= user.getUser_id() %></span></td>
                                <td><strong><%= user.getName() %></strong></td>
                                <td class="email"><%= user.getEmail() %></td>
                                <td><span class="role-<%= user.getRole().toLowerCase() %>"><%= user.getRole() %></span></td>
                                <td class="contact-info"><%= user.getPhone() != null ? user.getPhone() : "Not provided" %></td>
                                <td class="contact-info"><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></td>
                                <td>
                                    <div class="user-stats">
                                        <span class="booking-count"><%= user.getBookings() != null ? user.getBookings().size() : 0 %> bookings</span>
                                        <small style="color: #718096;">
                                            <%= "Admin".equals(user.getRole()) ? "System Admin" : "Customer Account" %>
                                        </small>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="no-data">
                    <h3>👥 No Users Found</h3>
                    <p>There are currently no users in the system.</p>
                    <p>Users will appear here once people start registering.</p>
                    <p><a href="register.jsp" style="color: #9f7aea;">Register the first user</a></p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
