-- Smart File Sharing App - SQLite Database Schema
-- SQLite 3.0+

-- Users Table
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Files Table
CREATE TABLE IF NOT EXISTS files (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  file_type TEXT NOT NULL,
  description TEXT,
  owner_id TEXT NOT NULL,
  latest_version INTEGER DEFAULT 1,
  is_shared BOOLEAN DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(owner_id, name)
);

-- File Versions Table
CREATE TABLE IF NOT EXISTS file_versions (
  id TEXT PRIMARY KEY,
  file_id TEXT NOT NULL,
  version_number INTEGER NOT NULL,
  created_by TEXT NOT NULL,
  change_description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id),
  UNIQUE(file_id, version_number)
);

-- Comments Table
CREATE TABLE IF NOT EXISTS comments (
  id TEXT PRIMARY KEY,
  file_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  text TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Shared Files Table
CREATE TABLE IF NOT EXISTS shared_files (
  id TEXT PRIMARY KEY,
  file_id TEXT NOT NULL,
  shared_by TEXT NOT NULL,
  shared_with TEXT NOT NULL,
  access_level TEXT DEFAULT 'VIEW',
  shared_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
  FOREIGN KEY (shared_by) REFERENCES users(id),
  FOREIGN KEY (shared_with) REFERENCES users(id)
);

-- Sync Queue Table
CREATE TABLE IF NOT EXISTS sync_queue (
  id TEXT PRIMARY KEY,
  operation_type TEXT NOT NULL,
  file_id TEXT,
  user_id TEXT,
  payload TEXT,
  status TEXT DEFAULT 'PENDING',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (file_id) REFERENCES files(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Conflicts Table
CREATE TABLE IF NOT EXISTS conflicts (
  id TEXT PRIMARY KEY,
  file_id TEXT NOT NULL,
  conflicting_version_ids TEXT,
  detected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  resolution_strategy TEXT,
  resolved_version_id TEXT,
  resolved_at DATETIME,
  FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE,
  FOREIGN KEY (resolved_version_id) REFERENCES file_versions(id)
);

-- Sync Logs Table
CREATE TABLE IF NOT EXISTS sync_logs (
  id TEXT PRIMARY KEY,
  file_id TEXT,
  operation_type TEXT NOT NULL,
  status TEXT NOT NULL,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  details TEXT,
  FOREIGN KEY (file_id) REFERENCES files(id)
);

-- Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_files_owner_id ON files(owner_id);
CREATE INDEX IF NOT EXISTS idx_files_created_at ON files(created_at);
CREATE INDEX IF NOT EXISTS idx_file_versions_file_id ON file_versions(file_id);
CREATE INDEX IF NOT EXISTS idx_comments_file_id ON comments(file_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_shared_files_file_id ON shared_files(file_id);
CREATE INDEX IF NOT EXISTS idx_shared_files_shared_with ON shared_files(shared_with);
CREATE INDEX IF NOT EXISTS idx_sync_queue_status ON sync_queue(status);
CREATE INDEX IF NOT EXISTS idx_conflicts_file_id ON conflicts(file_id);

-- Insert Sample Data
INSERT OR IGNORE INTO users (id, username, email, password_hash) VALUES
('user_001', 'john_doe', 'john@example.com', 'hashed_password_1');

INSERT OR IGNORE INTO users (id, username, email, password_hash) VALUES
('user_002', 'jane_smith', 'jane@example.com', 'hashed_password_2');

-- Enable Foreign Keys (must be done after schema creation)
PRAGMA foreign_keys = ON;
