<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.MyApp.Rohan9063_CA2.*" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=Please login to book a vehicle");
        return;
    }
    User currentUser = (User) userSession.getAttribute("user");
    
    VehicleDAO vehicleDAO = new VehicleDAO();
    java.util.List<Vehicle> availableVehicles = vehicleDAO.getAvailableVehicles();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Vehicle - Vehicle Rental System</title>
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
            max-width: 800px;
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
        
        .user-info {
            color: #4a5568;
            font-size: 1.1em;
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
        
        select, input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 16px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #fff;
        }
        
        select:focus, input:focus {
            border-color: #4299e1;
            outline: none;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
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
        
        .vehicle-info {
            background: #f0f8ff;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 4px solid #4299e1;
            border: 1px solid #bee3f8;
        }
        
        .price-display {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 25px;
            font-size: 1.2em;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
        }
        
        .date-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
        
        .vehicle-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .detail-item {
            text-align: center;
            padding: 10px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
        }
        
        .detail-label {
            font-size: 0.8em;
            color: #718096;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-weight: 600;
            color: #2d3748;
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
            
            .date-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .vehicle-details {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
    <script>
        function updateVehicleInfo() {
            const vehicleSelect = document.getElementById('vehicleId');
            const selectedOption = vehicleSelect.options[vehicleSelect.selectedIndex];
            const infoDiv = document.getElementById('vehicleInfo');
            const priceDiv = document.getElementById('priceDisplay');
            
            if (selectedOption.value) {
                const vehicleName = selectedOption.getAttribute('data-name');
                const brand = selectedOption.getAttribute('data-brand');
                const model = selectedOption.getAttribute('data-model');
                const price = selectedOption.getAttribute('data-price');
                
                infoDiv.innerHTML = `
                    <div style="font-size: 1.1em; font-weight: 600; color: #2d3748; margin-bottom: 15px;">
                        ✅ Selected: ${vehicleName}
                    </div>
                    <div class="vehicle-details">
                        <div class="detail-item">
                            <div class="detail-label">Brand</div>
                            <div class="detail-value">${brand}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Model</div>
                            <div class="detail-value">${model}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Daily Rate</div>
                            <div class="detail-value">₹${price}</div>
                        </div>
                    </div>
                `;
                priceDiv.innerHTML = `💰 Daily Rate: ₹${price}`;
                calculateTotal();
            } else {
                infoDiv.innerHTML = '<div style="text-align: center; color: #718096;">⚠️ Please select a vehicle to see details</div>';
                priceDiv.innerHTML = '📋 Select vehicle to see pricing';
            }
        }
        
        function calculateTotal() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const vehicleSelect = document.getElementById('vehicleId');
            const selectedOption = vehicleSelect.options[vehicleSelect.selectedIndex];
            
            if (startDate && endDate && selectedOption.value) {
                const price = parseFloat(selectedOption.getAttribute('data-price'));
                const start = new Date(startDate);
                const end = new Date(endDate);
                const timeDiff = end.getTime() - start.getTime();
                const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
                
                if (daysDiff > 0) {
                    const total = daysDiff * price;
                    document.getElementById('priceDisplay').innerHTML = 
                        `💰 ₹${price} × ${daysDiff} day${daysDiff > 1 ? 's' : ''} = <strong>₹${total.toFixed(2)}</strong>`;
                } else {
                    document.getElementById('priceDisplay').innerHTML = '❌ Invalid date range - End date must be after start date';
                }
            }
        }
        
        window.onload = function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').min = today;
            document.getElementById('endDate').min = today;
        }
        
        function updateEndMinDate() {
            const startDate = document.getElementById('startDate').value;
            if (startDate) {
                document.getElementById('endDate').min = startDate;
                calculateTotal();
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🚗 Book Your Vehicle</h2>
            <div class="user-info">Welcome, <strong><%= currentUser.getName() %></strong>!</div>
        </div>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert error">
                <strong>⚠️ Error:</strong> <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <div class="form-container">
            <form action="bookVehicle" method="post">
                <!-- Hidden user ID -->
                <input type="hidden" name="userId" value="<%= currentUser.getUser_id() %>"/>
                
                <div class="form-group">
                    <label for="vehicleId">🚗 Select Vehicle</label>
                    <select id="vehicleId" name="vehicleId" required onchange="updateVehicleInfo()">
                        <option value="">Choose a vehicle...</option>
                        <% if (availableVehicles != null) {
                            for (Vehicle vehicle : availableVehicles) { %>
                                <option value="<%= vehicle.getVehicle_id() %>" 
                                        data-name="<%= vehicle.getVehicle_name() %>"
                                        data-brand="<%= vehicle.getBrand() %>"
                                        data-model="<%= vehicle.getModel() %>"
                                        data-price="<%= vehicle.getPrice_per_day() %>">
                                    <%= vehicle.getVehicle_name() %> - <%= vehicle.getBrand() %> <%= vehicle.getModel() %>
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>
                
                <div id="vehicleInfo" class="vehicle-info">
                    <div style="text-align: center; color: #718096;">⚠️ Please select a vehicle to see details</div>
                </div>
                
                <div id="priceDisplay" class="price-display">
                    📋 Select vehicle to see pricing
                </div>
                
                <div class="date-row">
                    <div class="form-group">
                        <label for="startDate">📅 Start Date</label>
                        <input type="date" id="startDate" name="startDate" required onchange="updateEndMinDate()"/>
                    </div>
                    
                    <div class="form-group">
                        <label for="endDate">📅 End Date</label>
                        <input type="date" id="endDate" name="endDate" required onchange="calculateTotal()"/>
                    </div>
                </div>
                
                <button type="submit" class="btn">🎯 Confirm Booking</button>
            </form>
        </div>
        
        <a href="userDashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>
