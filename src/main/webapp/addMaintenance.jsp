<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.MyApp.Rohan9063_CA2.*" %>
<%
    // Check if user is admin
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null || 
        !"Admin".equals(userSession.getAttribute("userRole"))) {
        response.sendRedirect("login.jsp?error=Access denied. Admin login required.");
        return;
    }
    VehicleDAO vehicleDAO = new VehicleDAO();
    java.util.List<Vehicle> vehicles = vehicleDAO.listVehicles();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Maintenance Record - Admin Panel</title>
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
            max-width: 700px; 
            margin: 40px auto; 
            padding: 0 20px;
        }
        
        .header {
            background: white;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            text-align: center;
        }
        
        .header h2 { 
            color: #2d3748;
            font-size: 2.2em;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .breadcrumb {
            color: #718096;
            font-size: 0.95em;
            margin-top: 10px;
        }
        
        .form-container {
            background: white;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        
        .form-group { 
            margin-bottom: 25px; 
        }
        
        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #2d3748;
            font-size: 0.95em;
        }
        
        input, select, textarea { 
            width: 100%; 
            padding: 12px 16px; 
            border: 2px solid #e2e8f0; 
            border-radius: 10px; 
            font-size: 16px; 
            font-family: inherit;
            transition: all 0.3s ease;
            background: #fff;
        }
        
        input:focus, select:focus, textarea:focus { 
            border-color: #4299e1; 
            outline: none;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .btn { 
            background: #4299e1;
            color: white; 
            padding: 16px 30px; 
            border: none; 
            border-radius: 10px; 
            cursor: pointer; 
            font-size: 16px; 
            font-weight: 600; 
            width: 100%; 
            transition: all 0.3s ease;
            font-family: inherit;
        }
        
        .btn:hover { 
            background: #3182ce;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(66, 153, 225, 0.3);
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
        
        .back-link { 
            display: inline-block;
            margin-top: 30px; 
            color: #4299e1; 
            text-decoration: none; 
            font-weight: 600;
            padding: 10px 20px;
            border: 2px solid #4299e1;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .back-link:hover { 
            background: #4299e1;
            color: white;
            transform: translateY(-2px);
        }
        
        .required { 
            color: #e53e3e; 
        }
        
        .vehicle-info {
            margin-top: 10px;
            padding: 12px;
            background: #f7fafc;
            border-radius: 8px;
            font-size: 0.9em;
            color: #4a5568;
            border: 1px solid #e2e8f0;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        @media (max-width: 600px) {
            .container {
                margin: 20px auto;
                padding: 0 15px;
            }
            
            .header, .form-container {
                padding: 25px 20px;
            }
            
            .header h2 {
                font-size: 1.8em;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
        }
    </style>
    <script>
        function updateVehicleInfo() {
            const vehicleSelect = document.getElementById('vehicleId');
            const selectedOption = vehicleSelect.options[vehicleSelect.selectedIndex];
            const infoDiv = document.getElementById('vehicleInfo');
            
            if (selectedOption.value) {
                const vehicleName = selectedOption.getAttribute('data-name');
                const brand = selectedOption.getAttribute('data-brand');
                const model = selectedOption.getAttribute('data-model');
                
                infoDiv.innerHTML = `✅ Selected: <strong>${vehicleName}</strong> (${brand} ${model})`;
                infoDiv.style.color = '#38a169';
                infoDiv.style.fontWeight = 'normal';
            } else {
                infoDiv.innerHTML = '⚠️ Please select a vehicle';
                infoDiv.style.color = '#718096';
            }
        }
        
        window.onload = function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('maintenanceDate').max = today;
            document.getElementById('maintenanceDate').value = today;
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🔧 Add Maintenance Record</h2>
            <div class="breadcrumb">Admin Panel > Service Department > Add Maintenance</div>
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

        <div class="form-container">
            <form action="addMaintenance" method="post">
                <div class="form-group">
                    <label for="vehicleId">🚗 Select Vehicle <span class="required">*</span></label>
                    <select id="vehicleId" name="vehicleId" required onchange="updateVehicleInfo()">
                        <option value="">Choose a vehicle...</option>
                        <% if (vehicles != null) {
                            for (Vehicle vehicle : vehicles) { %>
                                <option value="<%= vehicle.getVehicle_id() %>" 
                                        data-name="<%= vehicle.getVehicle_name() %>"
                                        data-brand="<%= vehicle.getBrand() %>"
                                        data-model="<%= vehicle.getModel() %>">
                                    <%= vehicle.getVehicle_name() %> - <%= vehicle.getBrand() %> <%= vehicle.getModel() %>
                                </option>
                        <%  }
                        } %>
                    </select>
                    <div id="vehicleInfo" class="vehicle-info">
                        ⚠️ Please select a vehicle
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">📝 Maintenance Description <span class="required">*</span></label>
                    <textarea id="description" name="description" required
                              placeholder="Describe the maintenance work performed (e.g., Oil change, brake repair, tire replacement, etc.)"></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="maintenanceDate">📅 Service Date <span class="required">*</span></label>
                        <input type="date" id="maintenanceDate" name="maintenanceDate" required/>
                    </div>

                    <div class="form-group">
                        <label for="cost">💰 Cost (₹) <span class="required">*</span></label>
                        <input type="number" id="cost" name="cost" required min="0" step="0.01" 
                               placeholder="0.00"/>
                    </div>
                </div>

                <button type="submit" class="btn">🔧 Add Maintenance Record</button>
            </form>
        </div>
        
        <a href="adminDashboard.jsp" class="back-link">← Back to Admin Dashboard</a>
    </div>
</body>
</html>
