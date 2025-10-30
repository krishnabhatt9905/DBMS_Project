# DBMS Project: Startup Funding & Investor Matchmaking System

A complete database management system that connects startups with potential investors based on domain, funding requirements, and investment preferences.

## 📁 Project Structure

```
DBMS_Project/
├── database_schema.sql      # Student 1: Database schema & ERD
├── queries.sql             # Student 2: SQL queries & stored procedures
├── app.py                  # Student 3: Flask application
├── reports.sql             # Student 4: Report generation queries
├── requirements.txt        # Python dependencies
├── templates/              # HTML templates ✅ COMPLETE
│   ├── base.html           # Base template with navigation
│   ├── index.html          # Landing page
│   ├── about.html          # About page
│   ├── startup_register.html
│   ├── startup_login.html
│   ├── startup_dashboard.html
│   ├── investor_register.html
│   ├── investor_login.html
│   └── investor_dashboard.html
└── README.md              # This file
```

## 🚀 Quick Start

### Prerequisites

1. **MySQL Server** (version 5.7+)
2. **Python** (version 3.7+)
3. **pip** (Python package manager)

### Installation Steps

#### Step 1: Setup MySQL Database

```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE funding_system;

# Exit MySQL
exit
```

#### Step 2: Import Database Schema

```bash
# Import schema (Student 1's work)
mysql -u root -p funding_system < database_schema.sql
```

This will create:
- All tables (Startups, Investors, Funding, Matches, Domains)
- Sample data for testing
- Indexes for performance
- Views for common queries

#### Step 3: Install Python Dependencies

```bash
# Install required packages
pip install -r requirements.txt
```

#### Step 4: Configure Database Connection

Edit `app.py` and update the database credentials:

```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'your_mysql_password',  # Change this!
    'database': 'funding_system'
}
```

#### Step 5: Run the Application

```bash
# Run Flask app
python app.py
```

The application will be available at: `http://localhost:5000`

## 📊 Testing the Project

### Test Student 1 (Database Schema)

```bash
# Login to MySQL
mysql -u root -p funding_system

# Show all tables
SHOW TABLES;

# Describe a table
DESCRIBE Startups;

# Check sample data
SELECT * FROM Startups LIMIT 5;

# Verify relationships
SELECT 
    s.name AS Startup,
    d.domain_name AS Domain,
    i.name AS Investor,
    f.amount AS Funding
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Investors i ON f.investor_id = i.investor_id
JOIN Domains d ON s.domain_id = d.domain_id;
```

### Test Student 2 (Queries)

```bash
# Execute queries from queries.sql
mysql -u root -p funding_system

# Test matchmaking query (find investors for startup with ID 1)
SELECT 
    i.investor_id,
    i.name,
    i.investment_min,
    i.investment_max,
    CASE 
        WHEN FIND_IN_SET(s.domain_id, i.preferred_domains) > 0 THEN 100
        ELSE 50
    END AS match_score
FROM Investors i
CROSS JOIN Startups s
WHERE s.startup_id = 1
  AND i.investment_min <= s.funding_required 
  AND i.investment_max >= s.funding_required
ORDER BY match_score DESC;

# Test stored procedure
CALL RecordFunding(1, 1, 5000000, 'Seed', 'Test funding');
```

### Test Student 3 (Application)

1. **Open browser**: Navigate to `http://localhost:5000`

2. **Test Startup Flow**:
   - Go to "Startup Registration"
   - Register a new startup
   - Login with credentials
   - View dashboard → See matched investors
   - View funding history

3. **Test Investor Flow**:
   - Go to "Investor Registration"
   - Register a new investor
   - Login with credentials
   - View dashboard → See matched startups
   - View portfolio

4. **Test Login with Sample Data**:
   ```
   Startup: contact@aiinsights.com (password: check database)
   Investor: invest@accel.com (password: check database)
   ```

### Test Student 4 (Reports)

```bash
# Run report queries from reports.sql
mysql -u root -p funding_system

# Report 1: List of funded startups
SELECT 
    s.name AS Startup_Name,
    d.domain_name AS Domain,
    i.name AS Investor_Name,
    f.amount AS Funding_Amount,
    f.funding_date AS Date
FROM Funding f
JOIN Startups s ON f.startup_id = s.startup_id
JOIN Investors i ON f.investor_id = i.investor_id
JOIN Domains d ON s.domain_id = d.domain_id
ORDER BY f.funding_date DESC;

# Report 2: Top investors
SELECT 
    i.name AS Investor_Name,
    COUNT(f.funding_id) AS Startups_Funded,
    SUM(f.amount) AS Total_Investment
FROM Investors i
JOIN Funding f ON i.investor_id = f.investor_id
GROUP BY i.investor_id
ORDER BY Total_Investment DESC;
```

