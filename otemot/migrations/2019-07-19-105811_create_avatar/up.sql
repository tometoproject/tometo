-- Your SQL goes here
CREATE TABLE avatars(
	id TEXT NOT NULL PRIMARY KEY,
	name TEXT NOT NULL,
	user_id INTEGER NOT NULL REFERENCES users (id),
	pitch SMALLINT NOT NULL,
	speed REAL NOT NULL,
	language TEXT NOT NULL,
	gender TEXT NOT NULL
);
