-- ============================================
-- DBMS Project: Report Generation Queries
-- Student 4: Reporting & Presentation
-- ============================================

-- ============================================
-- REPORT 1: List of All Funded Startups
-- ============================================

SELECT 
    s.name AS Startup_Name,
    d.domain_name AS Domain,
    s.location AS Location,
    i.name AS Investor_Name,
    f.amount AS Funding_Amount,
    f.funding_round AS Round,
    f.funding_date AS Date,
    DATEDIFF(CURDATE(), f.funding_date) AS Days_Since_Funding
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Investors i ON f.investor_id = i.investor_id
JOIN Domains d ON s.domain_id = d.domain_id
ORDER BY f.funding_date DESC;

-- ============================================
-- REPORT 2: Top Investors by Investment Amount
-- ============================================

SELECT 
    i.name AS Investor_Name,
    i.location AS Location,
    COUNT(f.funding_id) AS Startups_Funded,
    SUM(f.amount) AS Total_Investment,
    AVG(f.amount) AS Avg_Investment_Per_Startup,
    MIN(f.amount) AS Min_Investment,
    MAX(f.amount) AS Max_Investment
FROM Investors i
JOIN Funding f ON i.investor_id = f.investor_id
GROUP BY i.investor_id, i.name, i.location
HAVING COUNT(f.funding_id) > 0
ORDER BY Total_Investment DESC
LIMIT 10;

-- ============================================
-- REPORT 3: Domain-wise Funding Statistics
-- ============================================

SELECT 
    d.domain_name AS Domain,
    COUNT(DISTINCT s.startup_id) AS Total_Startups,
    COUNT(DISTINCT CASE WHEN s.is_funded = TRUE THEN s.startup_id END) AS Funded_Startups,
    COUNT(DISTINCT CASE WHEN s.is_funded = FALSE THEN s.startup_id END) AS Unfunded_Startups,
    COALESCE(SUM(f.amount), 0) AS Total_Funding,
    COALESCE(AVG(f.amount), 0) AS Avg_Funding_Per_Startup,
    ROUND((COUNT(DISTINCT CASE WHEN s.is_funded = TRUE THEN s.startup_id END) * 100.0 / 
           COUNT(DISTINCT s.startup_id)), 2) AS Funding_Success_Rate
FROM Domains d
LEFT JOIN Startups s ON d.domain_id = s.domain_id
LEFT JOIN Funding f ON s.startup_id = f.startup_id
GROUP BY d.domain_id, d.domain_name
ORDER BY Total_Funding DESC;

-- ============================================
-- REPORT 4: Monthly Funding Trends
-- ============================================

SELECT 
    DATE_FORMAT(funding_date, '%Y-%m') AS Month,
    COUNT(funding_id) AS Number_of_Investments,
    SUM(amount) AS Total_Amount_Invested,
    AVG(amount) AS Average_Investment,
    COUNT(DISTINCT investor_id) AS Active_Investors,
    COUNT(DISTINCT startup_id) AS Startups_Funded
FROM Funding
GROUP BY DATE_FORMAT(funding_date, '%Y-%m')
ORDER BY Month DESC;

-- ============================================
-- REPORT 5: Startup Summary Report
-- ============================================

SELECT 
    s.name AS Startup,
    d.domain_name AS Domain,
    s.funding_required AS Funding_Required,
    COALESCE(SUM(f.amount), 0) AS Funding_Received,
    s.funding_required - COALESCE(SUM(f.amount), 0) AS Funding_Gap,
    ROUND((COALESCE(SUM(f.amount), 0) * 100.0 / s.funding_required), 2) AS Funding_Percentage,
    COUNT(f.funding_id) AS Number_of_Investors,
    s.is_funded AS Funded_Status,
    DATEDIFF(CURDATE(), s.founded_date) AS Days_Since_Founded
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
LEFT JOIN Funding f ON s.startup_id = f.startup_id
GROUP BY s.startup_id
ORDER BY Funding_Received DESC;

-- ============================================
-- REPORT 6: Investor Portfolio Analysis
-- ============================================

SELECT 
    i.name AS Investor,
    i.investment_min AS Min_Investment_Range,
    i.investment_max AS Max_Investment_Range,
    i.portfolio_size AS Portfolio_Size,
    COUNT(f.funding_id) AS Total_Investments,
    SUM(f.amount) AS Total_Amount_Invested,
    AVG(f.amount) AS Avg_Investment_Per_Deal,
    GROUP_CONCAT(DISTINCT d.domain_name SEPARATOR ', ') AS Domains_Invested_In,
    DATEDIFF(CURDATE(), MIN(f.funding_date)) AS Days_Since_First_Investment,
    DATEDIFF(CURDATE(), MAX(f.funding_date)) AS Days_Since_Last_Investment
FROM Investors i
LEFT JOIN Funding f ON i.investor_id = f.investor_id
LEFT JOIN Startups s ON f.startup_id = s.startup_id
LEFT JOIN Domains d ON s.domain_id = d.domain_id
GROUP BY i.investor_id
ORDER BY Total_Amount_Invested DESC;

