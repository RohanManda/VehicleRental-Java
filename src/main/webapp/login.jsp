<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Vehicle Rental System</title>
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
            max-width: 450px; 
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
        
        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #2d3748;
            font-size: 0.95em;
        }
        
        input { 
            width: 100%; 
            padding: 12px 16px; 
            border: 2px solid #e2e8f0; 
            border-radius: 10px; 
            font-size: 16px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #fff;
        }
        
        input:focus { 
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
            font-family: inherit;
            transition: all 0.3s ease;
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
        
        .input-group {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #718096;
        }
        
        .input-group input {
            padding-left: 45px;
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
            <div class="logo">🔑</div>
            <h2>Welcome Back</h2>
            <div class="subtitle">Please sign in to your account</div>
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

        <form action="login" method="post">
            <div class="form-group">
                <label>📧 Email Address <span class="required">*</span></label>
                <div class="input-group">
                    <input type="email" name="email" required placeholder="Enter your email address" />
                </div>
            </div>
            
            <div class="form-group">
                <label>🔒 Password <span class="required">*</span></label>
                <div class="input-group">
                    <input type="password" name="password" required placeholder="Enter your password" />
                </div>
            </div>
            
            <button type="submit" class="btn">🚀 Sign In</button>
        </form>
        
        <div class="divider">
            <span>or</span>
        </div>
        
        <div class="link">
            <p>New to our platform? <a href="register.jsp">Create an account</a></p>
        </div>
    </div>
</body>
</html>
