-- ============================================
-- DBMS Project: SQL Queries
-- Student 2: Backend Query & Data Management
-- ============================================

-- ============================================
-- 1. REGISTRATION QUERIES
-- ============================================

-- Register New Startup
INSERT INTO Startups (name, email, password_hash, domain_id, funding_required, description, founded_date, location, website)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
-- Parameters: name, email, hashed_password, domain_id, funding_required, description, founded_date, location, website

-- Register New Investor
INSERT INTO Investors (name, email, password_hash, investment_min, investment_max, preferred_domains, phone, location)
VALUES (?, ?, ?, ?, ?, ?, ?, ?);
-- Parameters: name, email, hashed_password, investment_min, investment_max, preferred_domains, phone, location

-- ============================================
-- 2. LOGIN & AUTHENTICATION QUERIES
-- ============================================

-- Startup Login (retrieve by email)
SELECT startup_id, name, email, password_hash, domain_id 
FROM Startups 
WHERE email = ?;

-- Investor Login (retrieve by email)
SELECT investor_id, name, email, password_hash, investment_min, investment_max 
FROM Investors 
WHERE email = ?;

-- ============================================
-- 3. PROFILE QUERIES
-- ============================================

-- Get Startup Profile
SELECT s.*, d.domain_name,
       COALESCE(SUM(f.amount), 0) AS total_funding_received
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
LEFT JOIN Funding f ON s.startup_id = f.startup_id
WHERE s.startup_id = ?
GROUP BY s.startup_id;

-- Get Investor Profile
SELECT i.*, 
       COALESCE(SUM(f.amount), 0) AS total_invested,
       COUNT(DISTINCT f.startup_id) AS startups_funded
FROM Investors i
LEFT JOIN Funding f ON i.investor_id = f.investor_id
WHERE i.investor_id = ?
GROUP BY i.investor_id;

-- Update Startup Profile
UPDATE Startups 
SET name = ?, description = ?, funding_required = ?, location = ?, website = ?
WHERE startup_id = ?;

-- Update Investor Profile
UPDATE Investors 
SET name = ?, investment_min = ?, investment_max = ?, preferred_domains = ?, phone = ?, location = ?
WHERE investor_id = ?;

-- ============================================
-- 4. MATCHMAKING QUERIES (COMPLEX)
-- ============================================

-- Find Top Investors for a Startup (Domain + Investment Range Match)
SELECT 
    i.investor_id,
    i.name,
    i.investment_min,
    i.investment_max,
    i.preferred_domains,
    i.location,
    CASE 
        WHEN FIND_IN_SET(s.domain_id, i.preferred_domains) > 0 THEN 100
        ELSE 50
    END AS match_score,
    CASE 
        WHEN FIND_IN_SET(s.domain_id, i.preferred_domains) > 0 THEN 'Perfect domain match'
        ELSE 'Investment range compatible'
    END AS match_reason
FROM Investors i
CROSS JOIN Startups s
WHERE s.startup_id = ?
  AND i.investment_min <= s.funding_required 
  AND i.investment_max >= s.funding_required
ORDER BY match_score DESC, i.portfolio_size ASC
LIMIT 10;

-- Find Top Startups for an Investor
SELECT 
    s.startup_id,
    s.name,
    d.domain_name,
    s.funding_required,
    s.location,
    s.description,
    s.is_funded,
    CASE 
        WHEN FIND_IN_SET(s.domain_id, i.preferred_domains) > 0 THEN 100
        ELSE 50
    END AS match_score
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
CROSS JOIN Investors i
WHERE i.investor_id = ?
  AND s.funding_required >= i.investment_min 
  AND s.funding_required <= i.investment_max
  AND s.is_funded = FALSE
ORDER BY match_score DESC, s.founded_date DESC
LIMIT 10;

-- ============================================
-- 5. SEARCH QUERIES
-- ============================================

-- Search Startups by Domain
SELECT s.*, d.domain_name
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
WHERE d.domain_name = ?
ORDER BY s.created_at DESC;

-- Search Investors by Investment Range
SELECT *
FROM Investors
WHERE investment_min <= ? AND investment_max >= ?
ORDER BY portfolio_size DESC;

-- Search Startups by Funding Requirement
SELECT s.*, d.domain_name
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
WHERE s.funding_required BETWEEN ? AND ?
  AND s.is_funded = FALSE
ORDER BY s.funding_required ASC;

-- Advanced Search: Find AI Startups needing 1-5 Crore
SELECT s.*, d.domain_name
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
WHERE d.domain_name LIKE '%AI%'
  AND s.funding_required BETWEEN 10000000 AND 50000000
  AND s.is_funded = FALSE
ORDER BY s.founded_date DESC;

-- ============================================
-- 6. FUNDING OPERATIONS
-- ============================================

-- Record New Funding
INSERT INTO Funding (investor_id, startup_id, amount, funding_date, funding_round, notes)
VALUES (?, ?, ?, CURDATE(), ?, ?);

