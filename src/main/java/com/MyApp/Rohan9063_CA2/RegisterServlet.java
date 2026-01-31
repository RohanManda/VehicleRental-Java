package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate required fields
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=Name is required");
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=Email is required");
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=Password is required");
            return;
        }

        // Set default role if not provided
        if (role == null || role.trim().isEmpty()) {
            role = "User";
        }

        // Check if email already exists
        if (userDAO.emailExists(email)) {
            response.sendRedirect("register.jsp?error=Email already registered");
            return;
        }

        // Create new user
        User user = new User(name.trim(), email.trim(), password, role, 
                           phone != null ? phone.trim() : null, 
                           address != null ? address.trim() : null);

        boolean isRegistered = userDAO.registerUser(user);

        if (isRegistered) {
            response.sendRedirect("login.jsp?success=Registration successful! Please login.");
        } else {
            response.sendRedirect("register.jsp?error=Registration failed. Please try again.");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}
