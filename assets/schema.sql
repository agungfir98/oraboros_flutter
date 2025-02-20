CREATE TABLE transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT CHECK (type IN ('expense', 'income')),  
    amount REAL NOT NULL CHECK (amount >= 0),
    category_id INTEGER REFERENCES categories(id),  
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    amount REAL NOT NULL CHECK (amount >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user (
  name text,
  balance real DEFAULT 0,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
)
