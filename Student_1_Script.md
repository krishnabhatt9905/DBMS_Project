# Student 1 – Database Designer (Schema & ERD)
## Presentation Script (2-3 minutes)

---

## 🎤 Opening (15 seconds)

"Good morning/afternoon. My name is [Your Name], and I was responsible for the **Database Design and Schema Creation** for our Startup Funding & Investor Matchmaking System."

---

## 📊 Main Presentation (2 minutes)

### 1. ER Diagram Design (30 seconds)

"I started by designing the **ER Diagram** for our system. I identified four main entities:

- **Startups** – with attributes like startup_id, name, domain, funding_required
- **Investors** – with investor_id, name, investment_range, preferred_domains
- **Funding** – recording actual investments made
- **Matches** – storing potential investor-startup pairings

I mapped the relationships between these entities, primarily **one-to-many** relationships like one investor can fund multiple startups."

### 2. Database Schema (30 seconds)

"Next, I created the **complete database schema** in SQL. I defined:

- **Primary keys** for unique identification of each record
- **Foreign keys** to establish relationships between tables
- Proper **data types** for each attribute (VARCHAR, INT, DATE, DECIMAL)
- **Constraints** like NOT NULL for mandatory fields and UNIQUE for email addresses"

### 3. Normalization (30 seconds)

"To ensure data integrity, I performed **normalization up to 3NF**:

- Eliminated duplicate data by separating domains into a lookup table
- Removed partial dependencies
- Ensured each non-key attribute depends only on the primary key

This reduced redundancy and improved database performance."

### 4. Data Integrity & Constraints (30 seconds)

"I implemented several **constraints for data integrity**:

- **NOT NULL** on critical fields like names and IDs
- **UNIQUE** constraint on email addresses
- **Foreign key constraints** with cascading rules – so if an investor is deleted, their related funding records are handled properly
- **CHECK constraints** to ensure investment amounts are positive

This ensures our database maintains consistent and accurate data."

---

## 🎯 Closing (15 seconds)

"My schema serves as the **foundation** for the entire system. The other team members built their queries, application logic, and reports on top of this structure. I'm happy to show the ER diagram and explain any specific table design. Thank you."

---

## 🔍 Potential Faculty Questions & Answers

### Q1: "Why did you normalize to 3NF? Why not higher?"

**Answer**: "3NF provides a good balance between data integrity and query performance. Higher normal forms like BCNF can make queries more complex. For our project scale, 3NF eliminates most redundancies while keeping queries simple."

### Q2: "What's the difference between primary key and foreign key?"

**Answer**: "Primary key uniquely identifies each record in a table – like startup_id in the Startups table. Foreign key is a field that references the primary key of another table – like investor_id in the Funding table references the investor_id in the Investors table. This creates relationships between tables."

### Q3: "Show me one table structure from your schema."

**Answer**: "Here's the Startups table:
```sql
CREATE TABLE Startups (
    startup_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    domain VARCHAR(50) NOT NULL,
    funding_required DECIMAL(15,2) NOT NULL CHECK (funding_required > 0),
    email VARCHAR(100) UNIQUE NOT NULL,
    founded_date DATE,
    description TEXT
);
```
It has a primary key, NOT NULL constraints on critical fields, UNIQUE for email, and CHECK to ensure funding is positive."

### Q4: "What challenges did you face in schema design?"

**Answer**: "The main challenge was deciding how to handle the many-to-many relationship between startups and investors (one startup can have multiple investors, one investor can fund multiple startups). I resolved this by creating a junction table called 'Funding' that stores each investment transaction separately with foreign keys to both tables."

### Q5: "How does your schema support the matchmaking feature?"

**Answer**: "I created a separate 'Matches' table that stores potential matches between startups and investors. It includes a match_score field calculated based on domain compatibility and investment range. This allows the application layer to query and rank the best matches efficiently."

---

## 📋 Quick Reference Points

**Your Module**: Database Schema & ER Diagram  
**Key Skills Demonstrated**: Database Design, Normalization, SQL DDL  
**Connection to Others**: Your schema is used by Student 2 for queries, Student 3 for application, Student 4 for reports

**Be Ready to Show**:
1. ER Diagram (on paper or screen)
2. CREATE TABLE statements
3. Explanation of at least one relationship
4. Normalization example (before/after)

---

**Confidence Tips**:
✓ Speak slowly and clearly  
✓ Point to your ER diagram while explaining  
✓ Use technical terms confidently (primary key, foreign key, normalization)  
✓ If stuck, relate back to "data integrity" and "reducing redundancy"

