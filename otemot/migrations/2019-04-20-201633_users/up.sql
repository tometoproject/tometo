-- Your SQL goes here
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT NOT NULL,
  username TEXT NOT NULL,
  password TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  avatar TEXT NOT NULL DEFAULT '',
  UNIQUE (email, username)
);
