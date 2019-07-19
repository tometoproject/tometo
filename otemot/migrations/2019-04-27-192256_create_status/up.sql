-- Your SQL goes here
CREATE TABLE statuses(
  id TEXT NOT NULL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users (id),
  content TEXT NOT NULL,
  pitch INTEGER NOT NULL
);
