-- This file should undo anything in `up.sql`
ALTER TABLE statuses DROP COLUMN avatar_id;
ALTER TABLE statuses DROP COLUMN related_status_id;
ALTER TABLE statuses ADD COLUMN user_id INTEGER NOT NULL REFERENCES users (id);
ALTER TABLE statuses ADD COLUMN pitch INTEGER NOT NULL;
