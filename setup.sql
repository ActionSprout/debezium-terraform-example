CREATE TABLE IF NOT EXISTS people (id serial primary key, name text, email text);

ALTER TABLE people REPLICA IDENTITY FULL;
