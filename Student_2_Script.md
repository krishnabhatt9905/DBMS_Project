# Student 2 – Backend Query & Data Management
## Presentation Script (2-3 minutes)

---

## 🎤 Opening (15 seconds)

"Good morning/afternoon. I'm [Your Name], and I handled the **Backend Query Development and Data Management** for our project. I worked on all SQL queries, stored procedures, and data operations that power the system."

---

## 📊 Main Presentation (2 minutes)

### 1. Core SQL Queries (30 seconds)

"I developed all the **core SQL queries** for the system:

- **Registration queries** – inserting new startups and investors into the database
- **Login queries** – validating user credentials with prepared statements to prevent SQL injection
- **Profile update queries** – allowing users to modify their information
- **Deletion queries** – with proper CASCADE handling to maintain referential integrity

Each query includes error handling and validation to ensure data consistency."

### 2. Search & Matchmaking Queries (45 seconds)

"The most complex part was creating **intelligent search queries**. For example:

- 'Find investors who fund AI startups with 1-5 crore budget' – this uses WHERE clauses with domain matching and investment range filtering
- 'Top 10 best matches for a startup' – uses JOIN operations across Startups, Investors, and Matches tables
- 'All startups in a specific domain that haven't been funded' – uses LEFT JOIN to find startups with no funding records

These queries use **multiple JOINs**, **GROUP BY** for aggregation, and **ORDER BY** for ranking matches by compatibility score."

### 3. Stored Procedures (30 seconds)

"I created **stored procedures** for frequently used operations:

- `RegisterStartup()` – takes all startup details as parameters and inserts them
- `FindMatches()` – calculates and returns top matches for a given startup_id
- `RecordFunding()` – updates funding records and startup status in one transaction

Stored procedures improve performance by reducing network overhead and allow us to reuse complex logic without rewriting queries."

### 4. Testing & Optimization (30 seconds)

"I thoroughly **tested all queries** with sample data:

- Inserted 20+ sample startups and 15+ investors
- Ran matchmaking queries and verified accuracy
- Used EXPLAIN to analyze query performance
- Added indexes on frequently searched columns (domain, investment_range) to speed up searches

I also handled edge cases like searching when no matches exist, ensuring the system returns meaningful messages."

---

## 🎯 Closing (15 seconds)

"My queries serve as the **bridge between the database and the application**. Student 3 calls my queries from the application layer, and Student 4 uses them for generating reports. I'm ready to demonstrate any specific query or explain the matchmaking logic. Thank you."

---

## 🔍 Potential Faculty Questions & Answers

### Q1: "Show me a complex query you wrote."

**Answer**: "Here's the matchmaking query:
```sql
SELECT i.name, i.investment_range, i.preferred_domains,
       CASE 
           WHEN i.preferred_domains LIKE CONCAT('%', s.domain, '%') 
           THEN 'High Match' 
           ELSE 'Partial Match' 
       END AS match_quality
FROM Investors i
CROSS JOIN Startups s
WHERE s.startup_id = 101
  AND i.investment_min <= s.funding_required 
  AND i.investment_max >= s.funding_required
ORDER BY match_quality DESC
LIMIT 10;
```
It finds the top 10 investors for a startup by checking domain compatibility and investment range."

### Q2: "What's the difference between JOIN and SUBQUERY?"

**Answer**: "JOIN combines data from multiple tables horizontally – all matched columns appear in the result. SUBQUERY is a query inside another query, often used in WHERE or FROM clauses. For our matchmaking, I used JOIN because it's more efficient when retrieving data from multiple tables simultaneously. Subqueries are better when you need filtered results from one table to use in another query."

### Q3: "What is a stored procedure and why did you use it?"

**Answer**: "A stored procedure is precompiled SQL code stored in the database. I used it because:
1. **Performance** – it's compiled once and reused, faster than sending queries each time
2. **Security** – we can grant execute permission without exposing table structure
3. **Reusability** – Student 3 can call `RegisterStartup()` without rewriting the INSERT logic
4. **Transaction control** – I can group multiple operations (like updating both Funding and Startups tables) in one atomic procedure."

### Q4: "How do you prevent SQL injection?"

**Answer**: "I used **prepared statements with parameterized queries**. Instead of concatenating user input directly into SQL:
```sql
-- Vulnerable:
SELECT * FROM Users WHERE email = '" + userInput + "'

-- Safe (parameterized):
SELECT * FROM Users WHERE email = ?
```
The database treats parameters as data, not executable code, preventing injection attacks."

### Q5: "How did you optimize query performance?"

**Answer**: "I used three main techniques:
1. **Indexing** – created indexes on frequently searched columns (domain, email, investment_range)
2. **EXPLAIN analysis** – checked query execution plans and optimized JOIN order
3. **Avoiding SELECT *** – only selecting needed columns reduces data transfer

For example, our matchmaking query went from 200ms to 50ms after adding an index on the domain column."

---

## 📋 Quick Reference Points

**Your Module**: SQL Queries & Data Operations  
**Key Skills Demonstrated**: SQL DML/DQL, JOINs, Stored Procedures, Query Optimization  
**Connection to Others**: Your queries are called by Student 3's application and power Student 4's reports

**Be Ready to Show**:
1. A complex JOIN query
2. One stored procedure
3. Sample data you inserted
4. EXPLAIN output showing optimization

---

## 💡 Demo Flow (if asked)

1. Show INSERT query → insert a sample startup
2. Show SELECT query → retrieve and display it
3. Show matchmaking query → demonstrate the algorithm
4. Show UPDATE query → modify the startup's funding requirement
5. Explain how Student 3's app calls these queries

---

**Confidence Tips**:
✓ Have 2-3 key queries memorized  
✓ Explain the "why" behind complex queries (not just "what")  
✓ Use terms: JOIN, WHERE, GROUP BY, ORDER BY, stored procedure, parameterized  
✓ If stuck, walk through a simple query step-by-step

