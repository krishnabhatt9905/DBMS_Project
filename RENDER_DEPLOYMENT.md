# 🚀 Deploying DBMS Project on Render

## ⚠️ Important: Choose Web Service (NOT Static Site)

The DBMS project is a **Flask web application** that requires a server. Follow these steps:

---

## 📋 Step-by-Step Deployment Guide

### **Step 1: Create a New Web Service**

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** button
3. Select **"Web Service"** (NOT Static Site)

### **Step 2: Connect Your Repository**

1. Connect your GitHub account
2. Select repository: `AdityaPandey-DEV/DBMS-And-OS`
3. Click **"Connect"**

### **Step 3: Configure Build Settings**

Fill in the following settings:

```
Name: dbms-funding-system
Branch: main
Root Directory: DBMS_Project
Runtime: Python 3

Build Command:
pip install -r requirements.txt

Start Command:
gunicorn app:app --bind 0.0.0.0:$PORT
```

### **Step 4: Set Environment Variables**

Click **"Advanced"** and add these environment variables:

| Key | Value | Notes |
|-----|-------|-------|
| `PYTHON_VERSION` | `3.11.0` | Python version |
| `DB_HOST` | `your-db-host` | From Render PostgreSQL/MySQL |
| `DB_USER` | `your-db-user` | Database username |
| `DB_PASSWORD` | `your-db-password` | Database password |
| `DB_NAME` | `funding_system` | Database name |
| `FLASK_SECRET_KEY` | `random-secret-key` | Generate a secure random key |

### **Step 5: Add a Database**

#### **Option A: Use Render's PostgreSQL (Recommended)**
1. In Render Dashboard, create a new **PostgreSQL** database
2. Name it: `funding-db`
3. Copy the connection details to environment variables above

**Note:** You'll need to convert the schema from MySQL to PostgreSQL.

#### **Option B: Use External MySQL (Free Tier)**
Use a free MySQL service like:
- [PlanetScale](https://planetscale.com/) (Free tier available)
- [Railway](https://railway.app/) (MySQL available)
- [Clever Cloud](https://www.clever-cloud.com/) (MySQL free tier)

Then update the environment variables with your MySQL credentials.

### **Step 6: Deploy**

1. Click **"Create Web Service"**
2. Render will automatically:
   - Clone your repository
   - Install dependencies
   - Start the Flask application
3. Wait 5-10 minutes for the first deployment

### **Step 7: Initialize Database**

After deployment, you need to run the SQL schema:

1. Go to your database dashboard (in Render or your MySQL provider)
2. Run the SQL file: `database_schema.sql`
3. This creates all tables and sample data

---

## 🔧 Troubleshooting

### **Issue 1: Build Fails**
- Check that `gunicorn` is in `requirements.txt` ✓
- Verify Python version is compatible (3.9+)

### **Issue 2: Database Connection Error**
- Verify all DB_* environment variables are set correctly
- Check database is running and accessible
- Test connection using database client

### **Issue 3: Application Won't Start**
- Check logs in Render dashboard
- Verify start command: `gunicorn app:app --bind 0.0.0.0:$PORT`
- Ensure port binding is correct

### **Issue 4: CSS/Static Files Not Loading**
Flask should serve static files automatically. If not:
- Check `templates/` and `static/` folders exist
- Verify Flask is configured to serve static files

---

## 📊 After Deployment

Your application will be available at:
```
https://dbms-funding-system.onrender.com
```

### **Test the Deployment:**
1. Visit the homepage
2. Try registering a startup
3. Try registering an investor
4. Test the matchmaking feature

---

## 💡 Alternative: Deploy Without Database (Demo Mode)

If you want to deploy quickly for demonstration without a database:

1. Modify `app.py` to use **SQLite** instead of MySQL
2. SQLite is file-based and doesn't need external database
3. Update configuration:

```python
# Simple SQLite configuration
import sqlite3

def get_db():
    db = sqlite3.connect('funding_system.db')
    db.row_factory = sqlite3.Row
    return db
```

---

## 🔗 Useful Links

- [Render Documentation](https://render.com/docs)
- [Flask Deployment Guide](https://flask.palletsprojects.com/en/2.3.x/deploying/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)

---

## 📝 Notes

- **Free Tier Limitations:**
  - Render free tier spins down after 15 minutes of inactivity
  - First request after spin-down may take 30-60 seconds
  - Consider upgrading for production use

- **Security:**
  - Never commit `.env` file to Git
  - Use strong secret keys in production
  - Enable HTTPS (Render does this automatically)

- **Database:**
  - Regularly backup your database
  - Consider using managed database services
  - Monitor database size (free tiers have limits)

---

## ✅ Deployment Checklist

- [ ] Repository connected to Render
- [ ] Selected **Web Service** (not Static Site)
- [ ] Build command configured
- [ ] Start command configured  
- [ ] All environment variables set
- [ ] Database created and connected
- [ ] SQL schema imported
- [ ] Application tested and working
- [ ] Secret key generated and set

---

**Good luck with your deployment! 🎉**

