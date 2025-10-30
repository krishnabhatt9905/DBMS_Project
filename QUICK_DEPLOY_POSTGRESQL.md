# ⚡ Quick Deploy Guide - PostgreSQL on Render

## 🎯 5-Minute Deployment Checklist

Follow these steps in order for the fastest deployment:

---

## ✅ Step 1: Create PostgreSQL Database (2 minutes)

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"PostgreSQL"**
3. Fill in:
   ```
   Name: funding-system-db
   Database: funding_system
   User: funding_user
   Region: Oregon (or closest to you)
   ```
4. Click **"Create Database"**
5. **Copy the "Internal Database URL"** (starts with `postgresql://`)

---

## ✅ Step 2: Import Database Schema (1 minute)

1. In your PostgreSQL dashboard, click **"Connect"** → **"External Connection"**
2. Copy the `psql` command shown
3. Open your terminal and paste the command
4. Once connected, run:
   ```sql
   \i /path/to/database_schema_postgresql.sql
   ```
   **OR** copy-paste the entire contents of `database_schema_postgresql.sql`

5. Verify:
   ```sql
   \dt  -- List all tables
   SELECT COUNT(*) FROM Startups;  -- Should show 5
   ```

---

## ✅ Step 3: Update App for PostgreSQL (2 minutes)

### Option A: Quick Script Update

Replace in `app.py`:

```python
# Line 1-2: Update imports
import psycopg2
from psycopg2.extras import RealDictCursor
import os

# Line ~10: Update database config
DATABASE_URL = os.environ.get('DATABASE_URL')

# Line ~15: Update connection function
def get_db_connection():
    return psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)

# Update all INSERT queries: Add RETURNING id
cursor.execute("INSERT ... RETURNING startup_id")
startup_id = cursor.fetchone()['startup_id']

# Bottom: Update port
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=False, host='0.0.0.0', port=port)
```

### Option B: Use Different Requirements File

Update `render.yaml` to use:
```yaml
buildCommand: pip install -r requirements_postgresql.txt
```

**Full conversion guide**: See `APP_POSTGRESQL_CHANGES.md`

---

## ✅ Step 4: Deploy Web Service (2 minutes)

1. Click **"New +"** → **"Web Service"** (NOT Static Site!)
2. Connect your GitHub repository
3. Configure:

```
Name: dbms-funding-system
Branch: main
Root Directory: DBMS_Project

Build Command:
pip install -r requirements_postgresql.txt

Start Command:
gunicorn app:app --bind 0.0.0.0:$PORT
```

---

## ✅ Step 5: Set Environment Variables (1 minute)

In the Web Service settings, add:

### Method 1: Link Database (Easiest)
1. Click **"Environment"** tab
2. Look for **"Add from Database"** button
3. Select `funding-system-db`
4. Render automatically adds `DATABASE_URL` ✨

### Method 2: Manual Entry
Add these variables:

| Key | Value | Where to get it |
|-----|-------|----------------|
| `DATABASE_URL` | `postgresql://user:pass@host/db` | From PostgreSQL dashboard "Internal Database URL" |
| `FLASK_SECRET_KEY` | Random string | Generate: `python -c "import secrets; print(secrets.token_hex(32))"` |

---

## ✅ Step 6: Deploy! (3-5 minutes)

1. Click **"Create Web Service"**
2. Watch the deployment logs
3. Wait for "Live" status
4. Visit your app URL: `https://your-app.onrender.com`

---

## 🎉 Success Checklist

Test these features:

- [ ] Homepage loads
- [ ] Can register a startup
- [ ] Can register an investor
- [ ] Can login as startup
- [ ] Can login as investor
- [ ] Dashboard shows matches
- [ ] No database connection errors

---

## 🚨 Common Issues & Quick Fixes

### Issue 1: "relation does not exist"
**Fix**: Schema not imported. Re-run Step 2.

### Issue 2: "could not connect to server"
**Fix**: Check DATABASE_URL is the **Internal URL** (not External)

### Issue 3: "ModuleNotFoundError: psycopg2"
**Fix**: Make sure you're using `requirements_postgresql.txt`

