package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Date;

@WebServlet("/makePayment")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO = new PaymentDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Extract parameters from the request
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentMethod = request.getParameter("method");

            // Fetch Booking object from database
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                response.sendRedirect("payment.jsp?error=Invalid booking ID");
                return;
            }

            // Create current date for payment
            Date paymentDate = new Date();

            // Create payment using the correct constructor
            Payment payment = new Payment(booking, amount, paymentDate, paymentMethod);

            boolean isPaymentSaved = paymentDAO.savePayment(payment);
            
            if (isPaymentSaved) {
                response.sendRedirect("userDashboard.jsp?success=Payment processed successfully");
            } else {
                response.sendRedirect("payment.jsp?error=Failed to process payment");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("payment.jsp?error=Invalid booking ID or amount format.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("payment.jsp?error=An error occurred while processing the payment.");
        }
    }
}
