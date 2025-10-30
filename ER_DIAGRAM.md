# 📊 ER Diagram - Startup Funding & Investor Matchmaking System

## Entity-Relationship Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    STARTUP FUNDING SYSTEM - ER DIAGRAM                  │
└─────────────────────────────────────────────────────────────────────────┘

                          ┌──────────────┐
                          │   DOMAINS    │
                          │──────────────│
                          │ PK domain_id │
                          │    domain_name│
                          └──────┬───────┘
                                 │
                                 │ 1
                                 │
                                 │ N
                          ┌──────▼───────┐
         ┌────────────────┤   STARTUPS   │
         │                │──────────────│
         │                │ PK startup_id│
         │                │    name      │
         │                │    email     │◄────────────┐
         │                │    password  │             │
         │                │ FK domain_id │             │
         │                │    funding_req│            │
         │                │    description│            │
         │                │    founded_date│           │
         │                │    location  │             │
         │                │    website   │             │
         │                │    is_funded │             │
         │                └──────┬───────┘             │
         │                       │                     │
         │                       │ N                   │
         │                       │                     │
         │                       │ M                   │
         │                ┌──────▼───────┐            │
         │                │   FUNDING    │            │
         │                │──────────────│            │
         │                │ PK funding_id│            │
         │       ┌────────┤ FK investor_id│           │
         │       │        │ FK startup_id │           │
         │       │        │    amount    │            │
         │       │        │ funding_date │            │
         │       │        │ funding_round│            │
         │       │        │    notes     │            │
         │       │        └──────┬───────┘            │
         │       │               │                    │
         │       │ N             │                    │
         │       │               │                    │
         │       │ 1             │ N                  │
         │  ┌────▼─────────┐     │                    │
         │  │  INVESTORS   │     │                    │
         │  │──────────────│     │                    │
         │  │ PK investor_id│    │                    │
         │  │    name      │     │                    │
         │  │    email     │     │                    │
         │  │    password  │     │                    │
         │  │ investment_min│    │                    │
         │  │ investment_max│    │                    │
         │  │ preferred_domains│ │                    │
         │  │    phone     │     │                    │
         │  │    location  │     │                    │
         │  │ portfolio_size│    │                    │
         │  └────┬─────────┘     │                    │
         │       │               │                    │
         │       │ 1             │ M                  │
         │       │               │                    │
         │       │ N             │ N                  │
         │  ┌────▼───────────────▼────┐               │
         └─►│       MATCHES           │───────────────┘
            │─────────────────────────│
            │ PK match_id             │
            │ FK investor_id          │
            │ FK startup_id           │
            │    match_score          │
            │    match_reason         │
            │    is_contacted         │
            │    created_at           │
            └─────────────────────────┘
