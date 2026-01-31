<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, com.MyApp.Rohan9063_CA2.*" %>
<%
    // Check if user is logged in and is admin
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null || 
        !"Admin".equals(userSession.getAttribute("userRole"))) {
        response.sendRedirect("login.jsp?error=Access denied. Admin login required.");
        return;
    }
    
    User currentUser = (User) userSession.getAttribute("user");
    
    VehicleDAO vehicleDAO = new VehicleDAO();
    BookingDAO bookingDAO = new BookingDAO();
    UserDAO userDAO = new UserDAO();
    PaymentDAO paymentDAO = new PaymentDAO();
    ReturnDAO returnDAO = new ReturnDAO();
    MaintenanceDAO maintenanceDAO = new MaintenanceDAO();
    
    // Get data using safe methods (no lazy loading issues)
    List<Vehicle> allVehicles = vehicleDAO.listVehicles();
    List<Booking> allBookings = bookingDAO.listBookings();
    List<User> allUsers = userDAO.getAllUsers();
    List<Payment> allPayments = paymentDAO.listPayments();
    List<ReturnVehicle> allReturns = returnDAO.listReturns();
    List<Maintenance> allMaintenance = maintenanceDAO.listMaintenance();
    
    // Calculate statistics
    int totalVehicles = allVehicles != null ? allVehicles.size() : 0;
    int totalBookings = allBookings != null ? allBookings.size() : 0;
    int totalUsers = allUsers != null ? allUsers.size() : 0;
    int totalPayments = allPayments != null ? allPayments.size() : 0;
    int totalReturns = allReturns != null ? allReturns.size() : 0;
    int totalMaintenance = allMaintenance != null ? allMaintenance.size() : 0;
    
    int availableVehicles = 0;
    int activeBookings = 0;
    int adminCount = 0;
    int userCount = 0;
    double totalRevenue = 0.0;
    double totalMaintenanceCosts = 0.0;
    
    // Safe calculations without accessing lazy collections
    if (allVehicles != null) {
        for (Vehicle v : allVehicles) {
            if (v.isAvailability()) availableVehicles++;
        }
    }
    
    if (allBookings != null) {
        for (Booking b : allBookings) {
            if ("Booked".equals(b.getStatus())) activeBookings++;
        }
    }
    
    if (allUsers != null) {
        for (User u : allUsers) {
            if ("Admin".equals(u.getRole())) adminCount++;
            else userCount++;
        }
    }
    
    if (allPayments != null) {
        for (Payment p : allPayments) {
            totalRevenue += p.getAmount();
        }
    }
    
    if (allMaintenance != null) {
        for (Maintenance m : allMaintenance) {
            totalMaintenanceCosts += m.getCost();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Vehicle Rental System</title>
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
            max-width: 1600px;
            margin: 0 auto;
            padding: 30px 25px;
        }
        
        /* Header Section */
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
        
        /* Statistics Grid - 6 Cards in Single Row */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            padding: 30px 25px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid #e2e8f0;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4299e1, #3182ce);
        }
        
        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }
        
        .stat-icon {
            font-size: 2.4em;
            margin-bottom: 15px;
            display: block;
        }
        
        .stat-number {
            font-size: 2.5em;
            font-weight: 700;
            color: #2d3748;
            margin: 10px 0 8px 0;
            line-height: 1;
        }
        
        .stat-label {
            color: #4a5568;
            font-size: 1em;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .stat-subtitle {
            color: #718096;
            font-size: 0.85em;
            font-weight: 500;
        }
        
        /* Color variations for different cards */
        .stat-card:nth-child(1)::before { background: linear-gradient(90deg, #48bb78, #38a169); }
        .stat-card:nth-child(1) .stat-number { color: #38a169; }
        
        .stat-card:nth-child(2)::before { background: linear-gradient(90deg, #ed8936, #dd6b20); }
        .stat-card:nth-child(2) .stat-number { color: #dd6b20; }
        
        .stat-card:nth-child(3)::before { background: linear-gradient(90deg, #9f7aea, #805ad5); }
        .stat-card:nth-child(3) .stat-number { color: #805ad5; }
        
        .stat-card:nth-child(4)::before { background: linear-gradient(90deg, #4299e1, #3182ce); }
        .stat-card:nth-child(4) .stat-number { color: #3182ce; }
        
        .stat-card:nth-child(5)::before { background: linear-gradient(90deg, #38b2ac, #319795); }
        .stat-card:nth-child(5) .stat-number { color: #319795; }
        
        .stat-card:nth-child(6)::before { background: linear-gradient(90deg, #e53e3e, #c53030); }
        .stat-card:nth-child(6) .stat-number { color: #c53030; }
        
        /* Financial Overview */
        .financial-overview {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        
        .financial-overview h3 {
            color: #2d3748;
            font-size: 2em;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            padding-bottom: 15px;
        }
        
        .financial-overview h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: #4299e1;
            border-radius: 2px;
        }
        
        .financial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
        }
        
        .financial-item {
            text-align: center;
            padding: 30px 25px;
            background: #f7fafc;
            border-radius: 16px;
            border-left: 6px solid #48bb78;
            transition: all 0.3s ease;
        }
        
        .financial-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .financial-amount {
            font-size: 2.2em;
            font-weight: 700;
            color: #48bb78;
            margin-bottom: 10px;
            line-height: 1;
        }
        
        .financial-label {
            color: #4a5568;
            font-size: 1.1em;
            font-weight: 600;
        }
        
        /* Management Cards */
        .management-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        
        .management-card {
            background: white;
            border-radius: 20px;
            padding: 40px 35px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-align: center;
            border: 1px solid #e2e8f0;
            position: relative;
            overflow: hidden;
        }
        
        .management-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }
        
        .management-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4299e1, #3182ce);
        }
        
        .card-icon {
            font-size: 3.5em;
            margin-bottom: 25px;
            display: block;
        }
        
        .management-card h3 {
            color: #2d3748;
            margin-bottom: 20px;
            font-size: 1.6em;
            font-weight: 700;
        }
        
        .management-card p {
            color: #718096;
            margin-bottom: 35px;
            line-height: 1.6;
            font-size: 1.05em;
        }
        
        .management-card a {
            display: inline-block;
            background: #4299e1;
            color: white;
            text-decoration: none;
            padding: 14px 35px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1em;
            transition: all 0.3s ease;
        }
        
        .management-card a:hover {
            background: #3182ce;
            transform: scale(1.05);
        }
        
        /* Service Department Actions */
        .service-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 30px;
        }
        
        .service-actions a {
            padding: 14px 25px;
            text-align: center;
            border-radius: 10px;
            font-size: 0.95em;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            color: white;
        }
        
        .add-maintenance-btn {
            background: #48bb78;
        }
        
        .view-maintenance-btn {
            background: #38b2ac;
        }
        
        .add-maintenance-btn:hover {
            background: #38a169;
            transform: scale(1.05);
        }
        
        .view-maintenance-btn:hover {
            background: #319795;
            transform: scale(1.05);
        }
        
        /* Logout Section */
        .logout-section {
            text-align: center;
            margin-top: 60px;
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
        }
        
        .error-message {
            background: #fed7d7;
            color: #c53030;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border-left: 4px solid #e53e3e;
            text-align: center;
            font-weight: 600;
        }
        
        /* Responsive Design */
        @media (max-width: 1400px) {
            .stats-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
        
        @media (max-width: 900px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }
            .header-content {
                flex-direction: column;
                text-align: center;
            }
            .header-right {
                margin-top: 20px;
                text-align: center;
            }
        }
        
        @media (max-width: 600px) {
            .container {
                padding: 20px 15px;
            }
            .header {
                padding: 30px 20px;
            }
            .header-left h1 { 
                font-size: 2.2em; 
            }
            .management-grid { 
                grid-template-columns: 1fr; 
            }
            .stats-grid { 
                grid-template-columns: 1fr; 
                gap: 15px;
            }
            .service-actions { 
                grid-template-columns: 1fr; 
            }
            .financial-grid { 
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
                    <h1>🚗 Admin Dashboard</h1>
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
        </div>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                <strong>⚠️ System Alert:</strong> <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <!-- Statistics Grid - 6 Cards in Single Row -->
        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-icon">🚗</span>
                <div class="stat-number"><%= totalVehicles %></div>
                <div class="stat-label">Total Fleet</div>
                <div class="stat-subtitle"><%= availableVehicles %> available</div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">📋</span>
                <div class="stat-number"><%= totalBookings %></div>
                <div class="stat-label">Total Bookings</div>
                <div class="stat-subtitle"><%= activeBookings %> active</div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">👥</span>
                <div class="stat-number"><%= totalUsers %></div>
                <div class="stat-label">System Users</div>
                <div class="stat-subtitle"><%= userCount %> customers</div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">💳</span>
                <div class="stat-number"><%= totalPayments %></div>
                <div class="stat-label">Transactions</div>
                <div class="stat-subtitle">₹<%= String.format("%.0f", totalRevenue) %> revenue</div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">🔄</span>
                <div class="stat-number"><%= totalReturns %></div>
                <div class="stat-label">Vehicle Returns</div>
                <div class="stat-subtitle">Completed trips</div>
            </div>
            
            <div class="stat-card">
                <span class="stat-icon">🔧</span>
                <div class="stat-number"><%= totalMaintenance %></div>
                <div class="stat-label">Service Records</div>
                <div class="stat-subtitle">₹<%= String.format("%.0f", totalMaintenanceCosts) %> costs</div>
            </div>
        </div>
        
        <!-- Financial Overview -->
        <div class="financial-overview">
            <h3>💰 Financial Overview</h3>
            <div class="financial-grid">
                <div class="financial-item">
                    <div class="financial-amount">₹<%= String.format("%.0f", totalRevenue) %></div>
                    <div class="financial-label">Total Revenue</div>
                </div>
                <div class="financial-item" style="border-left-color: #e53e3e;">
                    <div class="financial-amount" style="color: #e53e3e;">₹<%= String.format("%.0f", totalMaintenanceCosts) %></div>
                    <div class="financial-label">Maintenance Costs</div>
                </div>
                <div class="financial-item" style="border-left-color: #38b2ac;">
                    <div class="financial-amount" style="color: #38b2ac;">₹<%= String.format("%.0f", totalRevenue - totalMaintenanceCosts) %></div>
                    <div class="financial-label">Net Income</div>
                </div>
                <div class="financial-item" style="border-left-color: #ed8936;">
                    <div class="financial-amount" style="color: #ed8936;">₹<%= totalBookings > 0 ? String.format("%.0f", totalRevenue / totalBookings) : "0" %></div>
                    <div class="financial-label">Avg Revenue/Booking</div>
                </div>
            </div>
        </div>
        
        <!-- Management Modules -->
        <div class="management-grid">
            <div class="management-card">
                <span class="card-icon">🚗</span>
                <h3>Fleet Management</h3>
                <p>Add new vehicles, update existing inventory, manage availability and pricing</p>
                <a href="addVehicle.jsp">Manage Fleet</a>
            </div>
            
            <div class="management-card">
                <span class="card-icon">📋</span>
                <h3>Reservation Center</h3>
                <p>Monitor customer bookings, track rental periods, and manage reservations</p>
                <a href="viewBookings">View Reservations</a>
            </div>
            
            <div class="management-card">
                <span class="card-icon">💳</span>
                <h3>Financial Control</h3>
                <p>Track payment transactions, monitor revenue streams, and generate financial reports</p>
                <a href="viewPayments">Payment Center</a>
            </div>
            
            <div class="management-card">
                <span class="card-icon">🔄</span>
                <h3>Return Processing</h3>
                <p>Handle vehicle returns, process late fees, and manage return procedures</p>
                <a href="viewReturns">Return Management</a>
            </div>
            
            <div class="management-card">
                <span class="card-icon">👥</span>
                <h3>User Administration</h3>
                <p>Manage user accounts, monitor customer activity, and handle user registrations</p>
                <a href="viewUsers">User Control</a>
            </div>
            
            <div class="management-card">
                <span class="card-icon">🔧</span>
                <h3>Service Department</h3>
                <p>Complete maintenance management for your vehicle fleet</p>
                <div class="service-actions">
                    <a href="addMaintenance.jsp" class="add-maintenance-btn">
                        ➕ Add Record
                    </a>
                    <a href="viewMaintenance" class="view-maintenance-btn">
                        📋 View Records
                    </a>
                </div>
            </div>
        </div>
        
        <div class="logout-section">
            <a href="logout" class="logout-btn">🚪 Logout</a>
        </div>
    </div>
</body>
</html>
