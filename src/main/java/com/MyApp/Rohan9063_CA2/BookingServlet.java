package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/bookVehicle")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDAO bookingDAO = new BookingDAO();
    private UserDAO userDAO = new UserDAO();
    private VehicleDAO vehicleDAO = new VehicleDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = dateFormat.parse(startDateStr);
            Date endDate = dateFormat.parse(endDateStr);

            if (endDate.before(startDate)) {
                response.sendRedirect("booking.jsp?error=" + URLEncoder.encode("End date must be after start date", "UTF-8"));
                return;
            }

            User user = userDAO.searchUserById(userId);
            Vehicle vehicle = vehicleDAO.searchVehicleById(vehicleId);

            if (user == null || vehicle == null) {
                response.sendRedirect("booking.jsp?error=" + URLEncoder.encode("User or vehicle not found", "UTF-8"));
                return;
            }

            if (!vehicle.isAvailability()) {
                response.sendRedirect("booking.jsp?error=" + URLEncoder.encode("Vehicle is not available", "UTF-8"));
                return;
            }
            long timeDiff = endDate.getTime() - startDate.getTime();
            long daysDiff = Math.max(1, timeDiff / (1000 * 60 * 60 * 24));
            double totalAmount = daysDiff * vehicle.getPrice_per_day();

            Booking booking = new Booking();
            booking.setUser(user);
            booking.setVehicle(vehicle);
            booking.setBooking_date(startDate);
            booking.setReturn_date(endDate);
            booking.setTotal_amount(totalAmount);
            booking.setStatus("Booked");

            boolean isBooked = bookingDAO.createBooking(booking);
            
            if (isBooked) {
                vehicle.setAvailability(false);
                vehicleDAO.updateVehicle(vehicle);
                String successMessage = "Vehicle booked successfully! Total: Rs." + String.format("%.2f", totalAmount);
                response.sendRedirect("userDashboard.jsp?success=" + URLEncoder.encode(successMessage, "UTF-8"));
            } else {
                response.sendRedirect("booking.jsp?error=" + URLEncoder.encode("Failed to create booking. Please try again.", "UTF-8"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("booking.jsp?error=" + URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8"));
        }
    }
}
