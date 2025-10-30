"""
============================================
DBMS Project: Seed Data Script
Automatically populates database with sample data
Works with both MySQL and PostgreSQL
============================================
"""

import bcrypt
import os
from datetime import datetime

# Import both database connectors
try:
    import mysql.connector
    MYSQL_AVAILABLE = True
except ImportError:
    MYSQL_AVAILABLE = False

try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
    POSTGRESQL_AVAILABLE = True
except ImportError:
    POSTGRESQL_AVAILABLE = False


def hash_password(password):
    """Hash password using bcrypt"""
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed.decode('utf-8')


def get_db_connection():
    """Create and return database connection (auto-detects MySQL or PostgreSQL)"""
    DATABASE_URL = os.environ.get('DATABASE_URL')
    
    try:
        if DATABASE_URL:
            # PostgreSQL connection for Render
            connection = psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)
            return connection, 'postgresql'
        else:
            # MySQL connection for local development
            DB_CONFIG = {
                'host': 'localhost',
                'user': 'root',
                'password': '',
                'database': 'funding_system'
            }
            connection = mysql.connector.connect(**DB_CONFIG)
            return connection, 'mysql'
    except Exception as e:
        print(f"Database connection error: {e}")
        return None, None


def check_if_seeded(conn, db_type):
    """Check if database already has seed data"""
    try:
        if db_type == 'postgresql':
            cursor = conn.cursor()
        else:
            cursor = conn.cursor(dictionary=True)
        
        cursor.execute("SELECT COUNT(*) as count FROM Domains")
        result = cursor.fetchone()
        count = result['count'] if db_type == 'mysql' else result['count']
        cursor.close()
        
        return count > 0
    except Exception as e:
        print(f"Error checking seed status: {e}")
        return False


