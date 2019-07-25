-- Your SQL goes here
ALTER TABLE statuses ADD COLUMN avatar_id TEXT NOT NULL REFERENCES avatars (id);
ALTER TABLE statuses ADD COLUMN related_status_id TEXT REFERENCES statuses (id);
ALTER TABLE statuses DROP COLUMN user_id;
ALTER TABLE statuses DROP COLUMN pitch;