## 🎓 Student Responsibilities

### Student 1: Database Designer
**Files**: `database_schema.sql`

**What to demonstrate**:
- Show ER diagram
- Explain table structure
- Demonstrate normalization
- Show foreign key relationships
- Explain constraints

**Demo commands**:
```sql
SHOW TABLES;
DESCRIBE Startups;
SHOW CREATE TABLE Funding;
```

### Student 2: Backend Query Developer
**Files**: `queries.sql`

**What to demonstrate**:
- Registration queries
- Login queries
- Matchmaking algorithm (complex JOIN)
- Stored procedures
- Query optimization with EXPLAIN

**Demo commands**:
```sql
-- Show matchmaking query
-- Show stored procedure code
SHOW PROCEDURE STATUS WHERE Db = 'funding_system';
EXPLAIN SELECT ... (show optimization)
```

### Student 3: Application Developer
**Files**: `app.py`, `templates/`

**What to demonstrate**:
- User registration flow
- Login authentication (bcrypt)
- Dashboard with real-time data
- Matchmaking algorithm integration
- Database connectivity

**Demo flow**:
1. Register startup → Show database INSERT
2. Login → Show session management
3. View matches → Show matchmaking query execution
4. Show code that calls Student 2's queries

### Student 4: Reporting & Integration
**Files**: `reports.sql`, documentation

**What to demonstrate**:
- Generate all 10 reports
- Show visualizations (charts/graphs)
- Export to CSV/Excel
- System statistics
- Complete documentation

**Demo flow**:
1. Run Report 1: Funded startups
2. Run Report 2: Top investors
3. Show domain-wise statistics
4. Export data to Excel

## 🔍 Troubleshooting

### Common Issues

**Issue 1: MySQL connection error**
```
Error: Can't connect to MySQL server
```
**Solution**: Check MySQL is running:
```bash
# Mac/Linux
sudo systemctl start mysql

# Windows
net start MySQL
```

**Issue 2: Access denied for user**
```
Error: Access denied for user 'root'@'localhost'
```
**Solution**: Update password in `app.py` DB_CONFIG

**Issue 3: Table already exists**
```
Error: Table 'Startups' already exists
```
**Solution**: Drop and recreate:
```sql
DROP DATABASE funding_system;
CREATE DATABASE funding_system;
-- Then re-import schema.sql
```

**Issue 4: Flask module not found**
```
ModuleNotFoundError: No module named 'flask'
```
**Solution**: Install dependencies:
```bash
pip install -r requirements.txt
```

## 📝 Sample Test Data

The schema includes sample data:
- **5 Startups**: AI Insights, FinFlow, MediCare AI, LearnHub, ShopEasy
- **5 Investors**: Accel Partners, Sequoia India, Tiger Global, Kalaari Capital, Blume Ventures
- **5 Funding Records**: Already completed investments
- **8 Domains**: AI/ML, FinTech, HealthTech, EdTech, etc.

## 🎤 Presentation Tips

1. **Start with ER diagram** (Student 1)
2. **Show database tables** with sample data
3. **Execute complex queries** (Student 2)
4. **Demo live application** (Student 3)
5. **Generate reports** (Student 4)
6. **Explain integration** between all modules

## 📚 Key Features

- ✓ Normalized database design (3NF)
- ✓ Complex JOINs for matchmaking
- ✓ Stored procedures for reusability
- ✓ Secure password hashing (bcrypt)
- ✓ Session management
- ✓ Real-time data retrieval
- ✓ 10+ comprehensive reports
- ✓ CSV/Excel export capability

## 🎯 Evaluation Points

Each student can independently explain:
- **Student 1**: Schema design, normalization, relationships, constraints
- **Student 2**: Query logic, JOINs, stored procedures, optimization
- **Student 3**: Application architecture, authentication, database connectivity
- **Student 4**: Report generation, data analysis, system integration

---

**Date Created**: October 30, 2025  
**Team Members**: 4 students  
**Database**: MySQL 5.7+  
**Application**: Python Flask

