package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
@WebServlet("/addMaintenance")
public class AddMaintenanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaintenanceDAO maintenanceDAO = new MaintenanceDAO();
    private VehicleDAO vehicleDAO = new VehicleDAO();
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            String description = request.getParameter("description");
            String maintenanceDateStr = request.getParameter("maintenanceDate");
            double cost = Double.parseDouble(request.getParameter("cost"));
            Vehicle vehicle = vehicleDAO.searchVehicleById(vehicleId);
            if (vehicle == null) {
                response.sendRedirect("addMaintenance.jsp?error=Vehicle not found");
                return;
            }
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date maintenanceDate = dateFormat.parse(maintenanceDateStr);
            Maintenance maintenance = new Maintenance(vehicle, description, maintenanceDate, cost);
            boolean isAdded = maintenanceDAO.addMaintenance(maintenance);
            if (isAdded) {
                response.sendRedirect("addMaintenance.jsp?success=Maintenance record added successfully!");
            } else {
                response.sendRedirect("addMaintenance.jsp?error=Failed to add maintenance record");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addMaintenance.jsp?error=Error: " + e.getMessage());
        }
    }
}