```

---

## 🔷 Entities and Attributes

### 1. **DOMAINS** (Lookup Table)
| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| domain_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| domain_name | VARCHAR(50) | UNIQUE, NOT NULL | Domain name (AI/ML, FinTech, etc.) |

**Purpose**: Stores different business domains for startups
**Sample Data**: AI/ML, FinTech, HealthTech, EdTech, E-Commerce, SaaS, CleanTech, FoodTech

---

### 2. **STARTUPS** (Main Entity)
| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| startup_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| name | VARCHAR(100) | NOT NULL | Startup name |
| email | VARCHAR(100) | UNIQUE, NOT NULL | Contact email |
| password_hash | VARCHAR(255) | NOT NULL | Hashed password |
| domain_id | INT | FK → DOMAINS, NOT NULL | Business domain |
| funding_required | DECIMAL(15,2) | NOT NULL, CHECK > 0 | Amount needed |
| description | TEXT | NULL | Startup description |
| founded_date | DATE | NULL | When started |
| location | VARCHAR(100) | NULL | City/location |
| website | VARCHAR(200) | NULL | Website URL |
| is_funded | BOOLEAN | DEFAULT FALSE | Funding status |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Registration date |

**Purpose**: Stores information about startups seeking funding

---

### 3. **INVESTORS** (Main Entity)
| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| investor_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| name | VARCHAR(100) | NOT NULL | Investor/firm name |
| email | VARCHAR(100) | UNIQUE, NOT NULL | Contact email |
| password_hash | VARCHAR(255) | NOT NULL | Hashed password |
| investment_min | DECIMAL(15,2) | NOT NULL, CHECK > 0 | Minimum investment |
| investment_max | DECIMAL(15,2) | NOT NULL, CHECK ≥ min | Maximum investment |
| preferred_domains | VARCHAR(255) | NULL | Comma-separated domain_ids |
| phone | VARCHAR(20) | NULL | Contact number |
| location | VARCHAR(100) | NULL | City/location |
| portfolio_size | INT | DEFAULT 0 | Number of funded startups |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Registration date |

**Purpose**: Stores information about investors looking for startups

---

### 4. **FUNDING** (Transaction Entity)
| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| funding_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| investor_id | INT | FK → INVESTORS, NOT NULL | Who invested |
| startup_id | INT | FK → STARTUPS, NOT NULL | Who received |
| amount | DECIMAL(15,2) | NOT NULL, CHECK > 0 | Investment amount |
| funding_date | DATE | NOT NULL | When invested |
| funding_round | VARCHAR(20) | DEFAULT 'Seed' | Round type |
| notes | TEXT | NULL | Additional notes |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation |

**Purpose**: Records actual funding transactions between investors and startups

---

### 5. **MATCHES** (Relationship Entity)
| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| match_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| investor_id | INT | FK → INVESTORS, NOT NULL | Matched investor |
| startup_id | INT | FK → STARTUPS, NOT NULL | Matched startup |
| match_score | INT | DEFAULT 0, CHECK 0-100 | Compatibility score |
| match_reason | VARCHAR(255) | NULL | Why they match |
| is_contacted | BOOLEAN | DEFAULT FALSE | Contact status |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Match creation |

**Unique Constraint**: UNIQUE(investor_id, startup_id) - One match per pair

**Purpose**: Stores potential matches between investors and startups

---

## 🔗 Relationships

### 1. **DOMAINS ──(1:N)──► STARTUPS**
- **Type**: One-to-Many
- **Cardinality**: One domain can have many startups
- **Foreign Key**: Startups.domain_id → Domains.domain_id
- **Constraint**: ON DELETE RESTRICT (can't delete domain if startups exist)
- **Example**: "AI/ML" domain has 5 startups

### 2. **INVESTORS ──(1:N)──► FUNDING**
- **Type**: One-to-Many
- **Cardinality**: One investor can fund many startups
- **Foreign Key**: Funding.investor_id → Investors.investor_id
- **Constraint**: ON DELETE CASCADE (delete funding if investor deleted)
- **Example**: "Accel Partners" funded 5 startups

### 3. **STARTUPS ──(1:N)──► FUNDING**
- **Type**: One-to-Many
- **Cardinality**: One startup can receive funding from many investors
- **Foreign Key**: Funding.startup_id → Startups.startup_id
- **Constraint**: ON DELETE CASCADE
- **Example**: "AI Insights" received funding from 2 investors

### 4. **INVESTORS ──(M:N)──► STARTUPS** (via FUNDING)
- **Type**: Many-to-Many
- **Implementation**: Through FUNDING table
- **Meaning**: Many investors can fund many startups
- **Business Rule**: Same investor can fund same startup multiple times (different rounds)

### 5. **INVESTORS ──(M:N)──► STARTUPS** (via MATCHES)
- **Type**: Many-to-Many
- **Implementation**: Through MATCHES table
- **Meaning**: Many investors can match with many startups
- **Business Rule**: Each pair can have only ONE match record
- **Unique Constraint**: UNIQUE(investor_id, startup_id)

---

## 🎯 Normalization

### **First Normal Form (1NF)**
✅ All attributes contain atomic values
✅ No repeating groups
✅ Each row is unique (primary keys)

### **Second Normal Form (2NF)**
✅ In 1NF
✅ No partial dependencies (all non-key attributes depend on entire primary key)
✅ Example: In FUNDING, both amount and funding_date depend on the full key (funding_id)

### **Third Normal Form (3NF)**
✅ In 2NF
✅ No transitive dependencies
✅ **Example**: Separated Domains into its own table instead of storing domain_name directly in Startups
  - Before: Startups(startup_id, name, **domain_name**) ← domain_name repeated for each startup
  - After: Startups(startup_id, name, **domain_id**) + Domains(domain_id, domain_name) ← no redundancy

---

## 🔒 Constraints & Data Integrity

### Primary Keys
- Every table has a single-column integer primary key with AUTO_INCREMENT
- Ensures each record is uniquely identifiable

### Foreign Keys
```sql
-- Startups → Domains
ALTER TABLE Startups 
    ADD CONSTRAINT fk_startup_domain 
    FOREIGN KEY (domain_id) REFERENCES Domains(domain_id)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- Funding → Investors
