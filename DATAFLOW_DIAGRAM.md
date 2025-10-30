# 🔄 Data Flow Diagram - Startup Funding & Investor Matchmaking System

## System Overview

This document shows how data flows through the Startup Funding System, from user input to database storage and back.

---

## 📊 Level 0 DFD (Context Diagram)

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CONTEXT DIAGRAM                              │
└─────────────────────────────────────────────────────────────────────┘

                    Registration Data
              ┌─────────────────────────────┐
              │                             │
              ▼                             │
    ┌──────────────────┐          ┌────────┴────────┐
    │     STARTUP      │          │    INVESTOR     │
    │     (Actor)      │          │     (Actor)     │
    └────────┬─────────┘          └────────┬────────┘
             │                              │
             │ Login Credentials            │ Login Credentials
             │ Profile Updates              │ Profile Updates
             │                              │
             ▼                              ▼
      ┌──────────────────────────────────────────────┐
      │                                              │
      │      STARTUP FUNDING & MATCHMAKING          │
      │              SYSTEM                         │
      │         (Central Process)                   │
      │                                              │
      └──────┬────────────────────────────────┬─────┘
             │                                │
             │ Matched Investors              │ Matched Startups
             │ Funding History                │ Portfolio Data
             │ Dashboard Data                 │ Dashboard Data
             │                                │
             ▼                                ▼
    ┌──────────────────┐          ┌─────────────────┐
    │  STARTUP USER    │          │ INVESTOR USER   │
    │   (Outputs)      │          │   (Outputs)     │
    └──────────────────┘          └─────────────────┘

             │                                │
             │ Reports                        │ Reports
             │ Analytics                      │ Analytics
             │                                │
             └────────────┬───────────────────┘
                          ▼
                 ┌─────────────────┐
                 │      ADMIN      │
                 │  (Report User)  │
                 └─────────────────┘
```

---

## 📊 Level 1 DFD (System Components)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    LEVEL 1 DATA FLOW DIAGRAM                        │
└─────────────────────────────────────────────────────────────────────┘


   STARTUP                                              INVESTOR
     │                                                      │
     │ Registration                                         │ Registration
     │ Data                                                 │ Data
     │                                                      │
     ▼                                                      ▼
┌─────────────────┐                              ┌─────────────────┐
│   Process 1.1   │                              │   Process 1.2   │
│    REGISTER     │                              │    REGISTER     │
│    STARTUP      │                              │    INVESTOR     │
└────────┬────────┘                              └────────┬────────┘
         │                                                │
         │ Startup Data                                   │ Investor Data
         │                                                │
         ▼                                                ▼
    ┌────────────────────────────────────────────────────────┐
    │              D1: MYSQL DATABASE                        │
    │  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
    │  │ Startups │  │Investors │  │ Domains  │           │
    │  └──────────┘  └──────────┘  └──────────┘           │
    │  ┌──────────┐  ┌──────────┐                          │
    │  │ Funding  │  │ Matches  │                          │
    │  └──────────┘  └──────────┘                          │
    └────────┬───────────────────┬────────────────┬────────┘
             │                   │                │
             │ Credentials       │                │ Match Data
             │                   │                │
             ▼                   │                ▼
    ┌─────────────────┐          │       ┌─────────────────┐
    │   Process 2.1   │          │       │   Process 3.0   │
    │ AUTHENTICATE    │          │       │   MATCHMAKING   │
    │    & LOGIN      │          │       │   ALGORITHM     │
    └────────┬────────┘          │       └────────┬────────┘
             │                   │                │
             │ Session Token     │                │ Matched Results
             │                   │                │
             ▼                   ▼                ▼
    ┌──────────────────────────────────────────────────┐
    │           Process 2.2                            │
    │        GENERATE DASHBOARD                        │
    │  (Retrieve and Format Data for Display)         │
    └────────┬────────────────────────┬────────────────┘
             │                        │
             │ Dashboard Data         │ Dashboard Data
             │                        │
             ▼                        ▼
     STARTUP USER               INVESTOR USER


                     │ Query
                     ▼
            ┌─────────────────┐
            │   Process 4.0   │
            │    GENERATE     │
            │    REPORTS      │
            └────────┬────────┘
                     │
                     │ Report Data
                     ▼
                   ADMIN
```

---

## 🔄 Level 2 DFD (Detailed Processes)

### Process 1.1: Startup Registration

