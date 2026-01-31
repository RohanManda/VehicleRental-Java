<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vehicle Rental System - Home</title>
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
            max-width: 900px;
            width: 100%;
            margin: 40px 20px;
            background: white;
            padding: 50px 40px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 4px 25px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }
        
        .logo {
            font-size: 4em;
            margin-bottom: 20px;
        }
        
        h1 {
            color: #2d3748;
            margin-bottom: 15px;
            font-size: 2.8em;
            font-weight: 700;
        }
        
        .subtitle {
            color: #4a5568;
            margin-bottom: 20px;
            font-size: 1.3em;
            font-weight: 500;
        }
        
        .description {
            color: #718096;
            margin-bottom: 40px;
            font-size: 1.05em;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 25px;
            margin-bottom: 50px;
        }
        
        .feature {
            background: #f7fafc;
            padding: 25px 20px;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        
        .feature:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border-color: #4299e1;
        }
        
        .feature-icon {
            font-size: 2.2em;
            margin-bottom: 15px;
            display: block;
        }
        
        .feature-text {
            font-size: 1em;
            color: #2d3748;
            font-weight: 600;
        }
        
        .btn-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-block;
            padding: 16px 40px;
            text-decoration: none;
            border-radius: 12px;
            font-size: 1.1em;
            font-weight: 600;
            transition: all 0.3s ease;
            min-width: 160px;
        }
        
        .btn.primary {
            background: #4299e1;
            color: white;
        }
        
        .btn.primary:hover {
            background: #3182ce;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(66, 153, 225, 0.3);
        }
        
        .btn.secondary {
            background: #48bb78;
            color: white;
        }
        
        .btn.secondary:hover {
            background: #38a169;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(72, 187, 120, 0.3);
        }
        
        .current-time {
            background: #f0f8ff;
            color: #4a5568;
            padding: 12px 24px;
            border-radius: 25px;
            display: inline-block;
            font-size: 0.95em;
            border: 1px solid #bee3f8;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 20px;
            margin-top: 40px;
            padding-top: 40px;
            border-top: 1px solid #e2e8f0;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 2em;
            font-weight: 700;
            color: #4299e1;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 0.9em;
            color: #718096;
            font-weight: 500;
        }
        
        @media (max-width: 600px) {
            .container {
                margin: 20px 15px;
                padding: 40px 25px;
            }
            
            h1 {
                font-size: 2.2em;
            }
            
            .btn-group {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 280px;
            }
            
            .features {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🚗</div>
        <h1>Vehicle Rental System</h1>
        <div class="subtitle">Professional Vehicle Rental Management</div>
        <div class="description">
            Welcome to our comprehensive Vehicle Rental Management System. 
            Rent cars, bikes, vans, and buses with ease. Professional service, competitive rates, and reliable vehicles.
        </div>
        
        <div class="features">
            <div class="feature">
                <div class="feature-icon">🚗</div>
                <div class="feature-text">Wide Vehicle Range</div>
            </div>
            <div class="feature">
                <div class="feature-icon">💰</div>
                <div class="feature-text">Competitive Pricing</div>
            </div>
            <div class="feature">
                <div class="feature-icon">🔒</div>
                <div class="feature-text">Secure Booking</div>
            </div>
            <div class="feature">
                <div class="feature-icon">⭐</div>
                <div class="feature-text">Premium Service</div>
            </div>
        </div>
        
        <div class="btn-group">
            <a href="login.jsp" class="btn primary">🔑 Login</a>
            <a href="register.jsp" class="btn secondary">📝 Register</a>
        </div>
        
        <div class="current-time">
            📅 <%= new java.util.Date() %>
        </div>
        
        <div class="stats">
            <div class="stat-item">
                <div class="stat-number">500+</div>
                <div class="stat-label">Happy Customers</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">50+</div>
                <div class="stat-label">Vehicles Available</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">24/7</div>
                <div class="stat-label">Customer Support</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">99%</div>
                <div class="stat-label">Satisfaction Rate</div>
            </div>
        </div>
    </div>
</body>
</html>
