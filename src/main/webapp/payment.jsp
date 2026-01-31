<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.MyApp.Rohan9063_CA2.*" %>
<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=Please login to make payment");
        return;
    }
    User currentUser = (User) userSession.getAttribute("user");
    
    // Get user's bookings for payment
    BookingDAO bookingDAO = new BookingDAO();
    java.util.List<Booking> userBookings = bookingDAO.getBookingsByUser(currentUser.getUser_id());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Make Payment - Vehicle Rental System</title>
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
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
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
            background: linear-gradient(135deg, #38a169 0%, #2f855a 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(72, 187, 120, 0.3);
        }
        
        .booking-info {
            background: #f0fff4;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border-left: 4px solid #48bb78;
            border: 1px solid #c6f6d5;
        }
        
        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .payment-method {
            background: #f7fafc;
            padding: 20px 15px;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid #e2e8f0;
            font-weight: 500;
        }
        
        .payment-method:hover {
            background: #ebf8ff;
            border-color: #4299e1;
            transform: translateY(-2px);
        }
        
        .payment-method.selected {
            background: #ebf8ff;
            border-color: #4299e1;
            color: #2d3748;
            box-shadow: 0 4px 15px rgba(66, 153, 225, 0.2);
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
            
            .payment-methods {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script>
        function selectPaymentMethod(method) {
            document.getElementById('paymentMethod').value = method;
            
            // Update visual selection
            const methods = document.querySelectorAll('.payment-method');
            methods.forEach(m => m.classList.remove('selected'));
            event.target.classList.add('selected');
        }
        
        function updateBookingInfo() {
            const bookingSelect = document.getElementById('bookingId');
            const selectedOption = bookingSelect.options[bookingSelect.selectedIndex];
            const infoDiv = document.getElementById('bookingInfo');
            const amountInput = document.getElementById('amount');
            
            if (selectedOption.value) {
                const vehicleName = selectedOption.getAttribute('data-vehicle');
                const amount = selectedOption.getAttribute('data-amount');
                const dates = selectedOption.getAttribute('data-dates');
                
                infoDiv.innerHTML = `
                    <div style="font-size: 1.1em; font-weight: 600; color: #2d3748; margin-bottom: 15px;">
                        ✅ Selected Booking Details
                    </div>
                    <div class="booking-details">
                        <div class="detail-item">
                            <div class="detail-label">Vehicle</div>
                            <div class="detail-value">${vehicleName}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Period</div>
                            <div class="detail-value">${dates}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">Amount</div>
                            <div class="detail-value">₹${amount}</div>
                        </div>
                    </div>
                `;
                amountInput.value = amount;
            } else {
                infoDiv.innerHTML = '<div style="text-align: center; color: #718096;">⚠️ Please select a booking to see payment details</div>';
                amountInput.value = '';
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>💳 Make Payment</h2>
            <div class="user-info">Process payment for your booking, <strong><%= currentUser.getName() %></strong></div>
        </div>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert error">
                <strong>⚠️ Error:</strong> <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <% if (userBookings != null && !userBookings.isEmpty()) { %>
            <div class="form-container">
                <form action="makePayment" method="post">
                    <div class="form-group">
                        <label for="bookingId">📋 Select Booking for Payment</label>
                        <select id="bookingId" name="bookingId" required onchange="updateBookingInfo()">
                            <option value="">Choose a booking...</option>
                            <% for (Booking booking : userBookings) {
                                if ("Booked".equals(booking.getStatus())) { %>
                                    <option value="<%= booking.getBooking_id() %>" 
                                            data-vehicle="<%= booking.getVehicle().getVehicle_name() %>"
                                            data-amount="<%= String.format("%.2f", booking.calculateTotalAmount()) %>"
                                            data-dates="<%= booking.getBooking_date() %> to <%= booking.getReturn_date() %>">
                                        BOOK-<%= booking.getBooking_id() %> - <%= booking.getVehicle().getVehicle_name() %>
                                    </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    
                    <div id="bookingInfo" class="booking-info">
                        <div style="text-align: center; color: #718096;">⚠️ Please select a booking to see payment details</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="amount">💰 Payment Amount (₹)</label>
                        <input type="number" id="amount" name="amount" required min="1" step="0.01" readonly 
                               placeholder="Amount will be auto-filled"/>
                    </div>
                    
                    <div class="form-group">
                        <label>💳 Select Payment Method</label>
                        <div class="payment-methods">
                            <div class="payment-method" onclick="selectPaymentMethod('UPI')">
                                📱<br><strong>UPI</strong><br><small>Digital Payment</small>
                            </div>
                            <div class="payment-method" onclick="selectPaymentMethod('Card')">
                                💳<br><strong>Card</strong><br><small>Credit/Debit</small>
                            </div>
                            <div class="payment-method" onclick="selectPaymentMethod('Cash')">
                                💵<br><strong>Cash</strong><br><small>Pay in Person</small>
                            </div>
                        </div>
                        <input type="hidden" id="paymentMethod" name="method" required/>
                    </div>
                    
                    <button type="submit" class="btn">💸 Process Payment</button>
                </form>
            </div>
        <% } else { %>
            <div class="no-bookings">
                <h4>📭 No Pending Payments</h4>
                <p>You don't have any bookings that require payment.</p>
                <p><a href="booking.jsp">Make a new booking</a> to get started!</p>
            </div>
        <% } %>
        
        <a href="userDashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>