```
STARTUP USER
     │
     │ (name, email, password,
     │  domain, funding_required,
     │  location, description)
     │
     ▼
┌─────────────────────────────────┐
│    1.1 REGISTER STARTUP         │
│                                 │
│  ┌──────────────────────────┐  │
│  │ 1.1.1 Validate Input     │  │
│  │ - Check required fields  │  │
│  │ - Validate email format  │  │
│  │ - Check domain exists    │  │
│  └──────────┬───────────────┘  │
│             │                   │
│             ▼                   │
│  ┌──────────────────────────┐  │
│  │ 1.1.2 Hash Password      │  │
│  │ - Use bcrypt             │  │
│  │ - Generate salt          │  │
│  └──────────┬───────────────┘  │
│             │                   │
│             ▼                   │
│  ┌──────────────────────────┐  │
│  │ 1.1.3 Check Duplicate    │  │────► Query D1: Startups
│  │ - Query by email         │  │◄──── (email exists?)
│  └──────────┬───────────────┘  │
│             │                   │
│             ▼                   │
│  ┌──────────────────────────┐  │
│  │ 1.1.4 Insert Record      │  │
│  │ - INSERT INTO Startups   │  │────► D1: Startups Table
│  │ - Get startup_id         │  │
│  └──────────┬───────────────┘  │
└─────────────┼───────────────────┘
              │
              ▼
      Success Message
              │
              ▼
        STARTUP USER
```

### Process 2.1: Authentication & Login

```
USER (Startup/Investor)
     │
     │ (email, password)
     │
     ▼
┌─────────────────────────────────┐
│   2.1 AUTHENTICATE & LOGIN      │
│                                 │
│  ┌──────────────────────────┐  │
│  │ 2.1.1 Retrieve User      │  │
│  │ - Query by email         │  │────► D1: Startups/Investors
│  └──────────┬───────────────┘  │◄──── (user record)
│             │                   │
│             ▼                   │
│  ┌──────────────────────────┐  │
│  │ 2.1.2 Verify Password    │  │
│  │ - Compare hash           │  │
│  │ - Use bcrypt.checkpw     │  │
│  └──────────┬───────────────┘  │
│             │                   │
│             ▼                   │
│  ┌──────────────────────────┐  │
│  │ 2.1.3 Create Session     │  │
│  │ - Generate session_id    │  │
│  │ - Store user_id, role    │  │
│  │ - Set expiry (24 hours)  │  │
│  └──────────┬───────────────┘  │
└─────────────┼───────────────────┘
              │
              │ (session_token,
              │  user_id, user_type)
              ▼
            USER
```

### Process 3.0: Matchmaking Algorithm

```
STARTUP/INVESTOR
     │
     │ Request: Show Matches
     │
     ▼
┌─────────────────────────────────────────┐
│   3.0 MATCHMAKING ALGORITHM             │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │ 3.1 Get User Profile             │  │────► D1: Startups/Investors
│  │ - Retrieve startup/investor data │  │◄──── (profile data)
│  └──────────┬───────────────────────┘  │
│             │                           │
│             ▼                           │
│  ┌──────────────────────────────────┐  │
│  │ 3.2 Execute Matchmaking Query    │  │
│  │                                  │  │
│  │ For Startup:                     │  │
│  │ - Find investors where           │  │
│  │   investment_min <= funding_req  │  │────► D1: Investors
│  │   AND investment_max >= funding  │  │◄──── (matching investors)
│  │                                  │  │
│  │ For Investor:                    │  │
│  │ - Find startups where            │  │
│  │   funding_req BETWEEN min & max  │  │────► D1: Startups
│  │   AND domain matches preferences │  │◄──── (matching startups)
│  └──────────┬───────────────────────┘  │
│             │                           │
│             ▼                           │
│  ┌──────────────────────────────────┐  │
│  │ 3.3 Calculate Match Scores       │  │
│  │ - Domain match: +100 points      │  │
│  │ - Range match: +50 points        │  │
│  │ - Location match: +10 points     │  │
│  └──────────┬───────────────────────┘  │
│             │                           │
│             ▼                           │
│  ┌──────────────────────────────────┐  │
│  │ 3.4 Sort by Score                │  │
│  │ - ORDER BY match_score DESC      │  │
│  │ - LIMIT 10                       │  │
│  └──────────┬───────────────────────┘  │
│             │                           │
│             ▼                           │
│  ┌──────────────────────────────────┐  │
│  │ 3.5 Store Matches (Optional)     │  │────► D1: Matches Table
│  │ - INSERT INTO Matches            │  │
│  └──────────┬───────────────────────┘  │
└─────────────┼───────────────────────────┘
              │
              │ (matched_results with scores)
              ▼
     STARTUP/INVESTOR DASHBOARD
```

