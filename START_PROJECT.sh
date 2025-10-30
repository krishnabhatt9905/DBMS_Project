#!/bin/bash

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     DBMS PROJECT STARTUP SCRIPT                         ║"
echo "║     Startup Funding & Investor Matchmaking System       ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

cd "$(dirname "$0")"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "📋 STEP 1: Checking Prerequisites"
echo "═══════════════════════════════════════════════════════════"

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✓${NC} Python installed: $PYTHON_VERSION"
else
    echo -e "${RED}✗${NC} Python 3 not found. Please install Python 3.7+"
    exit 1
fi

# Check MySQL
if command -v mysql &> /dev/null; then
    echo -e "${GREEN}✓${NC} MySQL installed"
else
    echo -e "${YELLOW}⚠${NC}  MySQL not found. You'll need to install it:"
    echo "   brew install mysql"
fi

echo ""
echo "📦 STEP 2: Setting up Virtual Environment"
echo "═══════════════════════════════════════════════════════════"

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo -e "${GREEN}✓${NC} Virtual environment created"
else
    echo -e "${GREEN}✓${NC} Virtual environment already exists"
fi

echo ""
echo "📥 STEP 3: Installing Dependencies"
echo "═══════════════════════════════════════════════════════════"

source venv/bin/activate

echo "Installing Flask, bcrypt, and MySQL connector..."
pip install Flask bcrypt mysql-connector-python 2>&1 | grep -v "WARNING"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All dependencies installed successfully"
else
    echo -e "${RED}✗${NC} Installation failed. Trying alternative method..."
    
    # Try with --user flag
    pip install --user Flask bcrypt mysql-connector-python 2>&1 | grep -v "WARNING"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗${NC} Installation failed. Please run manually:"
        echo "   cd DBMS_Project"
        echo "   source venv/bin/activate"
        echo "   pip install Flask bcrypt mysql-connector-python"
        exit 1
    fi
fi

echo ""
echo "🗄️  STEP 4: Setting up MySQL Database"
echo "═══════════════════════════════════════════════════════════"

echo "Checking MySQL connection..."
mysql -u root -e "SELECT 1" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} MySQL is running (no password)"
    
    echo ""
    read -p "Do you want to create the database now? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Creating database 'funding_system'..."
        mysql -u root -e "CREATE DATABASE IF NOT EXISTS funding_system;" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓${NC} Database 'funding_system' created"
            
            echo "Importing schema and sample data..."
            mysql -u root funding_system < database_schema.sql
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓${NC} Database schema imported successfully"
                echo -e "${GREEN}✓${NC} Sample data loaded (5 startups, 5 investors)"
            else
                echo -e "${RED}✗${NC} Failed to import schema"
            fi
        fi
    fi
else
    echo -e "${YELLOW}⚠${NC}  MySQL requires password or not running"
    echo ""
    echo "Please set up MySQL manually:"
    echo "   1. Start MySQL: brew services start mysql"
    echo "   2. Login: mysql -u root -p"
    echo "   3. CREATE DATABASE funding_system;"
    echo "   4. EXIT;"
    echo "   5. Import: mysql -u root -p funding_system < database_schema.sql"
    echo ""
    echo "   OR if no password:"
    echo "   mysql -u root -e 'CREATE DATABASE funding_system'"
    echo "   mysql -u root funding_system < database_schema.sql"
fi

echo ""
echo "⚙️  STEP 5: Configuring Application"
echo "═══════════════════════════════════════════════════════════"

echo ""
echo -e "${YELLOW}⚠${NC}  IMPORTANT: Update your MySQL password in app.py"
echo "   Edit line 16 in app.py:"
echo "   'password': 'your_mysql_password'  ← Change this!"
echo ""

read -p "Press Enter when you've updated the password (or Enter to skip)..."

echo ""
echo "🚀 STEP 6: Starting Flask Application"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Check if database is set up
mysql -u root -e "USE funding_system; SELECT COUNT(*) FROM Startups;" 2>/dev/null > /dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Database is set up and ready"
    echo ""
    echo "Starting Flask application..."
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║   🌐 Flask application will start on:                   ║"
    echo "║      http://localhost:5000                              ║"
    echo "║                                                          ║"
    echo "║   Press Ctrl+C to stop the server                       ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    
    sleep 2
    python3 app.py
else
    echo -e "${RED}✗${NC} Database not ready. Please set up MySQL first."
    echo ""
    echo "Quick setup:"
    echo "   mysql -u root -e 'CREATE DATABASE funding_system'"
    echo "   mysql -u root funding_system < database_schema.sql"
    echo ""
    echo "Then run: ./START_PROJECT.sh"
fi

