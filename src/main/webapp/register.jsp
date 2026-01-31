<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration - Vehicle Rental System</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .container { 
            max-width: 550px; 
            width: 100%;
            margin: 20px;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo {
            font-size: 3em;
            margin-bottom: 15px;
        }
        
        h2 { 
            color: #2d3748;
            font-size: 2em;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #718096;
            font-size: 0.95em;
        }
        
        .home-link {
            text-align: center;
            margin-bottom: 25px;
        }
        
        .home-link a {
            color: #4299e1;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .home-link a:hover {
            background: #ebf8ff;
            color: #3182ce;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white; 
            padding: 16px 30px; 
            border: none; 
            border-radius: 10px; 
            cursor: pointer; 
            font-size: 16px;
            font-weight: 600;
            width: 100%;
            font-family: inherit;
            transition: all 0.3s ease;
        }
        
        .btn:hover { 
            background: linear-gradient(135deg, #38a169 0%, #2f855a 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(72, 187, 120, 0.3);
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
        
        .link { 
            text-align: center; 
            margin-top: 25px; 
        }
        
        .link a { 
            color: #4299e1; 
            text-decoration: none; 
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .link a:hover {
            color: #3182ce;
            text-decoration: underline;
        }
        
        .required {
            color: #e53e3e;
        }
        
        .form-note {
            font-size: 0.85em;
            color: #718096;
            margin-top: 5px;
            font-style: italic;
        }
        
        .role-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 10px;
        }
        
        .role-option {
            padding: 15px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #f7fafc;
        }
        
        .role-option:hover {
            border-color: #4299e1;
            background: #ebf8ff;
        }
        
        .role-option.selected {
            border-color: #4299e1;
            background: #ebf8ff;
            color: #2d3748;
        }
        
        .divider {
            text-align: center;
            margin: 30px 0 25px;
            position: relative;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e2e8f0;
        }
        
        .divider span {
            background: white;
            padding: 0 15px;
            color: #718096;
            font-size: 0.9em;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .role-options {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 500px) {
            .container {
                margin: 15px;
                padding: 30px 25px;
            }
            
            h2 {
                font-size: 1.7em;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="home-link">
            <a href="index.jsp">← Back to Home</a>
        </div>
        
        <div class="header">
            <div class="logo">📝</div>
            <h2>Create Account</h2>
            <div class="subtitle">Join our vehicle rental platform</div>
        </div>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert error">
                <strong>⚠️ Error:</strong> <%= request.getParameter("error") %>
            </div>
        <% } %>

        <form action="register" method="post">
            <div class="form-group">
                <label>👤 Full Name <span class="required">*</span></label>
                <input type="text" name="name" required maxlength="100" placeholder="Enter your full name"/>
            </div>
            
            <div class="form-group">
                <label>📧 Email Address <span class="required">*</span></label>
                <input type="email" name="email" required maxlength="100" placeholder="Enter your email address"/>
                <div class="form-note">We'll use this for login and notifications</div>
            </div>
            
            <div class="form-group">
                <label>🔒 Password <span class="required">*</span></label>
                <input type="password" name="password" required minlength="6" maxlength="100" 
                       placeholder="Enter password (minimum 6 characters)"/>
                <div class="form-note">Choose a strong password for security</div>
            </div>
            
            <div class="form-group">
                <label>👥 Account Type <span class="required">*</span></label>
                <select name="role" required>
                    <option value="">Select account type</option>
                    <option value="User" selected>🚗 Customer (Rent Vehicles)</option>
                    <option value="Admin">⚙️ Admin (Manage System)</option>
                </select>
            </div>
            
            <div class="divider">
                <span>Optional Information</span>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>📞 Phone Number</label>
                    <input type="tel" name="phone" maxlength="15" placeholder="Your phone number"/>
                    <div class="form-note">For booking confirmations</div>
                </div>
                
                <div class="form-group">
                    <label>📍 Address</label>
                    <input type="text" name="address" maxlength="255" placeholder="Your address"/>
                    <div class="form-note">For delivery services</div>
                </div>
            </div>
            
            <button type="submit" class="btn">🎯 Create Account</button>
        </form>
        
        <div class="link">
            <p>Already have an account? <a href="login.jsp">Sign in here</a></p>
        </div>
    </div>
</body>
</html>
