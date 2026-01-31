package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/viewPayments")
public class ViewPaymentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO = new PaymentDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession userSession = request.getSession(false);
            if (userSession == null || userSession.getAttribute("user") == null || 
                !"Admin".equals(userSession.getAttribute("userRole"))) {
                response.sendRedirect("login.jsp?error=Access denied. Admin login required.");
                return;
            }

            // Get all payment records with JOIN FETCH
            List<Payment> payments = paymentDAO.listPayments();
            
            // Set attribute and forward to JSP
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("viewPayments.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = URLEncoder.encode("Failed to load payments: " + e.getMessage(), StandardCharsets.UTF_8.toString());
            response.sendRedirect("adminDashboard.jsp?error=" + errorMsg);
        }
    }
}
