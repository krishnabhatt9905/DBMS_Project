# 🧪 DBMS Project Testing Guide

Complete step-by-step testing instructions for all 4 student modules.

---

## ⚡ Quick Test (5 minutes)

```bash
# Step 1: Setup database
mysql -u root -p
CREATE DATABASE funding_system;
EXIT;

# Step 2: Import schema
mysql -u root -p funding_system < database_schema.sql

# Step 3: Install & run
pip install -r requirements.txt
python app.py

# Step 4: Open browser
http://localhost:5000
```

---

## 📊 Module-by-Module Testing

### ✅ Student 1: Database Schema Testing

**What to test**: Database structure, relationships, sample data

**Commands**:
```sql
-- Login to MySQL
mysql -u root -p funding_system

-- Test 1: Check all tables created
SHOW TABLES;
-- Expected: Domains, Funding, Investors, Matches, Startups

-- Test 2: Verify table structure
DESCRIBE Startups;
DESCRIBE Investors;
DESCRIBE Funding;

-- Test 3: Check foreign keys
SHOW CREATE TABLE Funding;
-- Should show FK to Startups and Investors

-- Test 4: Verify sample data
SELECT COUNT(*) FROM Startups;   -- Should be 5
SELECT COUNT(*) FROM Investors;  -- Should be 5
SELECT COUNT(*) FROM Funding;    -- Should be 5

-- Test 5: Check domain lookup table
SELECT * FROM Domains;
-- Should show: AI/ML, FinTech, HealthTech, EdTech, etc.

-- Test 6: Verify relationships work
SELECT 
    s.name AS Startup,
    d.domain_name AS Domain,
    i.name AS Investor,
    f.amount AS Funding_Amount
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Investors i ON f.investor_id = i.investor_id
JOIN Domains d ON s.domain_id = d.domain_id;
-- Should show 5 funding records with all details

-- Test 7: Check constraints
INSERT INTO Startups (name, email, password_hash, domain_id, funding_required, location)
VALUES ('Test', 'test@test.com', 'hash', 1, -1000, 'Test');
-- Should FAIL: CHECK constraint (funding_required > 0)

-- Test 8: Check indexes
SHOW INDEX FROM Startups;
SHOW INDEX FROM Investors;
```

**What Student 1 should explain**:
- Why normalized to 3NF (show example of removing redundancy)
- How foreign keys maintain referential integrity
- Why indexes were added (performance)
- How constraints prevent invalid data

---

### ✅ Student 2: SQL Queries Testing

**What to test**: Complex queries, stored procedures, matchmaking algorithm

**Commands**:
```sql
-- Login to MySQL
mysql -u root -p funding_system

-- Test 1: Matchmaking Query (MOST IMPORTANT!)
-- Find investors for startup ID 1 (AI Insights)
SELECT 
    i.investor_id,
    i.name,
    i.investment_min,
    i.investment_max,
    i.preferred_domains,
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
WHERE s.startup_id = 1
  AND i.investment_min <= s.funding_required 
  AND i.investment_max >= s.funding_required
ORDER BY match_score DESC, i.portfolio_size ASC
LIMIT 10;
-- Should show 2-3 matched investors with scores

-- Test 2: Search Queries
-- Find all AI/ML startups
SELECT s.name, d.domain_name, s.funding_required
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
WHERE d.domain_name = 'AI/ML';

-- Find investors investing 2-10 Crore
SELECT name, investment_min, investment_max
FROM Investors
WHERE investment_min <= 100000000 AND investment_max >= 20000000;

-- Test 3: Stored Procedure - Register Startup
CALL RegisterStartup(
    'Test Startup',
    'test@startup.com',
    '$2b$12$testHash',
    1,
    5000000.00,
    'Testing startup registration',
    '2024-01-01',
    'Mumbai',
    'http://test.com'
);
-- Should return: Success message

-- Test 4: Stored Procedure - Record Funding
CALL RecordFunding(
    1,  -- investor_id
    1,  -- startup_id
    3000000,  -- amount
    'Seed',
    'Test funding transaction'
);
-- Should: Insert funding, update startup is_funded, update investor portfolio_size

-- Verify it worked:
SELECT * FROM Funding WHERE notes = 'Test funding transaction';
SELECT is_funded FROM Startups WHERE startup_id = 1;

-- Test 5: Custom Function
SELECT CalculateMatchScore(1, 1) AS match_score;
-- Should return: 50 or 100 depending on domain match

-- Test 6: Query Performance
EXPLAIN SELECT 
    i.name,
    s.name,
    s.funding_required
FROM Investors i
CROSS JOIN Startups s
WHERE i.investment_min <= s.funding_required 
  AND i.investment_max >= s.funding_required;
-- Check: Should use indexes (type = ref or range, NOT ALL)
```

