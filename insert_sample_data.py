import sqlite3
import uuid
from datetime import datetime, timedelta

# Sample data to insert
db = sqlite3.connect('smart_file_sharing.db')
cursor = db.cursor()

try:
    # Clear existing data
    cursor.execute('DELETE FROM shared_files')
    cursor.execute('DELETE FROM comments')
    cursor.execute('DELETE FROM file_versions')
    cursor.execute('DELETE FROM files')
    db.commit()
    
    # Insert sample users
    user1_id = str(uuid.uuid4())
    user2_id = str(uuid.uuid4())
    
    cursor.execute('''
        INSERT OR IGNORE INTO users (id, username, email, password_hash, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (user1_id, 'john_doe', 'john@example.com', 'hash123', datetime.now().isoformat(), datetime.now().isoformat()))
    
    cursor.execute('''
        INSERT OR IGNORE INTO users (id, username, email, password_hash, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (user2_id, 'jane_smith', 'jane@example.com', 'hash456', datetime.now().isoformat(), datetime.now().isoformat()))
    
    # Insert sample files
    file1_id = str(uuid.uuid4())
    file2_id = str(uuid.uuid4())
    file3_id = str(uuid.uuid4())
    
    cursor.execute('''
        INSERT INTO files (id, name, file_type, description, owner_id, latest_version, is_shared, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (file1_id, 'Project Proposal.docx', 'document', 'Q4 project proposal for review', user1_id, 3, 1, datetime.now().isoformat(), datetime.now().isoformat()))
    
    cursor.execute('''
        INSERT INTO files (id, name, file_type, description, owner_id, latest_version, is_shared, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (file2_id, 'Budget Analysis.xlsx', 'spreadsheet', 'Financial analysis for 2026', user1_id, 2, 1, (datetime.now() - timedelta(days=5)).isoformat(), (datetime.now() - timedelta(days=1)).isoformat()))
    
    cursor.execute('''
        INSERT INTO files (id, name, file_type, description, owner_id, latest_version, is_shared, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (file3_id, 'Team Meeting Notes.txt', 'text', 'Notes from Monday team standup', user2_id, 1, 0, (datetime.now() - timedelta(days=2)).isoformat(), (datetime.now() - timedelta(days=2)).isoformat()))
    
    # Insert file versions
    cursor.execute('''
        INSERT INTO file_versions (id, file_id, version_number, created_by, change_description, created_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file1_id, 1, user1_id, 'Initial draft', (datetime.now() - timedelta(days=3)).isoformat()))
    
    cursor.execute('''
        INSERT INTO file_versions (id, file_id, version_number, created_by, change_description, created_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file1_id, 2, user1_id, 'Added budget section', (datetime.now() - timedelta(days=2)).isoformat()))
    
    cursor.execute('''
        INSERT INTO file_versions (id, file_id, version_number, created_by, change_description, created_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file1_id, 3, user1_id, 'Final revision with feedback', datetime.now().isoformat()))
    
    cursor.execute('''
        INSERT INTO file_versions (id, file_id, version_number, created_by, change_description, created_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file2_id, 1, user1_id, 'Initial data', (datetime.now() - timedelta(days=5)).isoformat()))
    
    cursor.execute('''
        INSERT INTO file_versions (id, file_id, version_number, created_by, change_description, created_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file2_id, 2, user1_id, 'Updated with Q4 projections', (datetime.now() - timedelta(days=1)).isoformat()))
    
    # Insert comments
    cursor.execute('''
        INSERT INTO comments (id, file_id, user_id, text, created_at)
        VALUES (?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file1_id, user2_id, 'Great work! I have some suggestions on page 3', (datetime.now() - timedelta(hours=2)).isoformat()))
    
    cursor.execute('''
        INSERT INTO comments (id, file_id, user_id, text, created_at)
        VALUES (?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file1_id, user1_id, 'Thanks! Will incorporate your feedback', (datetime.now() - timedelta(hours=1)).isoformat()))
    
    cursor.execute('''
        INSERT INTO comments (id, file_id, user_id, text, created_at)
        VALUES (?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file2_id, user1_id, 'Numbers look good for Q1-Q3', datetime.now().isoformat()))
    
    # Insert shared files
    cursor.execute('''
        INSERT INTO shared_files (id, file_id, shared_by, shared_with, access_level, shared_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file1_id, user1_id, user2_id, 'view_only', datetime.now().isoformat()))
    
    cursor.execute('''
        INSERT INTO shared_files (id, file_id, shared_by, shared_with, access_level, shared_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (str(uuid.uuid4()), file2_id, user1_id, user2_id, 'comment', datetime.now().isoformat()))
    
    db.commit()
    print("✓ Sample data inserted successfully!")
    print(f"✓ Created 3 files with versions and comments")
    print(f"✓ Files shared between users")
    print(f"✓ Database ready for testing")
    
except Exception as e:
    print(f"✗ Error: {e}")
    db.rollback()
finally:
    db.close()