### Process 2.2: Generate Dashboard

```
USER (with session_token)
     │
     │ Request: Dashboard
     │
     ▼
┌────────────────────────────────────────────┐
│   2.2 GENERATE DASHBOARD                   │
│                                            │
│  ┌─────────────────────────────────────┐  │
│  │ 2.2.1 Validate Session              │  │
│  │ - Check session_token               │  │
│  │ - Verify not expired                │  │
│  └──────────┬──────────────────────────┘  │
│             │                              │
│             ▼                              │
│  ┌─────────────────────────────────────┐  │
│  │ 2.2.2 Get Profile Data              │  │────► D1: Startups/Investors
│  │ - SELECT * WHERE user_id = ?        │  │◄──── (profile info)
│  └──────────┬──────────────────────────┘  │
│             │                              │
│             ▼                              │
│  ┌─────────────────────────────────────┐  │
│  │ 2.2.3 Get Matched Entities          │  │
│  │ - Call Process 3.0 (Matchmaking)    │  │────► Process 3.0
│  │ - Retrieve top 10 matches           │  │◄──── (match results)
│  └──────────┬──────────────────────────┘  │
│             │                              │
│             ▼                              │
│  ┌─────────────────────────────────────┐  │
│  │ 2.2.4 Get Funding History           │  │
│  │ For Startup:                         │  │
│  │ - SELECT FROM Funding               │  │────► D1: Funding
│  │   WHERE startup_id = ?              │  │◄──── (funding records)
│  │                                     │  │
│  │ For Investor:                        │  │
│  │ - SELECT FROM Funding               │  │────► D1: Funding
│  │   WHERE investor_id = ?             │  │◄──── (portfolio)
│  └──────────┬──────────────────────────┘  │
│             │                              │
│             ▼                              │
│  ┌─────────────────────────────────────┐  │
│  │ 2.2.5 Calculate Statistics          │  │
│  │ - Total funding received/invested    │  │
│  │ - Number of matches                  │  │
│  │ - Funding percentage                 │  │
│  └──────────┬──────────────────────────┘  │
│             │                              │
│             ▼                              │
│  ┌─────────────────────────────────────┐  │
│  │ 2.2.6 Format for Display            │  │
│  │ - Create JSON/HTML data             │  │
│  │ - Apply business logic              │  │
│  └──────────┬──────────────────────────┘  │
└─────────────┼──────────────────────────────┘
              │
              │ (dashboard_data)
              ▼
         HTML Template
              │
              ▼
           BROWSER
```

### Process 4.0: Generate Reports

```
ADMIN
     │
     │ Request: Report Type
     │
     ▼
┌─────────────────────────────────────────┐
│   4.0 GENERATE REPORTS                  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │ 4.1 Select Report Type           │  │
│  │ - Top Investors                  │  │
│  │ - Domain Statistics              │  │
│  │ - Monthly Trends                 │  │
│  │ - Funded Startups                │  │
│  └──────────┬───────────────────────┘  │
│             │                           │
│             ▼                           │
│  ┌──────────────────────────────────┐  │
│  │ 4.2 Execute Report Query         │  │
│  │ - Complex SQL with JOINs         │  │────► D1: Multiple Tables
│  │ - GROUP BY for aggregation       │  │◄──── (report data)
│  │ - ORDER BY for sorting           │  │
│  └──────────┬───────────────────────┘  │
│             │                           │
│             ▼                           │
│  ┌──────────────────────────────────┐  │
│  │ 4.3 Format Results               │  │
│  │ - Calculate totals/averages      │  │
│  │ - Format currency                │  │
│  │ - Create visualization data      │  │
│  └──────────┬───────────────────────┘  │
│             │                           │
│             ▼                           │
│  ┌──────────────────────────────────┐  │
│  │ 4.4 Export Report                │  │
│  │ - Generate PDF/CSV/Excel         │  │
│  │ - Create charts/graphs           │  │
│  └──────────┬───────────────────────┘  │
└─────────────┼───────────────────────────┘
              │
              │ (report_file)
              ▼
            ADMIN
```

