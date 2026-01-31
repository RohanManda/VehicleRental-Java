<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Vehicle - Admin Panel</title>
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
        
        .breadcrumb {
            color: #718096;
            font-size: 0.95em;
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
        
        input, select { 
            width: 100%; 
            padding: 12px 16px; 
            border: 2px solid #e2e8f0; 
            border-radius: 10px; 
            font-size: 16px; 
            font-family: inherit;
            transition: all 0.3s ease;
            background: #fff;
        }
        
        input:focus, select:focus { 
            border-color: #4299e1; 
            outline: none;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
        }
        
        .btn { 
            background: #4299e1;
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
            background: #3182ce;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(66, 153, 225, 0.3);
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
        
        .success { 
            color: #38a169;
            background: #c6f6d5;
            border-left: 4px solid #48bb78;
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
        
        .required { 
            color: #e53e3e; 
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-row-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
        }
        
        .image-upload-area {
            border: 2px dashed #e2e8f0;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            background: #f7fafc;
            transition: all 0.3s ease;
        }
        
        .image-upload-area:hover {
            border-color: #4299e1;
            background: #ebf8ff;
        }
        
        .image-preview { 
            max-width: 200px; 
            margin-top: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .file-input-label {
            display: inline-block;
            padding: 12px 24px;
            background: #4299e1;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .file-input-label:hover {
            background: #3182ce;
        }
        
        input[type="file"] {
            display: none;
        }
        
        .help-text {
            font-size: 0.85em;
            color: #718096;
            margin-top: 5px;
        }
        
        @media (max-width: 768px) {
            .form-row, .form-row-3 {
                grid-template-columns: 1fr;
                gap: 15px;
            }
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
        }
    </style>
    <script>
        function previewImage(event) {
            const file = event.target.files[0];
            const previewContainer = document.getElementById('previewContainer');
            const preview = document.getElementById('imagePreview');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    previewContainer.style.display = 'block';
                }
                reader.readAsDataURL(file);
            }
        }
        
        // Auto-set model year to match year if not specified
        function syncYears() {
            const year = document.getElementById('year').value;
            const modelYear = document.getElementById('model_year');
            if (year && !modelYear.value) {
                modelYear.value = year;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🚗 Add New Vehicle</h2>
            <div class="breadcrumb">Admin Panel > Fleet Management > Add Vehicle</div>
        </div>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert error">
                <strong>⚠️ Error:</strong> <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <% if (request.getParameter("success") != null) { %>
            <div class="alert success">
                <strong>✅ Success:</strong> <%= request.getParameter("success") %>
            </div>
        <% } %>

        <div class="form-container">
            <form action="addVehicle" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label>🚗 Vehicle Name <span class="required">*</span></label>
                    <input type="text" name="vehicle_name" required maxlength="100" 
                           placeholder="Enter vehicle name (e.g., Honda City, Yamaha R15)"/>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>🏷️ Brand <span class="required">*</span></label>
                        <input type="text" name="brand" required maxlength="100" 
                               placeholder="Honda, Toyota, Yamaha"/>
                    </div>

                    <div class="form-group">
                        <label>📋 Model <span class="required">*</span></label>
                        <input type="text" name="model" required maxlength="100" 
                               placeholder="City, Camry, R15"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>🚙 Vehicle Type <span class="required">*</span></label>
                        <select name="vehicle_type" required>
                            <option value="">Select Vehicle Type</option>
                            <option value="Car">Car</option>
                            <option value="Bike">Bike</option>
                            <option value="Van">Van</option>
                            <option value="Bus">Bus</option>
                            <option value="Truck">Truck</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>💰 Daily Rental Price (₹) <span class="required">*</span></label>
                        <input type="number" name="price_per_day" required min="1" step="0.01" 
                               placeholder="1500.00"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>📅 Manufacturing Year <span class="required">*</span></label>
                        <input type="number" id="year" name="year" required min="1950" max="2025" 
                               placeholder="2023" onchange="syncYears()"/>
                    </div>

                    <div class="form-group">
                        <label>📅 Model Year</label>
                        <input type="number" id="model_year" name="model_year" min="1950" max="2025" 
                               placeholder="2023"/>
                    </div>
                </div>

                <div class="form-group">
                    <label>📸 Vehicle Image</label>
                    <div class="image-upload-area">
                        <label for="vehicle_image" class="file-input-label">
                            📷 Choose Image
                        </label>
                        <input type="file" id="vehicle_image" name="vehicle_image" accept="image/*" onchange="previewImage(event)"/>
                        <div class="help-text">Supported: JPG, PNG, GIF (Max: 5MB)</div>
                        <div id="previewContainer" style="display: none; margin-top: 15px;">
                            <img id="imagePreview" class="image-preview" alt="Preview"/>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>✅ Availability Status</label>
                    <select name="availability">
                        <option value="true">Available for Rent</option>
                        <option value="false">Not Available</option>
                    </select>
                </div>

                <button type="submit" class="btn">🚗 Add Vehicle to Fleet</button>
            </form>
        </div>
        
        <a href="adminDashboard.jsp" class="back-link">← Back to Admin Dashboard</a>
    </div>
</body>
</html>
