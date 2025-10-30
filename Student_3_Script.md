# Student 3 – Application & User Module
## Presentation Script (2-3 minutes)

---

## 🎤 Opening (15 seconds)

"Good morning/afternoon. I'm [Your Name], and I developed the **Application Layer and User Interface** for our system. I built the frontend and backend logic that connects users to the database."

---

## 📊 Main Presentation (2 minutes)

### 1. User Registration Modules (30 seconds)

"I created two separate **registration modules**:

- **Startup Registration** – collects name, domain, funding requirement, email, description
- **Investor Registration** – collects name, investment range, preferred domains, contact info

Both modules include **client-side validation** (checking email format, required fields) and **server-side validation** before inserting into the database. After successful registration, users receive confirmation and can log in."

### 2. Authentication System (30 seconds)

"I implemented a secure **login/logout system**:

- Users log in with email and password
- Passwords are **hashed using bcrypt** (not stored in plain text) for security
- On successful login, I create a **session** stored in the database that expires after 24 hours
- Session tokens are checked before allowing access to protected pages
- Logout clears the session from both client and server

This ensures only authenticated users can access their dashboards."

### 3. Database Connectivity (30 seconds)

"I connected the application to the database using **[Python/Java/Node.js] with [MySQL/PostgreSQL] driver**:

- Established **connection pooling** for efficient database access
- All form submissions trigger **SQL queries written by Student 2**
- Real-time data retrieval – dashboards show live data from the database
- **Error handling** – if database connection fails, users see friendly error messages, not crashes
- Used **prepared statements** to prevent SQL injection attacks"

### 4. Matchmaking Logic & Dashboard (45 seconds)

"The core feature is the **intelligent matchmaking algorithm**:

When a startup logs in:
1. The system calls Student 2's matchmaking query with the startup's ID
2. Retrieves investors whose investment range matches the startup's funding need
3. Filters by domain preference using string matching
4. Ranks matches by compatibility score
5. Displays top 10 matches with investor details

I built **dashboards** for both startups and investors:
- Startups see: their profile, funding status, matched investors (sorted by relevance)
- Investors see: their portfolio, potential startups to invest in, filter options by domain/amount
- Both can update their profiles, which triggers UPDATE queries

The interface is **user-friendly** with forms, tables, and responsive design."

---

## 🎯 Closing (15 seconds)

"My application module brings the entire system to life. It uses Student 1's schema design and Student 2's queries to provide an interactive experience. Student 4 integrated my dashboards with reporting features. I can demonstrate the login flow and matchmaking in action. Thank you."

---

## 🔍 Potential Faculty Questions & Answers

### Q1: "How does your application connect to the database?"

**Answer**: "I use [e.g., MySQL Connector for Python]. Here's the basic flow:
```python
import mysql.connector

# Establish connection
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='password',
    database='funding_system'
)
cursor = conn.cursor()

# Execute query
cursor.execute('SELECT * FROM Startups WHERE startup_id = %s', (user_id,))
data = cursor.fetchall()

# Close connection
cursor.close()
conn.close()
```
I use connection pooling so we don't create new connections for every query, which improves performance."

### Q2: "How do you store passwords securely?"

**Answer**: "I never store plain text passwords. I use **bcrypt hashing**:

During registration:
1. User enters password → I hash it using bcrypt
2. Store only the hash in the database

During login:
1. User enters password → I hash it with bcrypt
2. Compare the hash with stored hash
3. If they match, login succeeds

Even if someone accesses the database, they only see hashes like `$2b$12$KIXxxx...`, not actual passwords. Bcrypt also includes a salt, so two identical passwords have different hashes."

### Q3: "What is session management?"

**Answer**: "Session management keeps users logged in across pages:

1. **Login** → I create a unique session_id (random token) and store it in the database with user_id and expiry time
2. **Store token** → I send the session_id to the browser as a cookie
3. **Every request** → Browser sends the cookie, I verify it exists in the database and hasn't expired
4. **Logout** → I delete the session from the database and clear the cookie

This way, users don't have to log in on every page, but we maintain security."

### Q4: "Explain the matchmaking algorithm."

**Answer**: "The matchmaking works in 3 steps:

**Step 1: Investment Range Filter**
- If startup needs ₹2 crore, only show investors who invest between ₹1-5 crore
- SQL: `WHERE investor.min_investment <= 2 AND investor.max_investment >= 2`

**Step 2: Domain Matching**
- If startup is in 'AI', prefer investors who list 'AI' or 'Technology' in preferred domains
- SQL: `WHERE investor.preferred_domains LIKE '%AI%'`

**Step 3: Scoring**
- High Match (100 points): domain exactly matches
- Medium Match (50 points): investment range fits but domain doesn't
- Sort by score and show top 10

I call Student 2's query that implements this logic and display results in the dashboard."

### Q5: "What technology stack did you use?"

**Answer**: "[Example – adapt to your actual stack]
- **Frontend**: HTML, CSS, JavaScript (or React/Flask templates)
- **Backend**: Python with Flask (or Node.js/Java)
- **Database**: MySQL
- **Libraries**: bcrypt for password hashing, mysql-connector for DB access
- **Deployment**: Running locally on localhost:5000

The frontend sends HTTP requests (GET/POST) to backend routes, which execute Student 2's SQL queries and return results as JSON or rendered HTML."

---

## 📋 Quick Reference Points

**Your Module**: Application Development & User Interface  
**Key Skills Demonstrated**: Web Development, Database Integration, Authentication, Frontend/Backend  
**Connection to Others**: Uses Student 1's schema, calls Student 2's queries, integrated with Student 4's reports

**Be Ready to Show**:
1. Registration form (screenshot or live demo)
2. Login page and authentication flow
3. Dashboard showing matched investors/startups
4. Code snippet of database connection
5. Password hashing implementation

---

## 💡 Demo Flow (30 seconds)

1. "Let me show the **registration page** → enter startup details → submit"
2. "Data is inserted into database using Student 2's INSERT query"
3. "Now **login** with email/password → session created"
4. "**Dashboard** loads → shows matched investors pulled from database"
5. "Click on a match → shows investor details → demonstrates real-time data retrieval"

---

**Confidence Tips**:
✓ Have the application running for live demo  
✓ Know your tech stack (language, framework, database driver)  
✓ Explain the flow: User → Frontend → Backend → Database → Response  
✓ If demo breaks, explain what *should* happen with screenshots  
✓ Use terms: session, authentication, prepared statement, connection pooling