**What Student 2 should explain**:
- How matchmaking algorithm works (domain + range)
- Why use CROSS JOIN for all combinations
- How FIND_IN_SET checks domain preference
- Why stored procedures are better than inline queries
- Query optimization strategy (indexes, EXPLAIN)

---

### ✅ Student 3: Flask Application Testing

**What to test**: Web app, authentication, database connectivity

**Step 1: Start Application**
```bash
python app.py
```

**Step 2: Test Startup Flow**

1. **Open browser**: http://localhost:5000
   - ✓ Should see landing page with two cards (Startups / Investors)

2. **Click "Register Startup"**: http://localhost:5000/startup/register
   - ✓ Form should show all fields
   - ✓ Domain dropdown should show 8 domains from database
   - Fill in test data:
     ```
     Name: Test AI Startup
     Email: test@aistartup.com
     Password: test123
     Domain: AI/ML
     Funding Required: 5000000
     Description: AI-powered solution
     Location: Bangalore
     ```
   - ✓ Should redirect to login after success

3. **Login**: http://localhost:5000/startup/login
   - Use: test@aistartup.com / test123
   - ✓ Should show "Welcome back, Test AI Startup!"
   - ✓ Should redirect to dashboard

4. **Dashboard**: http://localhost:5000/startup/dashboard
   - ✓ Should show startup profile card
   - ✓ Should show "Matched Investors" table
   - ✓ Investors should have match scores (100 = perfect, 50 = good)
   - ✓ Should show funding history (may be empty for new startup)
   - ✓ Should show 3 stats cards at bottom

5. **Logout**:
   - ✓ Click Logout → Should return to home page

**Step 3: Test Investor Flow**

1. **Click "Register Investor"**: http://localhost:5000/investor/register
   - Fill in test data:
     ```
     Name: Test Venture Capital
     Email: test@vc.com
     Password: test123
     Investment Min: 2000000 (20 Lakhs)
     Investment Max: 10000000 (1 Crore)
     Preferred Domains: Select AI/ML and FinTech (Ctrl+Click)
     Location: Bangalore
     Phone: +91-9876543210
     ```
   - ✓ Should redirect to login

2. **Login as Investor**:
   - Use: test@vc.com / test123
   - ✓ Should redirect to investor dashboard

3. **Investor Dashboard**: http://localhost:5000/investor/dashboard
   - ✓ Should show investor profile
   - ✓ Should show "Matched Startups" table
   - ✓ Startups should be in 2-10 Crore range (your investment range)
   - ✓ Should show portfolio (may be empty)
   - ✓ Should show 3 stats cards

**Step 4: Test Database Connectivity**

Open Python shell and test queries:
```python
import mysql.connector

conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='your_password',
    database='funding_system'
)

cursor = conn.cursor(dictionary=True)

# Test query
cursor.execute("SELECT * FROM Startups LIMIT 1")
result = cursor.fetchone()
print(result)  # Should show startup data

cursor.close()
conn.close()
```

**What Student 3 should explain**:
- How Flask routes work (show @app.route decorators)
- How bcrypt hashes passwords (show hash_password function)
- How sessions keep users logged in (show session['user_id'])
- How matchmaking query is called from Python (show code)
- How templates receive data (show render_template with variables)

---

### ✅ Student 4: Reports Testing

**What to test**: Analytical reports, statistics, data export

