# 🔧 Converting Flask App from MySQL to PostgreSQL

## Overview

This guide shows exactly what to change in `app.py` to make it work with PostgreSQL on Render.

---

## ✅ Step 1: Update imports

**Replace this:**
```python
import mysql.connector
from mysql.connector import Error
```

**With this:**
```python
import psycopg2
from psycopg2.extras import RealDictCursor
import os
```

---

## ✅ Step 2: Update Database Configuration

**Replace this:**
```python
# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'funding_system'
}
```

**With this:**
```python
# Database configuration - Use environment variable from Render
DATABASE_URL = os.environ.get('DATABASE_URL')

if not DATABASE_URL:
    # Fallback for local development
    DATABASE_URL = 'postgresql://postgres:password@localhost/funding_system'
```

---

## ✅ Step 3: Update Connection Function

**Replace this:**
```python
def get_db_connection():
    """Create database connection"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        print(f"Error connecting to database: {e}")
        return None
```

**With this:**
```python
def get_db_connection():
    """Create database connection using PostgreSQL"""
    try:
        connection = psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)
        return connection
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None
```

---

## ✅ Step 4: Update ALL Cursor Usage

### Key Differences:

| MySQL | PostgreSQL |
|-------|-----------|
| `cursor = conn.cursor(dictionary=True)` | Connection already has RealDictCursor |
| `cursor.lastrowid` | Use `RETURNING id` in INSERT |
| `%s` placeholders | Still use `%s` (same) |
| Auto-commit | Need explicit `conn.commit()` |

### Example Changes:

**OLD (MySQL):**
```python
def register_startup():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("""
        INSERT INTO Startups (name, email, password_hash, domain_id, funding_required)
        VALUES (%s, %s, %s, %s, %s)
    """, (name, email, password_hash, domain_id, funding_required))
    
    startup_id = cursor.lastrowid
    conn.commit()
    cursor.close()
    conn.close()
```

**NEW (PostgreSQL):**
```python
def register_startup():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("""
        INSERT INTO Startups (name, email, password_hash, domain_id, funding_required)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING startup_id
    """, (name, email, password_hash, domain_id, funding_required))
    
    startup_id = cursor.fetchone()['startup_id']
    conn.commit()
    cursor.close()
    conn.close()
```

---

## ✅ Step 5: Update All INSERT Queries

**Pattern to follow:**

```python
# Before (MySQL)
cursor.execute("INSERT INTO table (col1, col2) VALUES (%s, %s)", (val1, val2))
new_id = cursor.lastrowid

# After (PostgreSQL)
cursor.execute("""
    INSERT INTO table (col1, col2) 
    VALUES (%s, %s) 
    RETURNING id
""", (val1, val2))
new_id = cursor.fetchone()['id']
```

---

## ✅ Step 6: Update Secret Key

**Replace this:**
```python
app.secret_key = 'your-secret-key-here'
```

**With this:**
```python
app.secret_key = os.environ.get('FLASK_SECRET_KEY', 'dev-secret-key-change-in-production')
```

---

## ✅ Step 7: Update Port Configuration for Render

**Replace this:**
```python
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
```

**With this:**
```python
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=False, host='0.0.0.0', port=port)
```

**Note:** Render sets the `PORT` environment variable automatically.

---

## 🔍 Complete Example: One Route Conversion

### Before (MySQL):
```python
@app.route('/startup/register', methods=['GET', 'POST'])
def startup_register():
    if request.method == 'POST':
        # Get form data
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']
        domain_id = request.form['domain_id']
        funding_required = request.form['funding_required']
        
        # Hash password
        password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
        
        # Database operation
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("""
                INSERT INTO Startups 
                (name, email, password_hash, domain_id, funding_required)
                VALUES (%s, %s, %s, %s, %s)
            """, (name, email, password_hash, domain_id, funding_required))
            
            startup_id = cursor.lastrowid
            conn.commit()
            
            flash('Registration successful!', 'success')
            return redirect(url_for('startup_login'))
            
        except mysql.connector.Error as e:
            flash(f'Registration failed: {e}', 'error')
            
        finally:
            cursor.close()
            conn.close()
    
    return render_template('startup_register.html')
```

### After (PostgreSQL):
```python
@app.route('/startup/register', methods=['GET', 'POST'])
def startup_register():
    if request.method == 'POST':
        # Get form data
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']
        domain_id = request.form['domain_id']
        funding_required = request.form['funding_required']
        
        # Hash password
        password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
        
        # Database operation
        conn = get_db_connection()
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
                INSERT INTO Startups 
                (name, email, password_hash, domain_id, funding_required)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING startup_id
            """, (name, email, password_hash, domain_id, funding_required))
            
            result = cursor.fetchone()
            startup_id = result['startup_id']
            conn.commit()
            
            flash('Registration successful!', 'success')
            return redirect(url_for('startup_login'))
            
        except Exception as e:
            conn.rollback()  # Important for PostgreSQL!
            flash(f'Registration failed: {str(e)}', 'error')
            
        finally:
            cursor.close()
            conn.close()
    
    return render_template('startup_register.html')
```

---

## 📝 Summary of Changes

| Category | Change Required |
|----------|----------------|
| **Imports** | Replace `mysql.connector` with `psycopg2` |
| **Connection** | Use `DATABASE_URL` env variable |
| **Cursor** | Use `RealDictCursor` factory |
| **INSERT queries** | Add `RETURNING id` and use `fetchone()` |
| **Error handling** | Change `mysql.connector.Error` to `Exception` |
| **Rollback** | Add `conn.rollback()` on errors |
| **Port** | Use `os.environ.get('PORT')` |
| **Secret Key** | Use environment variable |

---

## 🚀 Testing Locally with PostgreSQL

### 1. Install PostgreSQL:
```bash
# macOS
brew install postgresql
brew services start postgresql

# Ubuntu
sudo apt install postgresql postgresql-contrib
sudo service postgresql start
```

### 2. Create Database:
```bash
# Create database
createdb funding_system

# Connect to database
psql funding_system

# Run schema
\i database_schema_postgresql.sql
```

### 3. Test with Local DATABASE_URL:
```bash
export DATABASE_URL="postgresql://postgres@localhost/funding_system"
python3 app.py
```

---

## ⚡ Quick Migration Script

I can create a complete `app_postgresql.py` file with all changes applied if you want! Just let me know.

For now, these are the key changes you need to make to your existing `app.py`.

---

## 🔗 Helpful Resources

- [Psycopg2 Documentation](https://www.psycopg.org/docs/)
- [PostgreSQL Python Tutorial](https://www.postgresqltutorial.com/postgresql-python/)
- [Render PostgreSQL Guide](https://render.com/docs/databases)

---

## ✅ Checklist for Conversion

- [ ] Updated imports (psycopg2)
- [ ] Changed connection function
- [ ] Updated all INSERT queries with RETURNING
- [ ] Added RealDictCursor to connection
- [ ] Changed error handling to generic Exception
- [ ] Added rollback() on errors
- [ ] Updated secret key to use env variable
- [ ] Updated port to use env variable
- [ ] Tested locally with PostgreSQL
- [ ] Updated requirements.txt
- [ ] Created database on Render
- [ ] Set DATABASE_URL environment variable
- [ ] Deployed to Render

---

**Ready to deploy with PostgreSQL! 🎉**

