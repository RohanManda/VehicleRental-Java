package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewMaintenance")
public class ViewMaintenanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaintenanceDAO maintenanceDAO = new MaintenanceDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Maintenance> maintenanceList = maintenanceDAO.listMaintenance();
            request.setAttribute("maintenanceList", maintenanceList);
            request.getRequestDispatcher("viewMaintenance.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?error=Failed to load maintenance records");
        }
    }
}