def seed_database():
    """Seed the database with sample data"""
    conn, db_type = get_db_connection()
    
    if not conn:
        print("❌ Could not connect to database")
        return False
    
    print(f"✅ Connected to {db_type.upper()} database")
    
    # Check if already seeded
    if check_if_seeded(conn, db_type):
        print("ℹ️  Database already contains data. Skipping seed.")
        conn.close()
        return True
    
    print("🌱 Seeding database with sample data...")
    
    try:
        cursor = conn.cursor()
        
        # 1. Insert Domains
        print("  → Inserting domains...")
        domains = [
            'AI/ML', 'FinTech', 'HealthTech', 'EdTech', 
            'E-Commerce', 'SaaS', 'CleanTech', 'FoodTech'
        ]
        
        for domain in domains:
            cursor.execute(
                "INSERT INTO Domains (domain_name) VALUES (%s)",
                (domain,)
            )
        
        # Commit domains before inserting startups (foreign key dependency)
        conn.commit()
        
        # 2. Insert Sample Startups
        print("  → Inserting startups...")
        startups = [
            ('AI Insights', 'contact@aiinsights.com', 'password123', 1, 5000000.00, 
             'AI-powered business analytics platform', '2024-01-15', 'Bangalore', 'https://aiinsights.com'),
            ('FinFlow', 'hello@finflow.io', 'password123', 2, 3000000.00, 
             'Digital payment solutions for SMEs', '2023-08-20', 'Mumbai', 'https://finflow.io'),
            ('MediCare AI', 'info@medicareai.com', 'password123', 3, 8000000.00, 
             'AI-driven diagnostic tools', '2024-03-10', 'Hyderabad', 'https://medicareai.com'),
            ('LearnHub', 'team@learnhub.edu', 'password123', 4, 2000000.00, 
             'Personalized learning platform', '2023-11-05', 'Delhi', 'https://learnhub.edu'),
            ('ShopEasy', 'support@shopeasy.in', 'password123', 5, 4000000.00, 
             'Social commerce platform', '2024-02-28', 'Pune', 'https://shopeasy.in'),
            ('CloudSync', 'hello@cloudsync.io', 'password123', 6, 6000000.00, 
             'Enterprise cloud storage solution', '2024-04-10', 'Bangalore', 'https://cloudsync.io'),
            ('GreenEnergy', 'info@greenenergy.com', 'password123', 7, 10000000.00, 
             'Renewable energy management platform', '2023-12-01', 'Pune', 'https://greenenergy.com'),
            ('FoodieHub', 'contact@foodiehub.in', 'password123', 8, 3500000.00, 
             'Cloud kitchen and food delivery tech', '2024-05-20', 'Mumbai', 'https://foodiehub.in'),
        ]
        
        for startup in startups:
            data = list(startup)
            data[2] = hash_password(data[2])  # Hash the password
            cursor.execute(
                """INSERT INTO Startups 
                (name, email, password_hash, domain_id, funding_required, 
                 description, founded_date, location, website)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)""",
                tuple(data)
            )
        
        # Commit startups before inserting investors
        conn.commit()
        
        # 3. Insert Sample Investors
        print("  → Inserting investors...")
        investors = [
            ('Accel Partners', 'invest@accel.com', 'password123', 2000000.00, 10000000.00, 
             '1,2,5', '+91-9876543210', 'Bangalore'),
            ('Sequoia India', 'deals@sequoia.in', 'password123', 5000000.00, 20000000.00, 
             '1,3,6', '+91-9876543211', 'Mumbai'),
            ('Tiger Global', 'info@tigerglobal.com', 'password123', 3000000.00, 15000000.00, 
             '2,5,8', '+91-9876543212', 'Bangalore'),
            ('Kalaari Capital', 'hello@kalaari.com', 'password123', 1000000.00, 5000000.00, 
             '1,4', '+91-9876543213', 'Bangalore'),
            ('Blume Ventures', 'contact@blume.vc', 'password123', 1500000.00, 8000000.00, 
             '3,4,5', '+91-9876543214', 'Mumbai'),
            ('Nexus Venture', 'invest@nexus.com', 'password123', 4000000.00, 12000000.00, 
             '6,7', '+91-9876543215', 'Delhi'),
            ('Matrix Partners', 'deals@matrix.in', 'password123', 2500000.00, 9000000.00, 
             '1,2,3', '+91-9876543216', 'Bangalore'),
        ]
        
        for investor in investors:
            data = list(investor)
            data[2] = hash_password(data[2])  # Hash the password
            cursor.execute(
                """INSERT INTO Investors 
                (name, email, password_hash, investment_min, investment_max, 
                 preferred_domains, phone, location)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""",
                tuple(data)
            )
        
        # Commit investors before inserting funding records
        conn.commit()
        
        # 4. Insert Sample Funding Records
        print("  → Inserting funding records...")
        funding = [
            (1, 1, 5000000.00, '2024-06-15', 'Seed', 'Impressed by AI capabilities'),
            (2, 3, 8000000.00, '2024-07-20', 'Series A', 'Strong healthcare market potential'),
            (3, 2, 3000000.00, '2024-05-10', 'Seed', 'Innovative fintech solution'),
            (4, 4, 2000000.00, '2024-08-01', 'Seed', 'EdTech space is growing'),
            (5, 5, 4000000.00, '2024-09-15', 'Seed', 'Social commerce trend'),
            (6, 6, 6000000.00, '2024-09-25', 'Series A', 'Enterprise SaaS has great potential'),
            (7, 7, 10000000.00, '2024-10-01', 'Series A', 'Renewable energy is the future'),
        ]
        
        for fund in funding:
            cursor.execute(
                """INSERT INTO Funding 
                (investor_id, startup_id, amount, funding_date, funding_round, notes)
                VALUES (%s, %s, %s, %s, %s, %s)""",
                fund
            )
        
        # 5. Update funded status
        print("  → Updating startup funded status...")
        cursor.execute(
            "UPDATE Startups SET is_funded = TRUE WHERE startup_id IN (1, 2, 3, 4, 5, 6, 7)"
        )
        
        # 6. Update investor portfolio size
        print("  → Updating investor portfolio sizes...")
        if db_type == 'postgresql':
            cursor.execute("""
                UPDATE Investors i 
                SET portfolio_size = (
                    SELECT COUNT(*) FROM Funding f WHERE f.investor_id = i.investor_id
                )
            """)
        else:
            cursor.execute("""
                UPDATE Investors i 
                SET portfolio_size = (
                    SELECT COUNT(*) FROM Funding f WHERE f.investor_id = i.investor_id
                )
            """)
        
        # 7. Insert Sample Matches
        print("  → Creating startup-investor matches...")
        matches = [
            (1, 1, 95, 'Perfect domain match (AI) and investment range'),
            (2, 1, 80, 'Domain match, investment range suitable'),
            (1, 2, 70, 'Investment range good, partial domain match'),
            (3, 2, 90, 'Excellent FinTech domain match'),
            (4, 4, 85, 'EdTech specialization match'),
            (6, 6, 88, 'SaaS expertise and good fit'),
            (7, 7, 92, 'Clean tech specialization match'),
        ]
        
        for match in matches:
            cursor.execute(
                """INSERT INTO Matches 
                (investor_id, startup_id, match_score, match_reason)
                VALUES (%s, %s, %s, %s)""",
                match
            )
        
        conn.commit()
        cursor.close()
        conn.close()
        
        print("✅ Database seeded successfully!")
        print("\n📊 Sample Data Summary:")
        print(f"   • {len(domains)} Domains")
        print(f"   • {len(startups)} Startups")
        print(f"   • {len(investors)} Investors")
        print(f"   • {len(funding)} Funding Records")
        print(f"   • {len(matches)} Matches")
        print("\n🔐 Login credentials (for all users): password123")
        print("   Example startup: contact@aiinsights.com")
        print("   Example investor: invest@accel.com")
        
        return True
        
    except Exception as e:
        print(f"❌ Error seeding database: {e}")
        conn.rollback()
        conn.close()
        return False


if __name__ == '__main__':
    print("=" * 50)
    print("🌱 Startup Funding System - Database Seeder")
    print("=" * 50)
    seed_database()
