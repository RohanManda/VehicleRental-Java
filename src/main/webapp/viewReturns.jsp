<%@ page import="java.util.List" %>
<%@ page import="com.MyApp.Rohan9063_CA2.ReturnVehicle" %>
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
    <title>View Returns - Admin</title>
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
            color: #38b2ac; 
            text-decoration: none; 
            font-weight: 600; 
            padding: 12px 24px;
            border: 2px solid #38b2ac;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        
        .back-link:hover { 
            background: #38b2ac;
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
        
        .stat-card:nth-child(1) { border-left: 4px solid #38b2ac; }
        .stat-card:nth-child(2) { border-left: 4px solid #e53e3e; }
        .stat-card:nth-child(3) { border-left: 4px solid #ed8936; }
        .stat-card:nth-child(4) { border-left: 4px solid #48bb78; }
        
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
            background-color: #f0fdfa; 
            transition: all 0.2s ease;
        }
        
        .extra-charge { 
            color: #c53030; 
            font-weight: 600; 
            background: #fed7d7;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        
        .no-charge { 
            color: #38a169;
            font-weight: 600;
            background: #c6f6d5;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        
        .return-id {
            background: #f0fdfa;
            color: #234e52;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.8em;
        }
        
        .late-return {
            background: #fef5e7;
            color: #c05621;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.8em;
        }
        
        .on-time-return {
            background: #f0fff4;
            color: #276749;
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
                <h2>🔄 Returns Management</h2>
                <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>
            </div>
        </div>
        
        <% 
        List<ReturnVehicle> returns = (List<ReturnVehicle>) request.getAttribute("returns"); 
        int totalReturns = 0;
        double totalExtraCharges = 0;
        int lateReturns = 0;
        
        if (returns != null) {
            totalReturns = returns.size();
            for (ReturnVehicle returnVehicle : returns) {
                totalExtraCharges += returnVehicle.getExtra_charge();
                if (returnVehicle.getExtra_charge() > 0) lateReturns++;
            }
        }
        %>
        
        <!-- Statistics Section -->
        <div class="stats-section">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><%= totalReturns %></div>
                    <div class="stat-label">Total Returns</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">₹<%= String.format("%.0f", totalExtraCharges) %></div>
                    <div class="stat-label">Extra Charges</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= lateReturns %></div>
                    <div class="stat-label">Late Returns</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= totalReturns - lateReturns %></div>
                    <div class="stat-label">On-Time Returns</div>
                </div>
            </div>
        </div>
        
        <div class="table-container">
            <% if (returns != null && !returns.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>🔄 Return ID</th>
                            <th>📋 Booking ID</th>
                            <th>👤 User Name</th>
                            <th>🚗 Vehicle Name</th>
                            <th>📅 Expected Date</th>
                            <th>📅 Actual Date</th>
                            <th>💰 Extra Charge</th>
                            <th>📊 Status</th>
                            <th>📝 Remarks</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (ReturnVehicle returnVehicle : returns) { %>
                            <tr>
                                <td><span class="return-id">RET-<%= returnVehicle.getReturn_id() %></span></td>
                                <td>BOOK-<%= returnVehicle.getBooking() != null ? returnVehicle.getBooking().getBooking_id() : "N/A" %></td>
                                <td><%= returnVehicle.getUserName() %></td>
                                <td><%= returnVehicle.getVehicleName() %></td>
                                <td><%= returnVehicle.getReturn_date() %></td>
                                <td><%= returnVehicle.getActual_return_date() != null ? returnVehicle.getActual_return_date() : "N/A" %></td>
                                <td>
                                    <% if (returnVehicle.getExtra_charge() > 0) { %>
                                        <span class="extra-charge">₹<%= String.format("%.2f", returnVehicle.getExtra_charge()) %></span>
                                    <% } else { %>
                                        <span class="no-charge">₹0.00</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (returnVehicle.getExtra_charge() > 0) { %>
                                        <span class="late-return">Late Return</span>
                                    <% } else { %>
                                        <span class="on-time-return">On Time</span>
                                    <% } %>
                                </td>
                                <td style="max-width: 200px; word-wrap: break-word;">
                                    <%= returnVehicle.getRemarks() != null ? returnVehicle.getRemarks() : "No remarks" %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="no-data">
                    <h3>🔄 No Vehicle Returns Found</h3>
                    <p>There are currently no vehicle returns in the system.</p>
                    <p>Returns will appear here once customers start returning vehicles.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