-- Update Startup Funded Status
UPDATE Startups 
SET is_funded = TRUE 
WHERE startup_id = ?;

-- Update Investor Portfolio Count
UPDATE Investors 
SET portfolio_size = portfolio_size + 1 
WHERE investor_id = ?;

-- Get Funding History for Startup
SELECT f.*, i.name AS investor_name, f.amount, f.funding_date, f.funding_round
FROM Funding f
JOIN Investors i ON f.investor_id = i.investor_id
WHERE f.startup_id = ?
ORDER BY f.funding_date DESC;

-- Get Funding History for Investor
SELECT f.*, s.name AS startup_name, d.domain_name, f.amount, f.funding_date
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Domains d ON s.domain_id = d.domain_id
WHERE f.investor_id = ?
ORDER BY f.funding_date DESC;

-- ============================================
-- 7. STORED PROCEDURES
-- ============================================

DELIMITER //

-- Procedure: Register Startup (with validation)
CREATE PROCEDURE RegisterStartup(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_domain_id INT,
    IN p_funding_required DECIMAL(15,2),
    IN p_description TEXT,
    IN p_founded_date DATE,
    IN p_location VARCHAR(100),
    IN p_website VARCHAR(200)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: Registration failed' AS message;
    END;
    
    START TRANSACTION;
    
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM Startups WHERE email = p_email) THEN
        SELECT 'Error: Email already registered' AS message;
        ROLLBACK;
    ELSE
        INSERT INTO Startups (name, email, password_hash, domain_id, funding_required, description, founded_date, location, website)
        VALUES (p_name, p_email, p_password_hash, p_domain_id, p_funding_required, p_description, p_founded_date, p_location, p_website);
        
        SELECT 'Success: Startup registered' AS message, LAST_INSERT_ID() AS startup_id;
        COMMIT;
    END IF;
END//

-- Procedure: Record Funding (updates multiple tables)
CREATE PROCEDURE RecordFunding(
    IN p_investor_id INT,
    IN p_startup_id INT,
    IN p_amount DECIMAL(15,2),
    IN p_funding_round VARCHAR(20),
    IN p_notes TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: Funding record failed' AS message;
    END;
    
    START TRANSACTION;
    
    -- Insert funding record
    INSERT INTO Funding (investor_id, startup_id, amount, funding_date, funding_round, notes)
    VALUES (p_investor_id, p_startup_id, p_amount, CURDATE(), p_funding_round, p_notes);
    
    -- Update startup funded status
    UPDATE Startups SET is_funded = TRUE WHERE startup_id = p_startup_id;
    
    -- Update investor portfolio size
    UPDATE Investors SET portfolio_size = portfolio_size + 1 WHERE investor_id = p_investor_id;
    
    SELECT 'Success: Funding recorded' AS message, LAST_INSERT_ID() AS funding_id;
    COMMIT;
END//

-- Function: Calculate Match Score
CREATE FUNCTION CalculateMatchScore(
    p_startup_id INT,
    p_investor_id INT
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_score INT DEFAULT 0;
    DECLARE v_startup_domain INT;
    DECLARE v_startup_funding DECIMAL(15,2);
    DECLARE v_investor_domains VARCHAR(255);
    DECLARE v_investor_min DECIMAL(15,2);
    DECLARE v_investor_max DECIMAL(15,2);
    
    -- Get startup details
    SELECT domain_id, funding_required INTO v_startup_domain, v_startup_funding
    FROM Startups WHERE startup_id = p_startup_id;
    
    -- Get investor details
    SELECT preferred_domains, investment_min, investment_max 
    INTO v_investor_domains, v_investor_min, v_investor_max
    FROM Investors WHERE investor_id = p_investor_id;
    
    -- Check investment range match
    IF v_startup_funding BETWEEN v_investor_min AND v_investor_max THEN
        SET v_score = v_score + 50;
    END IF;
    
    -- Check domain match
    IF FIND_IN_SET(v_startup_domain, v_investor_domains) > 0 THEN
        SET v_score = v_score + 50;
    END IF;
    
    RETURN v_score;
END//

DELIMITER ;

-- ============================================
-- 8. TEST QUERIES (for verification)
-- ============================================

-- Test: Count all records
SELECT 
    (SELECT COUNT(*) FROM Startups) AS total_startups,
    (SELECT COUNT(*) FROM Investors) AS total_investors,
    (SELECT COUNT(*) FROM Funding) AS total_funding_records;

-- Test: Show all domains
SELECT * FROM Domains;

-- Test: Verify foreign key relationships
SELECT 
    s.name AS startup,
    d.domain_name,
    i.name AS investor,
    f.amount
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Investors i ON f.investor_id = i.investor_id
JOIN Domains d ON s.domain_id = d.domain_id;

-- ============================================
-- Query Collection Complete!
-- ============================================

