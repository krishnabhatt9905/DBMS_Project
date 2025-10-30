-- ============================================
-- DBMS Project: Startup Funding System
-- Student 1: Database Schema & ERD
-- ============================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Funding;
DROP TABLE IF EXISTS Startups;
DROP TABLE IF EXISTS Investors;
DROP TABLE IF EXISTS Domains;

-- ============================================
-- Table: Domains (Lookup table for normalization)
-- ============================================
CREATE TABLE Domains (
    domain_id INT PRIMARY KEY AUTO_INCREMENT,
    domain_name VARCHAR(50) UNIQUE NOT NULL
);

-- Insert common domains
INSERT INTO Domains (domain_name) VALUES 
    ('AI/ML'), 
    ('FinTech'), 
    ('HealthTech'), 
    ('EdTech'), 
    ('E-Commerce'),
    ('SaaS'),
    ('CleanTech'),
    ('FoodTech');

-- ============================================
-- Table: Startups
-- ============================================
CREATE TABLE Startups (
    startup_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    domain_id INT NOT NULL,
    funding_required DECIMAL(15,2) NOT NULL CHECK (funding_required > 0),
    description TEXT,
    founded_date DATE,
    location VARCHAR(100),
    website VARCHAR(200),
    is_funded BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (domain_id) REFERENCES Domains(domain_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================
-- Table: Investors
-- ============================================
CREATE TABLE Investors (
    investor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    investment_min DECIMAL(15,2) NOT NULL CHECK (investment_min > 0),
    investment_max DECIMAL(15,2) NOT NULL,
    preferred_domains VARCHAR(255), -- Comma-separated domain_ids
    phone VARCHAR(20),
    location VARCHAR(100),
    portfolio_size INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_investment_range CHECK (investment_max >= investment_min)
);

-- ============================================
-- Table: Funding (Records actual investments)
-- ============================================
CREATE TABLE Funding (
    funding_id INT PRIMARY KEY AUTO_INCREMENT,
    investor_id INT NOT NULL,
    startup_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    funding_date DATE NOT NULL,
    funding_round VARCHAR(20) DEFAULT 'Seed', -- Seed, Series A, Series B, etc.
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (investor_id) REFERENCES Investors(investor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (startup_id) REFERENCES Startups(startup_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================
-- Table: Matches (Potential investor-startup matches)
-- ============================================
CREATE TABLE Matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    investor_id INT NOT NULL,
    startup_id INT NOT NULL,
    match_score INT DEFAULT 0 CHECK (match_score BETWEEN 0 AND 100),
    match_reason VARCHAR(255),
    is_contacted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (investor_id) REFERENCES Investors(investor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (startup_id) REFERENCES Startups(startup_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    UNIQUE KEY unique_match (investor_id, startup_id)
);

-- ============================================
-- Indexes for Performance (Student 1)
-- ============================================
CREATE INDEX idx_startup_domain ON Startups(domain_id);
CREATE INDEX idx_startup_funded ON Startups(is_funded);
CREATE INDEX idx_investor_investment_range ON Investors(investment_min, investment_max);
CREATE INDEX idx_funding_investor ON Funding(investor_id);
CREATE INDEX idx_funding_startup ON Funding(startup_id);
CREATE INDEX idx_matches_score ON Matches(match_score DESC);

-- ============================================
-- Sample Data for Testing
-- ============================================

-- Insert Sample Startups
INSERT INTO Startups (name, email, password_hash, domain_id, funding_required, description, founded_date, location) VALUES
    ('AI Insights', 'contact@aiinsights.com', '$2b$12$KIXx5vJ9H.P7YqK0', 1, 5000000.00, 'AI-powered business analytics platform', '2024-01-15', 'Bangalore'),
    ('FinFlow', 'hello@finflow.io', '$2b$12$LMWy6wK8I.Q8ZrL1', 2, 3000000.00, 'Digital payment solutions for SMEs', '2023-08-20', 'Mumbai'),
    ('MediCare AI', 'info@medicareai.com', '$2b$12$NXZz7xM9J.R9AsM2', 3, 8000000.00, 'AI-driven diagnostic tools', '2024-03-10', 'Hyderabad'),
    ('LearnHub', 'team@learnhub.edu', '$2b$12$OYAa8yN0K.S0BtN3', 4, 2000000.00, 'Personalized learning platform', '2023-11-05', 'Delhi'),
    ('ShopEasy', 'support@shopeasy.in', '$2b$12$PZBb9zO1L.T1CuO4', 5, 4000000.00, 'Social commerce platform', '2024-02-28', 'Pune');

-- Insert Sample Investors
INSERT INTO Investors (name, email, password_hash, investment_min, investment_max, preferred_domains, phone, location) VALUES
    ('Accel Partners', 'invest@accel.com', '$2b$12$QaCc0aP2M.U2DvP5', 2000000.00, 10000000.00, '1,2,5', '+91-9876543210', 'Bangalore'),
    ('Sequoia India', 'deals@sequoia.in', '$2b$12$RbDd1bQ3N.V3EwQ6', 5000000.00, 20000000.00, '1,3', '+91-9876543211', 'Mumbai'),
    ('Tiger Global', 'info@tigerglobal.com', '$2b$12$ScEe2cR4O.W4FxR7', 3000000.00, 15000000.00, '2,5', '+91-9876543212', 'Bangalore'),
    ('Kalaari Capital', 'hello@kalaari.com', '$2b$12$TdFf3dS5P.X5GyS8', 1000000.00, 5000000.00, '1,4', '+91-9876543213', 'Bangalore'),
    ('Blume Ventures', 'contact@blume.vc', '$2b$12$UeGg4eT6Q.Y6HzT9', 1500000.00, 8000000.00, '3,4,5', '+91-9876543214', 'Mumbai');

-- Insert Sample Funding Records
INSERT INTO Funding (investor_id, startup_id, amount, funding_date, funding_round, notes) VALUES
    (1, 1, 5000000.00, '2024-06-15', 'Seed', 'Impressed by AI capabilities'),
    (2, 3, 8000000.00, '2024-07-20', 'Series A', 'Strong healthcare market potential'),
    (3, 2, 3000000.00, '2024-05-10', 'Seed', 'Innovative fintech solution'),
    (4, 4, 2000000.00, '2024-08-01', 'Seed', 'EdTech space is growing'),
    (5, 5, 4000000.00, '2024-09-15', 'Seed', 'Social commerce trend');

-- Update funded status
UPDATE Startups SET is_funded = TRUE WHERE startup_id IN (1, 2, 3, 4, 5);

-- Update investor portfolio size
UPDATE Investors i SET portfolio_size = (
    SELECT COUNT(*) FROM Funding f WHERE f.investor_id = i.investor_id
);

-- Insert Sample Matches
INSERT INTO Matches (investor_id, startup_id, match_score, match_reason) VALUES
    (1, 1, 95, 'Perfect domain match (AI) and investment range'),
    (2, 1, 80, 'Domain match, investment range suitable'),
    (1, 2, 70, 'Investment range good, partial domain match'),
    (3, 2, 90, 'Excellent FinTech domain match'),
    (4, 4, 85, 'EdTech specialization match');

-- ============================================
-- Views for Common Queries
-- ============================================

CREATE VIEW v_startup_details AS
SELECT 
    s.startup_id,
    s.name AS startup_name,
    d.domain_name,
    s.funding_required,
    s.location,
    s.is_funded,
    COALESCE(SUM(f.amount), 0) AS total_funding_received
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
LEFT JOIN Funding f ON s.startup_id = f.startup_id
GROUP BY s.startup_id;

CREATE VIEW v_investor_portfolio AS
SELECT 
    i.investor_id,
    i.name AS investor_name,
    i.investment_min,
    i.investment_max,
    i.portfolio_size,
    COALESCE(SUM(f.amount), 0) AS total_invested
FROM Investors i
LEFT JOIN Funding f ON i.investor_id = f.investor_id
GROUP BY i.investor_id;

-- ============================================
-- Database Schema Complete
-- Students can now use this for queries!
-- ============================================

