-- Your SQL goes here
create table statuses(
  id text not null primary key,
  content text not null,
  pitch integer not null,
  user_id integer not null
);