**Commands**:
```sql
-- Login to MySQL
mysql -u root -p funding_system

-- Report 1: List of Funded Startups
SELECT 
    s.name AS Startup_Name,
    d.domain_name AS Domain,
    s.location AS Location,
    i.name AS Investor_Name,
    f.amount AS Funding_Amount,
    f.funding_round AS Round,
    f.funding_date AS Date
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Investors i ON f.investor_id = i.investor_id
JOIN Domains d ON s.domain_id = d.domain_id
ORDER BY f.funding_date DESC;
-- Should show all 5 funding records

-- Report 2: Top Investors by Investment Amount
SELECT 
    i.name AS Investor_Name,
    i.location AS Location,
    COUNT(f.funding_id) AS Startups_Funded,
    SUM(f.amount) AS Total_Investment,
    AVG(f.amount) AS Avg_Investment_Per_Startup
FROM Investors i
JOIN Funding f ON i.investor_id = f.investor_id
GROUP BY i.investor_id, i.name, i.location
HAVING COUNT(f.funding_id) > 0
ORDER BY Total_Investment DESC
LIMIT 10;
-- Should show top investors with aggregated stats

-- Report 3: Domain-wise Funding Statistics
SELECT 
    d.domain_name AS Domain,
    COUNT(DISTINCT s.startup_id) AS Total_Startups,
    COUNT(DISTINCT CASE WHEN s.is_funded = TRUE THEN s.startup_id END) AS Funded_Startups,
    COALESCE(SUM(f.amount), 0) AS Total_Funding,
    COALESCE(AVG(f.amount), 0) AS Avg_Funding_Per_Startup
FROM Domains d
LEFT JOIN Startups s ON d.domain_id = s.domain_id
LEFT JOIN Funding f ON s.startup_id = f.startup_id
GROUP BY d.domain_id, d.domain_name
ORDER BY Total_Funding DESC;
-- Should show all domains with funding stats

-- Report 4: Monthly Funding Trends
SELECT 
    DATE_FORMAT(funding_date, '%Y-%m') AS Month,
    COUNT(funding_id) AS Number_of_Investments,
    SUM(amount) AS Total_Amount_Invested,
    AVG(amount) AS Average_Investment
FROM Funding
GROUP BY DATE_FORMAT(funding_date, '%Y-%m')
ORDER BY Month DESC;
-- Should show funding grouped by month

-- Report 5: System Statistics Summary
SELECT 
    'Total Startups' AS Metric,
    COUNT(*) AS Value
FROM Startups
UNION ALL
SELECT 'Funded Startups', COUNT(*) FROM Startups WHERE is_funded = TRUE
UNION ALL
SELECT 'Total Investors', COUNT(*) FROM Investors
UNION ALL
SELECT 'Total Funding Deals', COUNT(*) FROM Funding
UNION ALL
SELECT 'Total Funding Amount (₹)', SUM(amount) FROM Funding;
-- Should show overall system statistics
```

**Export to CSV**:
```sql
-- Export funded startups report
SELECT 
    s.name, d.domain_name, i.name AS investor, f.amount, f.funding_date
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Investors i ON f.investor_id = i.investor_id
JOIN Domains d ON s.domain_id = d.domain_id
INTO OUTFILE '/tmp/funded_startups.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

**What Student 4 should explain**:
- How GROUP BY aggregates data
- How SUM, COUNT, AVG functions work
- Why LEFT JOIN is used (to include domains with no startups)
- How HAVING filters grouped data (vs WHERE)
- How to export data for Excel/visualization tools

---

## 🎯 Integration Testing

**Test the complete flow end-to-end:**

1. **Startup registers** → Data inserted into Startups table
2. **Investor registers** → Data inserted into Investors table
3. **Startup logs in** → Session created, redirect to dashboard
4. **Dashboard loads** → Matchmaking query executes, shows investors
5. **Investor logs in** → Session created, redirect to investor dashboard
6. **Investor dashboard loads** → Reverse matchmaking shows startups
7. **Admin runs reports** → All analytical queries return data

**Success Criteria**:
✅ All pages load without errors
✅ Matchmaking shows relevant results
✅ Database queries return data
✅ Session persists across pages
✅ Logout clears session
✅ Reports show accurate statistics

---

## 🐛 Common Issues & Solutions

**Issue 1**: "Table doesn't exist"
```bash
# Solution: Re-import schema
mysql -u root -p funding_system < database_schema.sql
```

**Issue 2**: "Access denied for user"
```python
# Solution: Update password in app.py
DB_CONFIG = {
    'password': 'your_actual_mysql_password'  # Change this!
}
```

**Issue 3**: "Template not found"
```bash
# Solution: Ensure templates/ folder exists
ls templates/  # Should show 9 HTML files
```

**Issue 4**: No matched investors/startups showing
```sql
# Solution: Check sample data exists
SELECT COUNT(*) FROM Startups;   -- Should be > 0
SELECT COUNT(*) FROM Investors;  -- Should be > 0
```

**Issue 5**: bcrypt import error
```bash
# Solution: Install requirements
pip install -r requirements.txt
```

---

## ✅ Testing Checklist

Before presentation, verify:

**Student 1 (Database)**:
- [ ] All 5 tables created
- [ ] Foreign keys working
- [ ] Sample data inserted
- [ ] Constraints prevent invalid data
- [ ] Indexes exist

**Student 2 (Queries)**:
- [ ] Matchmaking query returns results
- [ ] Stored procedures execute successfully
- [ ] Custom function works
- [ ] EXPLAIN shows index usage
- [ ] All CRUD operations work

**Student 3 (Application)**:
- [ ] App runs on localhost:5000
- [ ] Startup registration works
- [ ] Investor registration works
- [ ] Login authentication works
- [ ] Dashboards load with data
- [ ] Logout works

**Student 4 (Reports)**:
- [ ] All 10 reports execute
- [ ] Aggregate functions return correct totals
- [ ] GROUP BY works properly
- [ ] Reports show meaningful data
- [ ] CSV export works

---

**✅ If all tests pass → READY FOR DEMONSTRATION!**

