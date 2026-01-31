<%@ page import="java.util.List" %>
<%@ page import="com.MyApp.Rohan9063_CA2.Maintenance" %>
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
    <title>View Maintenance - Admin</title>
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
            color: #ed8936; 
            text-decoration: none; 
            font-weight: 600; 
            padding: 12px 24px;
            border: 2px solid #ed8936;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        
        .back-link:hover { 
            background: #ed8936;
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
        
        .stat-card:nth-child(1) { border-left: 4px solid #ed8936; }
        .stat-card:nth-child(2) { border-left: 4px solid #e53e3e; }
        .stat-card:nth-child(3) { border-left: 4px solid #48bb78; }
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
            background-color: #fffaf0; 
            transition: all 0.2s ease;
        }
        
        .maintenance-id {
            background: #fffaf0;
            color: #c05621;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.8em;
        }
        
        .cost {
            color: #ed8936;
            font-weight: 600;
        }
        
        .status-recent {
            color: #38a169;
            font-weight: 600;
            background: #c6f6d5;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
        }
        
        .status-completed {
            color: #718096;
            font-weight: 600;
            background: #f7fafc;
            padding: 4px 10px;
            border-radius: 12px;
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
                <h2>🔧 Maintenance Records</h2>
                <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>
            </div>
        </div>
        
        <% 
        List<Maintenance> maintenanceList = (List<Maintenance>) request.getAttribute("maintenanceList"); 
        int totalMaintenance = 0;
        double totalCosts = 0;
        int recentMaintenance = 0;
        
        if (maintenanceList != null) {
            totalMaintenance = maintenanceList.size();
            for (Maintenance maintenance : maintenanceList) {
                totalCosts += maintenance.getCost();
                if (maintenance.isRecentMaintenance()) {
                    recentMaintenance++;
                }
            }
        }
        %>
        
        <!-- Statistics Section -->
        <div class="stats-section">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><%= totalMaintenance %></div>
                    <div class="stat-label">Total Records</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">₹<%= String.format("%.0f", totalCosts) %></div>
                    <div class="stat-label">Total Costs</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= recentMaintenance %></div>
                    <div class="stat-label">Recent (30 days)</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">₹<%= totalMaintenance > 0 ? String.format("%.0f", totalCosts / totalMaintenance) : "0" %></div>
                    <div class="stat-label">Average Cost</div>
                </div>
            </div>
        </div>
        
        <div class="table-container">
            <% if (maintenanceList != null && !maintenanceList.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>🔧 Maintenance ID</th>
                            <th>🚗 Vehicle Info</th>
                            <th>📋 Description</th>
                            <th>📅 Service Date</th>
                            <th>💰 Cost</th>
                            <th>📊 Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Maintenance maintenance : maintenanceList) { %>
                            <tr>
                                <td><span class="maintenance-id">MAINT-<%= maintenance.getMaintenance_id() %></span></td>
                                <td>
                                    <%= maintenance.getVehicleInfo() %>
                                    <div style="font-size: 0.8em; color: #718096;">ID: <%= maintenance.getVehicle() != null ? maintenance.getVehicle().getVehicle_id() : "N/A" %></div>
                                </td>
                                <td style="max-width: 300px; word-wrap: break-word;">
                                    <%= maintenance.getDescription() != null ? maintenance.getDescription() : "No description" %>
                                </td>
                                <td><%= maintenance.getMaintenance_date() %></td>
                                <td class="cost">₹<%= String.format("%.2f", maintenance.getCost()) %></td>
                                <td>
                                    <% if (maintenance.isRecentMaintenance()) { %>
                                        <span class="status-recent">Recent</span>
                                    <% } else { %>
                                        <span class="status-completed">Completed</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="no-data">
                    <h3>🔧 No Maintenance Records Found</h3>
                    <p>There are currently no maintenance records in the system.</p>
                    <p>Maintenance records will appear here once services are logged.</p>
                    <p><a href="addMaintenance.jsp" style="color: #ed8936;">Add your first maintenance record</a></p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
