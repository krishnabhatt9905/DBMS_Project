# DBMS Project: Startup Funding & Investor Matchmaking System
## Task Division (4 Students)

---

## 👤 Student 1 – Database Designer (Schema & ERD)

### Primary Responsibilities:
1. **ER Diagram Design**
   - Designed the complete ER Diagram for the system
   - Identified entities: Startups, Investors, Funding, Matches
   - Defined attributes for each entity

2. **Database Schema Creation**
   - Created all tables with proper data types
   - Defined primary keys for each table
   - Established foreign key relationships

3. **Normalization**
   - Implemented normalization (1NF, 2NF, 3NF)
   - Eliminated data redundancy
   - Ensured optimal database structure

4. **Data Integrity**
   - Applied constraints: NOT NULL, UNIQUE, CHECK
   - Defined foreign key constraints
   - Set up cascading rules (ON DELETE, ON UPDATE)

5. **Relationship Mapping**
   - Implemented One-to-Many relationships (Investor → Investments)
   - Created junction tables for Many-to-Many relationships
   - Documented all relationships

### Deliverables:
- ER Diagram (visual representation)
- Database schema SQL file
- Normalization documentation
- Data dictionary

---

## 👤 Student 2 – Backend Query & Data Management

### Primary Responsibilities:
1. **Core SQL Queries**
   - Wrote queries for startup registration
   - Implemented investor registration queries
   - Created funding match queries

2. **Search & Filter Queries**
   - Advanced search: "Find investors funding AI startups"
   - Filter by domain, investment range, location
   - Complex JOIN queries for matchmaking

3. **Stored Procedures & Functions**
   - Created procedures for repeated operations
   - Implemented functions for calculations (ROI, funding percentage)
   - Optimized query performance

4. **Data Operations**
   - INSERT statements for all entities
   - UPDATE queries for profile modifications
   - DELETE operations with proper constraints

5. **Testing & Validation**
   - Ran test queries with sample data
   - Verified data accuracy and consistency
   - Performance testing for complex queries

### Deliverables:
- SQL query file with all operations
- Stored procedures documentation
- Test cases and results
- Query optimization report

---

## 👤 Student 3 – Application & User Module

### Primary Responsibilities:
1. **User Registration Modules**
   - Designed startup registration form
   - Created investor registration interface
   - Validated user inputs

2. **Authentication System**
   - Implemented login/logout functionality
   - Password encryption and storage
   - Session management using database

3. **Database Connectivity**
   - Connected application with database
   - Real-time data retrieval and display
   - Error handling for database operations

4. **Matchmaking Logic**
   - Developed algorithm for investor-startup matching
   - Based on domain, investment range, location
   - Ranking system for best matches

5. **User Interface**
   - Created user-friendly forms
   - Dashboard for startups and investors
   - Profile management pages

### Deliverables:
- Application code (frontend + backend)
- User interface screenshots
- Matchmaking algorithm documentation
- User manual

---

## 👤 Student 4 – Reporting & Presentation

### Primary Responsibilities:
1. **Report Generation**
   - Query: List of all funded startups
   - Query: Top investors by investment amount
   - Query: Domain-wise funding statistics
   - Query: Monthly funding trends

2. **Dashboard Creation**
   - Sample dashboards from query results
   - Tables displaying key metrics
   - Graphs/charts for visualization

3. **Project Documentation**
   - Advantages of the system
   - Limitations and challenges faced
   - Future scope and enhancements
   - Technical documentation

4. **Presentation Preparation**
   - Created PowerPoint/presentation slides
   - Prepared demo flow
   - Documented all features

5. **Integration & Testing**
   - Coordinated final integration of all modules
   - End-to-end testing
   - Bug fixes and final polishing

### Deliverables:
- Report generation queries
- Dashboard samples (Excel/visualization tool)
- Project documentation (PDF)
- Presentation slides
- Demo video (optional)

---

## 🔗 Module Dependencies

```
Student 1 (Schema) → Student 2 (Queries) → Student 3 (Application) → Student 4 (Reports)
                           ↓
                   All modules feed into
                           ↓
                  Student 4 (Integration)
```

## ✅ Evaluation Points

Each student can independently explain:
- **What** they built (their specific module)
- **How** they implemented it (technical details)
- **Why** their decisions were made (justification)
- **Challenges** faced and solutions applied
- **How** their module connects with others

---

**Note**: All students should have basic understanding of the entire system, but deep expertise in their assigned module.

