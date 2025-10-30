# 🚀 Manual Startup Guide - DBMS Project

## Quick Start (5 Minutes)

Follow these steps to start the DBMS Flask application:

---

## ✅ Prerequisites

Before starting, ensure you have:
- ✓ Python 3.7+ installed
- ✓ MySQL installed and running
- ✓ Terminal access

---

## 📋 Step-by-Step Instructions

### **Step 1: Install MySQL (if not installed)**

```bash
# Check if MySQL is installed
mysql --version

# If not installed, install via Homebrew
brew install mysql

# Start MySQL service
brew services start mysql
```

---

### **Step 2: Create Database & Import Schema**

**Option A: MySQL without password**
```bash
cd /Users/adityapandey/Desktop/Anshul/DBMS_Project

# Create database
mysql -u root -e "CREATE DATABASE funding_system"

# Import schema and sample data
mysql -u root funding_system < database_schema.sql

# Verify
mysql -u root funding_system -e "SHOW TABLES;"
```

**Option B: MySQL with password**
```bash
cd /Users/adityapandey/Desktop/Anshul/DBMS_Project

# Create database
mysql -u root -p -e "CREATE DATABASE funding_system"
# Enter your password when prompted

# Import schema
mysql -u root -p funding_system < database_schema.sql
# Enter your password when prompted
```

**Expected Output**:
```
+--------------------+
| Tables_in_funding_system |
+--------------------+
| Domains            |
| Funding            |
| Investors          |
| Matches            |
| Startups           |
+--------------------+
```

---

### **Step 3: Set Up Python Virtual Environment**

```bash
cd /Users/adityapandey/Desktop/Anshul/DBMS_Project

# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate

# You should see (venv) in your terminal prompt
```

---

### **Step 4: Install Python Dependencies**

```bash
# Make sure venv is activated (you should see (venv) in prompt)
pip install Flask bcrypt mysql-connector-python

# Or install from requirements.txt
pip install -r requirements.txt
```

**If you get SSL errors**, try:
```bash
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org Flask bcrypt mysql-connector-python
```

---

### **Step 5: Configure Database Password**

Edit `app.py` and update MySQL password:

```bash
# Open in nano
nano app.py

# Or open in your preferred editor
# Find line 16:
```

```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'your_password',  # ← CHANGE THIS!
    'database': 'funding_system'
}
```

**If MySQL has no password**, use:
```python
'password': '',  # Empty string for no password
```

Save and exit (Ctrl+X, then Y, then Enter in nano)

---

### **Step 6: Start the Application**

```bash
# Make sure you're in DBMS_Project directory
cd /Users/adityapandey/Desktop/Anshul/DBMS_Project

# Make sure venv is activated
source venv/bin/activate

# Start Flask
python3 app.py
```

**Expected Output**:
```
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server.
 * Running on http://127.0.0.1:5000
 * Running on http://localhost:5000
Press CTRL+C to quit
```

---

### **Step 7: Open in Browser**

Open your web browser and visit:

```
http://localhost:5000
```

You should see the **beautiful landing page** with:
- 🏢 Startup registration option
- 💰 Investor registration option
- Gradient purple background
- Key features section

---

## 🎯 What You Can Do

Once the application is running:

1. **Register as Startup**:
   - Click "Register Startup"
   - Fill in the form (name, email, password, domain, funding required)
   - Submit

2. **Login**:
   - Use your registered credentials
   - View dashboard

3. **See Matched Investors**:
   - Dashboard shows investors who match your funding requirements
   - Match scores displayed (100 = perfect match)

4. **Register as Investor**:
   - Click "Register Investor"
   - Set investment range
   - Select preferred domains

5. **View Portfolio**:
   - See matched startups
   - View investment history

---

## 🐛 Troubleshooting

### **Error: "Access denied for user 'root'@'localhost'"**

**Solution**: Update password in `app.py` line 16

```python
'password': 'your_actual_mysql_password'
```