### Issue 4: Application Error
**Fix**: Check logs in Render Dashboard → Your Service → Logs

---

## 📊 What You Get

### Free Tier Includes:
- ✅ PostgreSQL database (90 days free, then $7/mo)
- ✅ Web service (750 hours/month free)
- ✅ Automatic HTTPS
- ✅ Daily backups
- ✅ 1GB database storage

### Limitations:
- ⚠️ Service spins down after 15 min inactivity
- ⚠️ First request after spin-down takes ~30-60 seconds
- ⚠️ 1GB database storage limit

---

## 🔗 All Files You Need

In your repository:

1. ✅ `database_schema_postgresql.sql` - Database schema
2. ✅ `requirements_postgresql.txt` - Python dependencies
3. ✅ `app.py` - Flask application (update for PostgreSQL)
4. ✅ `templates/` - HTML templates (no changes needed)

**Complete guides:**
- `RENDER_POSTGRESQL_SETUP.md` - Detailed setup guide
- `APP_POSTGRESQL_CHANGES.md` - Code conversion guide

---

## 💡 Pro Tips

1. **Test Locally First**
   ```bash
   brew install postgresql
   createdb funding_system
   export DATABASE_URL="postgresql://localhost/funding_system"
   python app.py
   ```

2. **Monitor Your App**
   - Dashboard → Service → Metrics
   - Check response times, error rates

3. **View Logs**
   - Dashboard → Service → Logs
   - Real-time error messages

4. **Database Backups**
   - Automatic daily backups
   - Dashboard → Database → Backups

5. **Custom Domain**
   - Dashboard → Service → Settings → Custom Domain
   - Add your own domain (requires DNS setup)

---

## 🎯 Deployment Timeline

| Step | Time | Status |
|------|------|--------|
| Create PostgreSQL database | 2 min | ⏱️ |
| Import schema | 1 min | ⏱️ |
| Update app code | 2 min | ⏱️ |
| Configure web service | 2 min | ⏱️ |
| Set environment variables | 1 min | ⏱️ |
| Build & deploy | 5 min | ⏱️ |
| **Total** | **~13 minutes** | 🎉 |

---

## 🆘 Need Help?

1. **Check Logs**: Always check Render logs first
2. **Database Connection**: Use `\conninfo` in psql
3. **Test Queries**: Run SQL directly in database console
4. **Local Testing**: Test with local PostgreSQL first

---

## ✅ Final Checklist Before Going Live

- [ ] PostgreSQL database created on Render
- [ ] Schema imported successfully
- [ ] `app.py` updated for PostgreSQL
- [ ] `requirements_postgresql.txt` exists
- [ ] Web service created (NOT static site)
- [ ] DATABASE_URL environment variable set
- [ ] FLASK_SECRET_KEY set
- [ ] Build command uses correct requirements file
- [ ] App deployed successfully
- [ ] All features tested and working
- [ ] No errors in logs

---

## 🎓 For Presentation

**What to show faculty:**

1. **Live Application**: `https://your-app.onrender.com`
2. **Database Dashboard**: Show PostgreSQL metrics
3. **Deployment Logs**: Show successful build
4. **GitHub Repository**: Show clean code structure
5. **Architecture**: Explain PostgreSQL + Flask + Render

**Key Points:**
- ✅ Production-ready deployment
- ✅ Managed database with backups
- ✅ Scalable architecture
- ✅ Industry-standard technologies
- ✅ Automatic HTTPS and security

---

## 📈 After Deployment

### Monitor Performance:
- Response times
- Error rates
- Database connections
- Storage usage

### Scaling Options:
- Upgrade to paid tier for 24/7 uptime
- Add Redis for caching
- Enable connection pooling
- Add CDN for static assets

---

**You're ready to deploy! Follow these steps and your app will be live in ~13 minutes! 🚀**

---

## 🔗 Quick Links

- [Render Dashboard](https://dashboard.render.com/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Psycopg2 Docs](https://www.psycopg.org/docs/)
- [Flask Deployment Guide](https://flask.palletsprojects.com/en/2.3.x/deploying/)

**Happy Deploying! 🎉**

