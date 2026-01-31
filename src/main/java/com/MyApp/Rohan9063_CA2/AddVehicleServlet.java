package com.MyApp.Rohan9063_CA2;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/addVehicle")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, 
    maxFileSize = 1024 * 1024 * 5,       
    maxRequestSize = 1024 * 1024 * 10    
    )
public class AddVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "vehicle_images";
    private VehicleDAO vehicleDAO = new VehicleDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get all form parameters
            String vehicleName = request.getParameter("vehicle_name");
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String vehicleType = request.getParameter("vehicle_type");
            String pricePerDayStr = request.getParameter("price_per_day");
            String yearStr = request.getParameter("year");
            String modelYearStr = request.getParameter("model_year");
            String availabilityStr = request.getParameter("availability");

            // Validate required fields
            if (vehicleName == null || vehicleName.trim().isEmpty()) {
                response.sendRedirect("addVehicle.jsp?error=Vehicle name is required");
                return;
            }
            if (brand == null || brand.trim().isEmpty()) {
                response.sendRedirect("addVehicle.jsp?error=Brand is required");
                return;
            }
            if (model == null || model.trim().isEmpty()) {
                response.sendRedirect("addVehicle.jsp?error=Model is required");
                return;
            }
            if (vehicleType == null || vehicleType.trim().isEmpty()) {
                response.sendRedirect("addVehicle.jsp?error=Vehicle type is required");
                return;
            }
            if (pricePerDayStr == null || pricePerDayStr.trim().isEmpty()) {
                response.sendRedirect("addVehicle.jsp?error=Price per day is required");
                return;
            }
            if (yearStr == null || yearStr.trim().isEmpty()) {
                response.sendRedirect("addVehicle.jsp?error=Year is required");
                return;
            }

            // Parse values
            double pricePerDay = Double.parseDouble(pricePerDayStr);
            int year = Integer.parseInt(yearStr);
            int modelYear = (modelYearStr != null && !modelYearStr.trim().isEmpty()) ? 
                           Integer.parseInt(modelYearStr) : year;
            boolean availability = !"false".equals(availabilityStr);

            // Handle image upload
            String imagePath = null;
            Part filePart = request.getPart("vehicle_image");
            
            if (filePart != null && filePart.getSize() > 0) {
                String uploadResult = uploadFile(filePart, request);
                if (uploadResult.startsWith("ERROR:")) {
                    response.sendRedirect("addVehicle.jsp?error=" + uploadResult);
                    return;
                } else {
                    imagePath = uploadResult;
                }
            }

            // Create vehicle object
            Vehicle vehicle = new Vehicle();
            vehicle.setVehicle_name(vehicleName.trim());
            vehicle.setBrand(brand.trim());
            vehicle.setModel(model.trim());
            vehicle.setVehicle_type(vehicleType);
            vehicle.setPrice_per_day(pricePerDay);
            vehicle.setYear(year);
            vehicle.setModel_year(modelYear);
            vehicle.setAvailability(availability);
            vehicle.setVehicle_image(imagePath);
            vehicle.setImagePath(imagePath);

            boolean isAdded = vehicleDAO.addVehicle(vehicle);

            if (isAdded) {
                response.sendRedirect("addVehicle.jsp?success=Vehicle added successfully!");
            } else {
                response.sendRedirect("addVehicle.jsp?error=Failed to save vehicle to database");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addVehicle.jsp?error=Error: " + e.getMessage());
        }
    }

    private String uploadFile(Part filePart, HttpServletRequest request) {
        try {
            String fileName = filePart.getSubmittedFileName();
            System.out.println("Original filename: " + fileName);
            
            if (fileName == null || fileName.isEmpty()) {
                return "ERROR: No file selected";
            }
            
            if (!fileName.contains(".")) {
                return "ERROR: File must have an extension";
            }
            
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            System.out.println("File extension: " + fileExtension);
            
            if (!isValidImageFile(fileExtension)) {
                return "ERROR: Invalid file type. Only JPG, JPEG, PNG, GIF allowed";
            }
            
            if (filePart.getSize() > 5 * 1024 * 1024) { // 5MB
                return "ERROR: File size too large. Maximum 5MB allowed";
            }
            
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            System.out.println("Unique filename: " + uniqueFileName);
            
            String webAppPath = request.getServletContext().getRealPath("");
            String uploadPath = webAppPath + File.separator + UPLOAD_DIRECTORY;
            
            System.out.println("Web app path: " + webAppPath);
            System.out.println("Upload path: " + uploadPath);
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("Directory created: " + created);
                if (!created) {
                    return "ERROR: Cannot create upload directory";
                }
            }
            
            if (!uploadDir.canWrite()) {
                return "ERROR: Upload directory is not writable";
            }
            
            String fullFilePath = uploadPath + File.separator + uniqueFileName;
            System.out.println("Full file path: " + fullFilePath);
            
            filePart.write(fullFilePath);
            
            File savedFile = new File(fullFilePath);
            if (!savedFile.exists()) {
                return "ERROR: File was not saved successfully";
            }
            
            System.out.println("File saved successfully. Size: " + savedFile.length());
            
            String relativePath = UPLOAD_DIRECTORY + "/" + uniqueFileName;
            System.out.println("Relative path: " + relativePath);
            
            return relativePath;
            
        } catch (Exception e) {
            System.err.println("Error in uploadFile: " + e.getMessage());
            e.printStackTrace();
            return "ERROR: Upload failed - " + e.getMessage();
        }
    }
    
    private boolean isValidImageFile(String fileExtension) {
        String[] validExtensions = {".jpg", ".jpeg", ".png", ".gif", ".JPG", ".JPEG", ".PNG", ".GIF"};
        for (String ext : validExtensions) {
            if (fileExtension.equals(ext)) {
                return true;
            }
        }
        return false;
    }
}