-- ============================================
-- REPORT 7: Match Quality Report
-- ============================================

SELECT 
    m.match_id,
    s.name AS Startup,
    i.name AS Investor,
    m.match_score AS Score,
    m.match_reason AS Reason,
    m.is_contacted AS Contacted,
    CASE 
        WHEN f.funding_id IS NOT NULL THEN 'Funded'
        ELSE 'Not Funded'
    END AS Status,
    DATEDIFF(CURDATE(), m.created_at) AS Days_Since_Match
FROM Matches m
JOIN Startups s ON m.startup_id = s.startup_id
JOIN Investors i ON m.investor_id = i.investor_id
LEFT JOIN Funding f ON m.startup_id = f.startup_id AND m.investor_id = f.investor_id
ORDER BY m.match_score DESC, m.created_at DESC;

-- ============================================
-- REPORT 8: Location-wise Analysis
-- ============================================

SELECT 
    COALESCE(s.location, 'Unknown') AS City,
    COUNT(DISTINCT s.startup_id) AS Total_Startups,
    COUNT(DISTINCT i.investor_id) AS Total_Investors,
    COUNT(DISTINCT f.funding_id) AS Total_Funding_Deals,
    COALESCE(SUM(f.amount), 0) AS Total_Funding_Amount
FROM Startups s
LEFT JOIN Funding f ON s.startup_id = f.startup_id
LEFT JOIN Investors i ON f.investor_id = i.investor_id
GROUP BY s.location
ORDER BY Total_Funding_Amount DESC;

-- ============================================
-- REPORT 9: Unfunded Startups Needing Attention
-- ============================================

SELECT 
    s.name AS Startup,
    d.domain_name AS Domain,
    s.funding_required AS Amount_Needed,
    s.location AS Location,
    DATEDIFF(CURDATE(), s.founded_date) AS Days_Since_Founded,
    DATEDIFF(CURDATE(), s.created_at) AS Days_On_Platform,
    COUNT(m.match_id) AS Potential_Matches,
    s.email AS Contact_Email
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
LEFT JOIN Matches m ON s.startup_id = m.startup_id
WHERE s.is_funded = FALSE
GROUP BY s.startup_id
HAVING Days_On_Platform > 30  -- On platform for more than 30 days
ORDER BY Days_On_Platform DESC;

-- ============================================
-- REPORT 10: System Statistics Summary
-- ============================================

SELECT 
    'Total Startups' AS Metric,
    COUNT(*) AS Value
FROM Startups
UNION ALL
SELECT 
    'Funded Startups',
    COUNT(*)
FROM Startups WHERE is_funded = TRUE
UNION ALL
SELECT 
    'Unfunded Startups',
    COUNT(*)
FROM Startups WHERE is_funded = FALSE
UNION ALL
SELECT 
    'Total Investors',
    COUNT(*)
FROM Investors
UNION ALL
SELECT 
    'Total Funding Deals',
    COUNT(*)
FROM Funding
UNION ALL
SELECT 
    'Total Funding Amount (₹)',
    SUM(amount)
FROM Funding
UNION ALL
SELECT 
    'Average Funding Per Deal (₹)',
    AVG(amount)
FROM Funding
UNION ALL
SELECT 
    'Total Matches Generated',
    COUNT(*)
FROM Matches
UNION ALL
SELECT 
    'Active Domains',
    COUNT(DISTINCT domain_id)
FROM Startups;

-- ============================================
-- EXPORT QUERIES (for CSV generation)
-- ============================================

-- Export All Startups
SELECT * FROM v_startup_details;

-- Export All Investors
SELECT * FROM v_investor_portfolio;

-- Export All Funding Records
SELECT 
    f.*,
    s.name AS startup_name,
    i.name AS investor_name
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Investors i ON f.investor_id = i.investor_id;

-- ============================================
-- VISUALIZATION DATA (for charts)
-- ============================================

-- Data for Domain Distribution Pie Chart
SELECT 
    d.domain_name AS label,
    COUNT(s.startup_id) AS value
FROM Domains d
LEFT JOIN Startups s ON d.domain_id = s.domain_id
GROUP BY d.domain_id
ORDER BY value DESC;

-- Data for Monthly Funding Bar Chart
SELECT 
    DATE_FORMAT(funding_date, '%Y-%m') AS month,
    SUM(amount) AS total_funding
FROM Funding
WHERE funding_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY month
ORDER BY month;

-- Data for Top Investors Bar Chart
SELECT 
    i.name AS investor,
    SUM(f.amount) AS total_invested
FROM Investors i
JOIN Funding f ON i.investor_id = f.investor_id
GROUP BY i.investor_id
ORDER BY total_invested DESC
LIMIT 10;

-- ============================================
-- Reports Complete!
-- Student 4 can use these to generate PDFs/Excel
-- ============================================

