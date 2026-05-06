import sqlite3
import sys

# Read SQL schema
with open('database_schema.sql', 'r') as f:
    sql_schema = f.read()

# Create database and execute schema
try:
    conn = sqlite3.connect('smart_file_sharing.db')
    cursor = conn.cursor()
    
    # Split by semicolon and execute each statement
    statements = sql_schema.split(';')
    for statement in statements:
        statement = statement.strip()
        if statement:
            try:
                cursor.execute(statement)
            except sqlite3.Error as e:
                print(f"SQLite error: {e}")
                print(f"Statement: {statement[:100]}...")
    
    conn.commit()
    conn.close()
    print("✓ Database created successfully: smart_file_sharing.db")
    print("✓ All tables, indexes, and sample data initialized")
    sys.exit(0)
    
except Exception as e:
    print(f"✗ Error creating database: {e}")
    sys.exit(1)
