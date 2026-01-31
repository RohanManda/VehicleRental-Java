<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.MyApp.Rohan9063_CA2.*" %>
<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=Please login to return vehicle");
        return;
    }
    User currentUser = (User) userSession.getAttribute("user");
    
    // Get user's active bookings for return
    BookingDAO bookingDAO = new BookingDAO();
    java.util.List<Booking> userBookings = bookingDAO.getBookingsByUser(currentUser.getUser_id());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Return Vehicle - Vehicle Rental System</title>
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
        
        select, input, textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 16px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #fff;
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        select:focus, input:focus, textarea:focus {
            border-color: #4299e1;
            outline: none;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
        }
        
        .btn {
            background: linear-gradient(135deg, #38b2ac 0%, #319795 100%);
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
            background: linear-gradient(135deg, #319795 0%, #2c7a7b 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(56, 178, 172, 0.3);
        }
        
        .booking-info {
            background: #f0ffff;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 4px solid #38b2ac;
            border: 1px solid #b2f5ea;
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
        
        .warning {
            background: #fffbf0;
            color: #975a16;
            border-left: 4px solid #ed8936;
            border: 1px solid #fbd38d;
        }
        
        .no-bookings {
            text-align: center;
            padding: 60px 40px;
            background: #f7fafc;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
        }
        
        .no-bookings h4 {
            color: #2d3748;
            margin-bottom: 15px;
            font-size: 1.5em;
        }
        
        .no-bookings p {
            color: #718096;
            margin-bottom: 10px;
        }
        
        .no-bookings a {
            color: #4299e1;
            text-decoration: none;
            font-weight: 600;
        }
        
        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
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
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .help-text {
            font-size: 0.85em;
            color: #718096;
            margin-top: 5px;
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
        function updateBookingInfo() {
            const bookingSelect = document.getElementById('bookingId');
            const selectedOption = bookingSelect.options[bookingSelect.selectedIndex];
            const infoDiv = document.getElementById('bookingInfo');
            
            if (selectedOption.value) {
                const vehicleName = selectedOption.getAttribute('data-vehicle');
                const returnDate = selectedOption.getAttribute('data-return');
                const bookingDate = selectedOption.getAttribute('data-booking');
                
                infoDiv.innerHTML = `
                    <div style="font-size: 1.1em; font-weight: 600; color: #2d3748; margin-bottom: 15px;">
                        ✅ Selected Return Details
                    </div>
                    <div class="booking-details">
                        <div class="detail-item">
                            <div class="detail-label">Vehicle</div>
                            <div class="detail-value">${vehicleName}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Booking Date</div>
                            <div class="detail-value">${bookingDate}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Expected Return</div>
                            <div class="detail-value">${returnDate}</div>
                        </div>
                    </div>
                `;
                
                // Set default return date to today
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('returnDate').value = today;
            } else {
                infoDiv.innerHTML = '<div style="text-align: center; color: #718096;">⚠️ Please select a booking to return</div>';
            }
        }
        
        window.onload = function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('returnDate').max = today;
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🔄 Return Vehicle</h2>
            <div class="user-info">Complete vehicle return process, <strong><%= currentUser.getName() %></strong></div>
        </div>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert error">
                <strong>⚠️ Error:</strong> <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <% 
        boolean hasActiveBookings = false;
        if (userBookings != null) {
            for (Booking booking : userBookings) {
                if ("Booked".equals(booking.getStatus())) {
                    hasActiveBookings = true;
                    break;
                }
            }
        }
        %>
        
        <% if (hasActiveBookings) { %>
            <div class="alert warning">
                <strong>⚠️ Important:</strong> Please inspect the vehicle before returning and note any damages or issues.
            </div>
            
            <div class="form-container">
                <form action="returnVehicle" method="post">
                    <div class="form-group">
                        <label for="bookingId">📋 Select Booking to Return</label>
                        <select id="bookingId" name="bookingId" required onchange="updateBookingInfo()">
                            <option value="">Choose a booking...</option>
                            <% for (Booking booking : userBookings) {
                                if ("Booked".equals(booking.getStatus())) { %>
                                    <option value="<%= booking.getBooking_id() %>" 
                                            data-vehicle="<%= booking.getVehicle().getVehicle_name() %>"
                                            data-return="<%= booking.getReturn_date() %>"
                                            data-booking="<%= booking.getBooking_date() %>">
                                        BOOK-<%= booking.getBooking_id() %> - <%= booking.getVehicle().getVehicle_name() %>
                                    </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    
                    <div id="bookingInfo" class="booking-info">
                        <div style="text-align: center; color: #718096;">⚠️ Please select a booking to return</div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="returnDate">📅 Actual Return Date</label>
                            <input type="date" id="returnDate" name="returnDate" required/>
                            <div class="help-text">Date when vehicle is actually returned</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="extraCharge">💰 Extra Charges (₹)</label>
                            <input type="number" id="extraCharge" name="extraCharge" min="0" step="0.01" 
                                   placeholder="0.00"/>
                            <div class="help-text">Damages, fuel, late return, etc.</div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="remarks">📝 Inspection Remarks</label>
                        <textarea id="remarks" name="remarks" 
                                  placeholder="Any observations about vehicle condition, damages, issues, etc."></textarea>
                        <div class="help-text">Document any damages or issues found during inspection</div>
                    </div>
                    
                    <button type="submit" class="btn">🎯 Confirm Vehicle Return</button>
                </form>
            </div>
        <% } else { %>
            <div class="no-bookings">
                <h4>🚫 No Active Bookings</h4>
                <p>You don't have any active bookings to return.</p>
                <p><a href="booking.jsp">Make a new booking</a> to get started!</p>
            </div>
        <% } %>
        
        <a href="userDashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>
