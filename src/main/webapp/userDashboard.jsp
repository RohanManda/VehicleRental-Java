<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, com.MyApp.Rohan9063_CA2.*" %>
<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=Please login to access dashboard");
        return;
    }
    User currentUser = (User) userSession.getAttribute("user");
    VehicleDAO vehicleDAO = new VehicleDAO();
    BookingDAO bookingDAO = new BookingDAO();
    List<Vehicle> availableVehicles = vehicleDAO.getAvailableVehicles();
    List<Booking> userBookings = bookingDAO.getBookingsByUser(currentUser.getUser_id());
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard - Vehicle Rental System</title>
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
            margin: 0 auto;
            padding: 30px 25px;
        }
        
        .header {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-left h1 {
            font-size: 2.8em;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 10px;
        }
        
        .welcome-msg {
            font-size: 1.2em;
            color: #4a5568;
            font-weight: 500;
        }
        
        .header-right {
            text-align: right;
        }
        
        .current-time {
            background: #f7fafc;
            color: #4a5568;
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 0.95em;
            font-weight: 500;
            border: 1px solid #e2e8f0;
        }
        
        .section {
            background: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 40px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        
        .section h3 {
            color: #2d3748;
            margin-bottom: 30px;
            font-size: 1.8em;
            font-weight: 700;
            position: relative;
            padding-bottom: 15px;
        }
        
        .section h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: #4299e1;
            border-radius: 2px;
        }
        
        .user-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-item {
            background: #f7fafc;
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        
        .info-label {
            font-weight: 600;
            color: #4a5568;
            font-size: 0.9em;
            margin-bottom: 5px;
        }
        
        .info-value {
            color: #2d3748;
            font-weight: 500;
        }
        
        .actions-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .action-btn {
            background: #4299e1;
            color: white;
            text-decoration: none;
            padding: 16px 24px;
            border-radius: 12px;
            font-weight: 600;
            text-align: center;
            transition: all 0.3s ease;
            font-size: 1em;
        }
        
        .action-btn:hover {
            background: #3182ce;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(66, 153, 225, 0.3);
        }
        
        /* Vehicle Grid */
        .vehicle-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }
        
        .vehicle-card {
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 25px;
            background: #f7fafc;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .vehicle-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.15);
            border-color: #4299e1;
        }
        
        .vehicle-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 12px;
            margin-bottom: 20px;
        }
        
        .no-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #718096;
            margin-bottom: 20px;
            font-size: 1.1em;
            font-weight: 500;
        }
        
        .vehicle-info h4 {
            color: #2d3748;
            margin: 0 0 15px 0;
            font-size: 1.4em;
            font-weight: 600;
        }
        
        .vehicle-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 20px;
            font-size: 0.9em;
        }
        
        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
        }
        
        .detail-label {
            font-weight: 600;
            color: #4a5568;
        }
        
        .detail-value {
            color: #2d3748;
            font-weight: 500;
        }
        
        .price-tag {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            padding: 12px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1.1em;
            text-align: center;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
        }
        
        .book-btn {
            background: #4299e1;
            color: white;
            text-decoration: none;
            padding: 14px 28px;
            border-radius: 10px;
            font-weight: 600;
            display: inline-block;
            width: 100%;
            text-align: center;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }
        
        .book-btn:hover {
            background: #3182ce;
            transform: scale(1.02);
            box-shadow: 0 6px 20px rgba(66, 153, 225, 0.3);
        }
        
        /* Booking Table */
        .booking-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .booking-table th,
        .booking-table td {
            border: 1px solid #e2e8f0;
            padding: 15px 12px;
            text-align: left;
        }
        
        .booking-table th {
            background: #f7fafc;
            font-weight: 600;
            color: #2d3748;
            font-size: 0.9em;
        }
        
        .booking-table tr:nth-child(even) {
            background: #f9fafb;
        }
        
        .booking-table tr:hover {
            background: #ebf8ff;
        }
        
        .status-booked {
            color: #48bb78;
            font-weight: 600;
            background: #c6f6d5;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85em;
        }
        
        .status-cancelled {
            color: #e53e3e;
            font-weight: 600;
            background: #fed7d7;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85em;
        }
        
        .status-returned {
            color: #4299e1;
            font-weight: 600;
            background: #bee3f8;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85em;
        }
        
        .amount {
            color: #48bb78;
            font-weight: 600;
        }
        
        .no-data {
            text-align: center;
            color: #718096;
            padding: 60px 20px;
            font-size: 1.1em;
        }
        
        .no-data h4 {
            color: #2d3748;
            margin-bottom: 15px;
            font-size: 1.3em;
        }
        
        .logout-section {
            text-align: center;
            margin-top: 50px;
        }
        
        .logout-btn {
            background: #e53e3e;
            color: white;
            text-decoration: none;
            padding: 16px 40px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1.1em;
            transition: all 0.3s ease;
            display: inline-block;
        }
        
        .logout-btn:hover {
            background: #c53030;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(229, 62, 62, 0.3);
        }
        
        .alert {
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-weight: 500;
        }
        
        .error { 
            color: #c53030;
            background: #fed7d7;
            border-left: 4px solid #e53e3e;
        }
        
        .success { 
            color: #38a169;
            background: #c6f6d5;
            border-left: 4px solid #48bb78;
        }
        
        @media (max-width: 900px) {
            .header-content {
                flex-direction: column;
                text-align: center;
            }
            
            .header-right {
                margin-top: 20px;
                text-align: center;
            }
            
            .vehicle-grid {
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            }
        }
        
        @media (max-width: 600px) {
            .container {
                padding: 20px 15px;
            }
            
            .header, .section {
                padding: 25px 20px;
            }
            
            .header-left h1 {
                font-size: 2.2em;
            }
            
            .vehicle-grid {
                grid-template-columns: 1fr;
            }
            
            .actions-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header Section -->
        <div class="header">
            <div class="header-content">
                <div class="header-left">
                    <h1>🚗 Vehicle Rental Dashboard</h1>
                    <div class="welcome-msg">
                        Welcome back, <strong><%= currentUser.getName() %></strong>!
                    </div>
                </div>
                <div class="header-right">
                    <div class="current-time">
                        📅 <%= new java.util.Date() %>
                    </div>
                </div>
            </div>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert error">
                    <strong>⚠️ Error:</strong> <%= request.getParameter("error") %>
                </div>
            <% } %>
            
            <% if (request.getParameter("success") != null) { %>
                <div class="alert success">
                    <strong>✅ Success:</strong> <%= request.getParameter("success") %>
                </div>
            <% } %>
            
            <div class="user-info">
                <div class="info-item">
                    <div class="info-label">📧 Email</div>
                    <div class="info-value"><%= currentUser.getEmail() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">👤 Role</div>
                    <div class="info-value"><%= currentUser.getRole() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">📞 Phone</div>
                    <div class="info-value"><%= currentUser.getPhone() != null ? currentUser.getPhone() : "Not provided" %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">📍 Address</div>
                    <div class="info-value"><%= currentUser.getAddress() != null ? currentUser.getAddress() : "Not provided" %></div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="actions-section">
                <a href="booking.jsp" class="action-btn">📅 Book Vehicle</a>
                <a href="payment.jsp" class="action-btn">💳 Make Payment</a>
                <a href="return.jsp" class="action-btn">🔄 Return Vehicle</a>
            </div>
        </div>

        <!-- Available Vehicles Section -->
        <div class="section">
            <h3>🚗 Available Vehicles for Rent</h3>
            <% if (availableVehicles != null && !availableVehicles.isEmpty()) { %>
                <div class="vehicle-grid">
                    <% for (Vehicle vehicle : availableVehicles) { %>
                        <div class="vehicle-card">
                            <% if (vehicle.getVehicle_image() != null && !vehicle.getVehicle_image().isEmpty()) { %>
                                <img src="<%= vehicle.getVehicle_image() %>" alt="<%= vehicle.getVehicle_name() %>" class="vehicle-image"/>
                            <% } else { %>
                                <div class="no-image">
                                    <span>📷 No Image Available</span>
                                </div>
                            <% } %>
                            
                            <div class="vehicle-info">
                                <h4><%= vehicle.getVehicle_name() %></h4>
                                
                                <div class="vehicle-details">
                                    <div class="detail-item">
                                        <span class="detail-label">Type:</span>
                                        <span class="detail-value"><%= vehicle.getVehicle_type() %></span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Brand:</span>
                                        <span class="detail-value"><%= vehicle.getBrand() %></span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Model:</span>
                                        <span class="detail-value"><%= vehicle.getModel() %></span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Year:</span>
                                        <span class="detail-value"><%= vehicle.getYear() %></span>
                                    </div>
                                </div>
                                
                                <div class="price-tag">
                                    ₹<%= String.format("%.2f", vehicle.getPrice_per_day()) %> per day
                                </div>
                                
                                <a href="booking.jsp?vehicleId=<%= vehicle.getVehicle_id() %>&userId=<%= currentUser.getUser_id() %>" class="book-btn">
                                    📅 Book Now
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="no-data">
                    <h4>🚫 No vehicles available at the moment</h4>
                    <p>Please check back later for available vehicles.</p>
                </div>
            <% } %>
        </div>

        <!-- My Bookings Section -->
        <div class="section">
            <h3>📋 My Booking History</h3>
            <% if (userBookings != null && !userBookings.isEmpty()) { %>
                <div style="overflow-x: auto;">
                    <table class="booking-table">
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Vehicle</th>
                                <th>Brand & Model</th>
                                <th>Booking Date</th>
                                <th>Return Date</th>
                                <th>Duration</th>
                                <th>Total Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Booking booking : userBookings) { %>
                                <tr>
                                    <td><strong>BOOK-<%= booking.getBooking_id() %></strong></td>
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
                </div>
            <% } else { %>
                <div class="no-data">
                    <h4>📝 No bookings yet</h4>
                    <p>You haven't made any bookings yet. Browse available vehicles above to get started!</p>
                </div>
            <% } %>
        </div>

        <div class="logout-section">
            <a href="logout" class="logout-btn">🚪 Logout</a>
        </div>
    </div>
</body>
</html>
