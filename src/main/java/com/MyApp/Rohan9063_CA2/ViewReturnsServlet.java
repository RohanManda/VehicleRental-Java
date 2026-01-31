package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewReturns")
public class ViewReturnsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReturnDAO returnDAO = new ReturnDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ReturnVehicle> returns = returnDAO.listReturns();
            request.setAttribute("returns", returns);
            request.getRequestDispatcher("viewReturns.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?error=Failed to load returns");
        }
    }
}