ALTER TABLE Funding 
    ADD CONSTRAINT fk_funding_investor 
    FOREIGN KEY (investor_id) REFERENCES Investors(investor_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Funding → Startups
ALTER TABLE Funding 
    ADD CONSTRAINT fk_funding_startup 
    FOREIGN KEY (startup_id) REFERENCES Startups(startup_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Matches → Investors
ALTER TABLE Matches 
    ADD CONSTRAINT fk_matches_investor 
    FOREIGN KEY (investor_id) REFERENCES Investors(investor_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Matches → Startups
ALTER TABLE Matches 
    ADD CONSTRAINT fk_matches_startup 
    FOREIGN KEY (startup_id) REFERENCES Startups(startup_id)
    ON DELETE CASCADE ON UPDATE CASCADE;
```

### Check Constraints
```sql
-- Ensure positive values
CHECK (funding_required > 0)
CHECK (amount > 0)
CHECK (investment_min > 0)

-- Ensure logical ranges
CHECK (investment_max >= investment_min)
CHECK (match_score BETWEEN 0 AND 100)
```

### Unique Constraints
```sql
-- Prevent duplicate emails
UNIQUE (email) in Startups
UNIQUE (email) in Investors

-- Prevent duplicate domains
UNIQUE (domain_name) in Domains

-- Prevent duplicate matches
UNIQUE (investor_id, startup_id) in Matches
```

### NOT NULL Constraints
- All primary keys
- All foreign keys
- Critical fields (name, email, password_hash)
- Business-critical fields (funding_required, amount)

---

## 📈 Cardinality Summary

| Relationship | Type | From | To |
|--------------|------|------|-----|
| Domain → Startup | 1:N | 1 domain | N startups |
| Investor → Funding | 1:N | 1 investor | N funding records |
| Startup → Funding | 1:N | 1 startup | N funding records |
| Investor ↔ Startup (via Funding) | M:N | N investors | N startups |
| Investor ↔ Startup (via Matches) | M:N | N investors | N startups |

---

## 🎨 ER Diagram Symbols Legend

```
┌──────────┐
│  Entity  │  = Strong Entity (has primary key)
└──────────┘

──────────── = Relationship Line

─────►      = One-to-Many (1:N)

◄────►      = Many-to-Many (M:N)

PK          = Primary Key
FK          = Foreign Key
```

---

## 💡 Design Decisions

### Why Separate DOMAINS Table?
**Before**: Store domain name directly in Startups
- ❌ Redundancy: "AI/ML" stored 100 times if 100 startups
- ❌ Inconsistency: Could have "AI", "AI/ML", "Artificial Intelligence"
- ❌ Hard to update: Need to update all startups to change domain name

**After**: Separate Domains table with FK
- ✅ No redundancy: "AI/ML" stored once
- ✅ Consistency: All startups reference same domain_id
- ✅ Easy to update: Change domain name in one place

### Why FUNDING and MATCHES Are Separate?
**FUNDING**: Actual transactions (money transferred)
- Represents real-world events
- Immutable history
- Legal/financial record

**MATCHES**: Potential connections (recommendations)
- Represents possibilities
- Can be updated/deleted
- System-generated suggestions

---

## 🔍 Sample Queries Using ER Diagram

### Query 1: Get all startups in a domain
```sql
SELECT s.name, s.funding_required
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
WHERE d.domain_name = 'AI/ML';
```

### Query 2: Find who funded whom
```sql
SELECT i.name AS Investor, s.name AS Startup, f.amount
FROM Funding f
JOIN Investors i ON f.investor_id = i.investor_id
JOIN Startups s ON f.startup_id = s.startup_id;
```

### Query 3: Matchmaking (leverages domain relationship)
```sql
SELECT s.name, i.name
FROM Startups s
JOIN Domains d ON s.domain_id = d.domain_id
CROSS JOIN Investors i
WHERE FIND_IN_SET(s.domain_id, i.preferred_domains) > 0
  AND i.investment_min <= s.funding_required
  AND i.investment_max >= s.funding_required;
```

---

## ✅ ER Diagram Validation Checklist

- [x] All entities have primary keys
- [x] All relationships properly defined with foreign keys
- [x] Cardinality correctly specified
- [x] No redundancy (normalized to 3NF)
- [x] All constraints documented
- [x] Referential integrity maintained
- [x] Business rules captured
- [x] Sample data validates design

---

**Student 1 (Database Designer)** - Use this document to explain your schema design during presentation!