---

### **Error: "Unknown database 'funding_system'"**

**Solution**: Create the database first

```bash
mysql -u root -p -e "CREATE DATABASE funding_system"
mysql -u root -p funding_system < database_schema.sql
```

---

### **Error: "No module named 'flask'"**

**Solution**: Install dependencies in virtual environment

```bash
cd DBMS_Project
source venv/bin/activate
pip install Flask bcrypt mysql-connector-python
```

---

### **Error: "Address already in use"**

**Solution**: Port 5000 is busy, kill the process or use different port

```bash
# Find process using port 5000
lsof -ti:5000

# Kill it
kill -9 $(lsof -ti:5000)

# Or change port in app.py (last line):
app.run(debug=True, host='0.0.0.0', port=5001)
```

---

### **Error: "Can't connect to MySQL server"**

**Solution**: Start MySQL

```bash
# Check if MySQL is running
brew services list | grep mysql

# Start MySQL
brew services start mysql

# Or
sudo /usr/local/mysql/support-files/mysql.server start
```

---

## 🔧 Alternative: Use the Startup Script

Instead of manual steps, you can use the automated script:

```bash
cd /Users/adityapandey/Desktop/Anshul/DBMS_Project
./START_PROJECT.sh
```

This script will:
- ✓ Check prerequisites
- ✓ Create virtual environment
- ✓ Install dependencies
- ✓ Set up MySQL database
- ✓ Import sample data
- ✓ Start Flask application

---

## 📊 Test the System

### Quick Test Queries:

```bash
# Check if data was imported
mysql -u root funding_system -e "SELECT COUNT(*) FROM Startups;"
# Should show: 5

mysql -u root funding_system -e "SELECT name FROM Startups;"
# Should show: AI Insights, FinFlow, MediCare AI, LearnHub, ShopEasy

mysql -u root funding_system -e "SELECT name FROM Investors;"
# Should show: Accel Partners, Sequoia India, Tiger Global, etc.
```

### Test the Matchmaking Query:

```sql
mysql -u root funding_system

SELECT 
    i.name AS Investor,
    s.name AS Startup,
    CASE 
        WHEN FIND_IN_SET(s.domain_id, i.preferred_domains) > 0 THEN 100
        ELSE 50
    END AS match_score
FROM Investors i
CROSS JOIN Startups s
WHERE s.startup_id = 1
  AND i.investment_min <= s.funding_required 
  AND i.investment_max >= s.funding_required
ORDER BY match_score DESC
LIMIT 5;
```

Expected: Shows investors matched with "AI Insights" startup

---

## ✅ Success Checklist

Before presenting, verify:

- [ ] MySQL is running
- [ ] Database `funding_system` exists
- [ ] 5 tables created (Startups, Investors, Funding, Matches, Domains)
- [ ] Sample data loaded (5 startups, 5 investors)
- [ ] Flask dependencies installed
- [ ] Password configured in `app.py`
- [ ] Application starts without errors
- [ ] http://localhost:5000 loads
- [ ] Can register new startup
- [ ] Can login
- [ ] Dashboard shows matched investors
- [ ] Matchmaking displays scores

---

## 🎤 For Demonstration

When presenting to faculty:

1. **Start Application**: `./START_PROJECT.sh`
2. **Show Landing Page**: Beautiful UI
3. **Register Startup**: Live registration
4. **Login**: Show authentication
5. **Dashboard**: Display matchmaking results
6. **Explain Code**: Show `app.py`, explain routes
7. **Show Database**: Run SQL queries
8. **Show Match Algorithm**: Explain the query

---

## 📞 Need Help?

- **Database Issues**: See `database_schema.sql`
- **Query Issues**: See `queries.sql`
- **Application Issues**: See `app.py`
- **Testing Issues**: See `TEST_GUIDE.md`
- **Setup Issues**: See `README.md`

---

**Ready to present!** 🎉

