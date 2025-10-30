-- ============================================
-- DBMS Project: Startup Funding System
-- PostgreSQL Version for Render Deployment
-- Student 1: Database Schema & ERD
-- ============================================

-- Drop existing tables if they exist (CASCADE to handle dependencies)
DROP TABLE IF EXISTS Matches CASCADE;
DROP TABLE IF EXISTS Funding CASCADE;
DROP TABLE IF EXISTS Startups CASCADE;
DROP TABLE IF EXISTS Investors CASCADE;
DROP TABLE IF EXISTS Domains CASCADE;

-- ============================================
-- Table: Domains (Lookup table for normalization)
-- ============================================
CREATE TABLE Domains (
    domain_id SERIAL PRIMARY KEY,
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
    startup_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    domain_id INTEGER NOT NULL,
    funding_required NUMERIC(15,2) NOT NULL CHECK (funding_required > 0),
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
    investor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    investment_min NUMERIC(15,2) NOT NULL CHECK (investment_min > 0),
    investment_max NUMERIC(15,2) NOT NULL,
    preferred_domains VARCHAR(255), -- Comma-separated domain_ids
    phone VARCHAR(20),
    location VARCHAR(100),
    portfolio_size INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_investment_range CHECK (investment_max >= investment_min)
);

-- ============================================
-- Table: Funding (Records actual investments)
-- ============================================
CREATE TABLE Funding (
    funding_id SERIAL PRIMARY KEY,
    investor_id INTEGER NOT NULL,
    startup_id INTEGER NOT NULL,
    amount NUMERIC(15,2) NOT NULL CHECK (amount > 0),
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
    match_id SERIAL PRIMARY KEY,
    investor_id INTEGER NOT NULL,
    startup_id INTEGER NOT NULL,
    match_score INTEGER DEFAULT 0 CHECK (match_score BETWEEN 0 AND 100),
    match_reason VARCHAR(255),
    is_contacted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (investor_id) REFERENCES Investors(investor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (startup_id) REFERENCES Startups(startup_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CONSTRAINT unique_match UNIQUE (investor_id, startup_id)
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
GROUP BY s.startup_id, s.name, d.domain_name, s.funding_required, s.location, s.is_funded;

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
GROUP BY i.investor_id, i.name, i.investment_min, i.investment_max, i.portfolio_size;

-- ============================================
-- PostgreSQL-Specific Enhancements
-- ============================================

-- Add comments to tables (PostgreSQL feature)
COMMENT ON TABLE Domains IS 'Lookup table for startup business domains';
COMMENT ON TABLE Startups IS 'Stores startup information and funding requirements';
COMMENT ON TABLE Investors IS 'Stores investor profiles and investment preferences';
COMMENT ON TABLE Funding IS 'Records actual funding transactions';
COMMENT ON TABLE Matches IS 'Stores potential investor-startup matches based on criteria';

-- Add comments to important columns
COMMENT ON COLUMN Startups.funding_required IS 'Amount of funding required in INR';
COMMENT ON COLUMN Investors.preferred_domains IS 'Comma-separated list of domain IDs';
COMMENT ON COLUMN Matches.match_score IS 'Compatibility score from 0-100';

-- ============================================
-- Helper Functions (PostgreSQL)
-- ============================================

-- Function to calculate match score (Student 2 can explain this)
CREATE OR REPLACE FUNCTION calculate_match_score(
    p_investor_id INTEGER,
    p_startup_id INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_score INTEGER := 0;
    v_funding_required NUMERIC;
    v_investment_min NUMERIC;
    v_investment_max NUMERIC;
    v_startup_domain INTEGER;
    v_preferred_domains VARCHAR;
BEGIN
    -- Get startup details
    SELECT funding_required, domain_id 
    INTO v_funding_required, v_startup_domain
    FROM Startups WHERE startup_id = p_startup_id;
    
    -- Get investor details
    SELECT investment_min, investment_max, preferred_domains
    INTO v_investment_min, v_investment_max, v_preferred_domains
    FROM Investors WHERE investor_id = p_investor_id;
    
    -- Check if funding required is within investment range
    IF v_funding_required BETWEEN v_investment_min AND v_investment_max THEN
        v_score := v_score + 50;
    END IF;
    
    -- Check if domain matches preferred domains
    IF v_preferred_domains LIKE '%' || v_startup_domain::TEXT || '%' THEN
        v_score := v_score + 50;
    END IF;
    
    RETURN v_score;
END;
$$ LANGUAGE plpgsql;

-- Function to get domain name by ID
CREATE OR REPLACE FUNCTION get_domain_name(p_domain_id INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    v_domain_name VARCHAR;
BEGIN
    SELECT domain_name INTO v_domain_name
    FROM Domains WHERE domain_id = p_domain_id;
    
    RETURN v_domain_name;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Triggers (PostgreSQL)
-- ============================================

-- Trigger to update portfolio size when funding is added
CREATE OR REPLACE FUNCTION update_portfolio_size()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Investors 
    SET portfolio_size = (
        SELECT COUNT(*) FROM Funding WHERE investor_id = NEW.investor_id
    )
    WHERE investor_id = NEW.investor_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_portfolio_size
AFTER INSERT ON Funding
FOR EACH ROW
EXECUTE FUNCTION update_portfolio_size();

-- Trigger to update startup funded status
CREATE OR REPLACE FUNCTION update_funded_status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Startups
    SET is_funded = TRUE
    WHERE startup_id = NEW.startup_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_funded_status
AFTER INSERT ON Funding
FOR EACH ROW
EXECUTE FUNCTION update_funded_status();

-- ============================================
-- Verification Queries
-- ============================================

-- Check table counts
SELECT 
    'Domains' AS table_name, COUNT(*) AS record_count FROM Domains
UNION ALL
SELECT 'Startups', COUNT(*) FROM Startups
UNION ALL
SELECT 'Investors', COUNT(*) FROM Investors
UNION ALL
SELECT 'Funding', COUNT(*) FROM Funding
UNION ALL
SELECT 'Matches', COUNT(*) FROM Matches;

-- ============================================
-- Database Schema Complete (PostgreSQL Version)
-- Ready for Render deployment!
-- ============================================