---

## 💾 Data Stores

### D1: MySQL Database

```
┌───────────────────────────────────────────┐
│        D1: MYSQL DATABASE                 │
├───────────────────────────────────────────┤
│                                           │
│  📊 Startups Table                        │
│  - startup_id, name, email, etc.         │
│  - Stores startup information            │
│                                           │
│  💰 Investors Table                       │
│  - investor_id, name, email, etc.        │
│  - Stores investor information           │
│                                           │
│  💵 Funding Table                         │
│  - funding_id, investor_id, startup_id   │
│  - Stores actual transactions            │
│                                           │
│  🎯 Matches Table                         │
│  - match_id, investor_id, startup_id     │
│  - Stores potential matches              │
│                                           │
│  🏷️  Domains Table                        │
│  - domain_id, domain_name                │
│  - Lookup table for domains              │
│                                           │
└───────────────────────────────────────────┘
```

---

## 🔄 Complete Data Flow Examples

### Example 1: Startup Registration Flow

```
1. User enters registration form
   ↓
2. Browser sends POST request with form data
   ↓
3. Flask app receives data
   ↓
4. Validates input (required fields, email format)
   ↓
5. Hashes password using bcrypt
   ↓
6. Checks if email already exists (SELECT query)
   ↓
7. If unique, INSERT INTO Startups
   ↓
8. Database returns new startup_id
   ↓
9. Flask creates success message
   ↓
10. Renders login page with flash message
    ↓
11. User sees "Registration successful!"
```

### Example 2: Matchmaking Flow

```
1. Startup logs in and views dashboard
   ↓
2. Flask verifies session token
   ↓
3. Retrieves startup profile from Startups table
   ↓
4. Executes matchmaking query:
   SELECT * FROM Investors
   WHERE investment_min <= startup.funding_required
     AND investment_max >= startup.funding_required
   ↓
5. Calculates match scores:
   - Domain match? +100 points
   - Range match? +50 points
   ↓
6. Sorts by score DESC, LIMIT 10
   ↓
7. Formats results as JSON/dict
   ↓
8. Passes to template engine
   ↓
9. Renders HTML dashboard
   ↓
10. Browser displays matched investors in table
```

### Example 3: Report Generation Flow

```
1. Admin requests "Top Investors" report
   ↓
2. Flask executes complex query:
   SELECT i.name, COUNT(*), SUM(f.amount)
   FROM Investors i
   JOIN Funding f ON i.investor_id = f.investor_id
   GROUP BY i.investor_id
   ORDER BY SUM(f.amount) DESC
   ↓
3. Database returns aggregated results
   ↓
4. Flask calculates totals and percentages
   ↓
5. Formats as table with currency symbols
   ↓
6. Optionally exports to CSV/PDF
   ↓
7. Renders report page or downloads file
   ↓
8. Admin views/downloads report
```

---

## 🎯 Key Data Flows Summary

| Source | Process | Destination | Data |
|--------|---------|-------------|------|
| Startup User | Register | Database | Profile data |
| Investor User | Register | Database | Profile data |
| User | Login | System | Credentials → Session |
| Database | Matchmaking | User | Matched entities |
| User | Update Profile | Database | Modified fields |
| System | Funding Record | Database | Transaction data |
| Database | Reports | Admin | Aggregated statistics |
| Database | Dashboard | User | Profile + Matches |

---

## 🔒 Security Considerations in Data Flow

### Password Flow
```
User Password → bcrypt.hashpw() → Hashed Password → Database
                    ↑
                (never stored in plain text)
```

### Session Flow
```
Login → Generate Token → Store in Session → Cookie to Browser
                                              ↓
Every Request → Verify Token → Allow/Deny Access
```

### SQL Injection Prevention
```
User Input → Parameterized Query → MySQL Prepared Statement
              (using ? placeholders)
```

---

## ✅ Data Flow Validation Points

- [ ] All user inputs validated before processing
- [ ] Passwords hashed before storage
- [ ] Session tokens verified on every request
- [ ] SQL queries use parameterized statements
- [ ] Foreign key constraints enforce relationships
- [ ] Transactions ensure data consistency
- [ ] Error handling at each step
- [ ] Logging for audit trails

---

**Student 3 (Application Developer)** - Use this document to explain how data flows through your application during presentation!

