package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/returnVehicle")
public class ReturnServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReturnDAO returnDAO = new ReturnDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    private VehicleDAO vehicleDAO = new VehicleDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Extract parameters
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String returnDateStr = request.getParameter("returnDate");
            double extraCharge = 0.0;
            String remarks = request.getParameter("remarks");
            
            // Parse extra charge if provided
            String extraChargeStr = request.getParameter("extraCharge");
            if (extraChargeStr != null && !extraChargeStr.trim().isEmpty()) {
                extraCharge = Double.parseDouble(extraChargeStr);
            }

            // Parse return date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date actualReturnDate = dateFormat.parse(returnDateStr);

            // Get booking object
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                String errorMsg = URLEncoder.encode("Invalid booking ID", StandardCharsets.UTF_8.toString());
                response.sendRedirect("return.jsp?error=" + errorMsg);
                return;
            }

            if (!"Booked".equals(booking.getStatus())) {
                String errorMsg = URLEncoder.encode("This booking has already been processed", StandardCharsets.UTF_8.toString());
                response.sendRedirect("return.jsp?error=" + errorMsg);
                return;
            }

            // Create return record with actual_return_date set
            ReturnVehicle returnVehicle = new ReturnVehicle();
            returnVehicle.setBooking(booking);
            returnVehicle.setReturn_date(booking.getReturn_date()); // Expected return date
            returnVehicle.setActual_return_date(actualReturnDate);   // Actual return date
            returnVehicle.setExtra_charge(extraCharge);
            returnVehicle.setRemarks(remarks);

            // Save return record
            boolean isReturnSaved = returnDAO.saveReturn(returnVehicle);
            
            if (isReturnSaved) {
                // Update booking status to "Returned"
                booking.setStatus("Returned");
                bookingDAO.updateBooking(booking);
                
                // Update vehicle availability back to true
                if (booking.getVehicle() != null) {
                    booking.getVehicle().setAvailability(true);
                    vehicleDAO.updateVehicle(booking.getVehicle());
                }
                
                // *** FIX: Use ASCII text and URL encode the message ***
                String successMessage = "Vehicle returned successfully! Extra charges: Rs." + String.format("%.2f", extraCharge);
                String encodedMessage = URLEncoder.encode(successMessage, StandardCharsets.UTF_8.toString());
                response.sendRedirect("userDashboard.jsp?success=" + encodedMessage);
            } else {
                String errorMsg = URLEncoder.encode("Failed to process vehicle return. Please try again.", StandardCharsets.UTF_8.toString());
                response.sendRedirect("return.jsp?error=" + errorMsg);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = URLEncoder.encode("An error occurred: " + e.getMessage(), StandardCharsets.UTF_8.toString());
            response.sendRedirect("return.jsp?error=" + errorMsg);
        }
    }
}
