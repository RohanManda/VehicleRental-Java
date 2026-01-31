<%@ page import="java.util.List" %>
<%@ page import="com.MyApp.Rohan9063_CA2.Booking" %>
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
    <title>View Bookings - Admin</title>
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
            color: #4299e1; 
            text-decoration: none; 
            font-weight: 600; 
            padding: 12px 24px;
            border: 2px solid #4299e1;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        
        .back-link:hover { 
            background: #4299e1;
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
        
        .stat-card:nth-child(1) { border-left: 4px solid #4299e1; }
        .stat-card:nth-child(2) { border-left: 4px solid #48bb78; }
        .stat-card:nth-child(3) { border-left: 4px solid #38b2ac; }
        .stat-card:nth-child(4) { border-left: 4px solid #ed8936; }
        
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
            background-color: #ebf8ff; 
            transition: all 0.2s ease;
        }
        
        .status-booked { 
            color: #38a169; 
            font-weight: 600; 
            background: #c6f6d5;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        
        .status-cancelled { 
            color: #c53030; 
            font-weight: 600; 
            background: #fed7d7;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        
        .status-returned { 
            color: #3182ce; 
            font-weight: 600; 
            background: #bee3f8;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        
        .amount { 
            color: #38a169; 
            font-weight: 600; 
        }
        
        .booking-id {
            background: #ebf8ff;
            color: #3182ce;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.8em;
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
                <h2>📋 Bookings Management</h2>
                <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>
            </div>
        </div>
        
        <% 
        List<Booking> bookings = (List<Booking>) request.getAttribute("bookings"); 
        int totalBookings = 0;
        int bookedCount = 0;
        int returnedCount = 0;
        int cancelledCount = 0;
        double totalRevenue = 0;
        
        if (bookings != null) {
            totalBookings = bookings.size();
            for (Booking booking : bookings) {
                String status = booking.getStatus().toLowerCase();
                if ("booked".equals(status)) bookedCount++;
                else if ("returned".equals(status)) returnedCount++;
                else if ("cancelled".equals(status)) cancelledCount++;
                totalRevenue += booking.calculateTotalAmount();
            }
        }
        %>
        
        <!-- Statistics Section -->
        <div class="stats-section">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><%= totalBookings %></div>
                    <div class="stat-label">Total Bookings</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= bookedCount %></div>
                    <div class="stat-label">Active Bookings</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= returnedCount %></div>
                    <div class="stat-label">Completed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">₹<%= String.format("%.0f", totalRevenue) %></div>
                    <div class="stat-label">Total Revenue</div>
                </div>
            </div>
        </div>
        
        <div class="table-container">
            <% if (bookings != null && !bookings.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>📋 Booking ID</th>
                            <th>👤 User Name</th>
                            <th>📧 User Email</th>
                            <th>🚗 Vehicle Name</th>
                            <th>🏷️ Brand & Model</th>
                            <th>📅 Booking Date</th>
                            <th>🔄 Return Date</th>
                            <th>⏱️ Duration</th>
                            <th>💰 Total Amount</th>
                            <th>📊 Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Booking booking : bookings) { %>
                            <tr>
                                <td><span class="booking-id">BOOK-<%= booking.getBooking_id() %></span></td>
                                <td><%= booking.getUser() != null ? booking.getUser().getName() : "N/A" %></td>
                                <td><%= booking.getUser() != null ? booking.getUser().getEmail() : "N/A" %></td>
                                <td><%= booking.getVehicle() != null ? booking.getVehicle().getVehicle_name() : "N/A" %></td>
                                <td><%= booking.getVehicle() != null ? (booking.getVehicle().getBrand() + " " + booking.getVehicle().getModel()) : "N/A" %></td>
                                <td><%= booking.getBooking_date() %></td>
                                <td><%= booking.getReturn_date() %></td>
                                <td><%= booking.getRentalDurationDays() %> days</td>
                                <td class="amount">₹<%= String.format("%.2f", booking.calculateTotalAmount()) %></td>
                                <td><span class="status-<%= booking.getStatus().toLowerCase() %>"><%= booking.getStatus() %></span></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="no-data">
                    <h3>📭 No Bookings Found</h3>
                    <p>There are currently no bookings in the system.</p>
                    <p>Bookings will appear here once customers start renting vehicles.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
