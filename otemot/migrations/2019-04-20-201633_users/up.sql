-- Your SQL goes here
create table users (
  id serial not null primary key,
  email text not null,
  username text not null,
  password text not null,
  created_at timestamp not null default current_timestamp,
  avatar text not null default '',
  unique (email, username)
);