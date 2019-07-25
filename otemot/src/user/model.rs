use chrono::{NaiveDateTime, Utc};
use crate::schema::users;
use diesel::PgConnection;
use diesel::prelude::*;
use bcrypt::{hash, verify, DEFAULT_COST};
use md5::compute;

#[table_name = "users"]
#[derive(Debug, Serialize, Deserialize, Queryable, AsChangeset)]
pub struct User {
    pub id: i32,
    pub email: String,
    pub username: String,
    pub password: String,
    pub created_at: NaiveDateTime,
    pub avatar: String,
}

#[table_name = "users"]
#[derive(Insertable)]
pub struct InsertableUser {
    pub email: String,
    pub username: String,
    pub password: String,
    pub created_at: NaiveDateTime,
    pub avatar: String,
}

#[derive(Serialize, Deserialize, Debug)]
#[allow(non_snake_case)]
pub struct CreateUser {
	pub email: String,
	pub username: String,
	pub password: String,
	pub confirmPassword: String,
}

impl User {
	pub fn create(user: CreateUser, connection: &PgConnection) -> QueryResult<User> {
		let hash_password = match hash(&user.password, DEFAULT_COST) {
			Ok(h) => h,
			Err(_) => panic!(),
		};
		let digest = compute(&user.email);
		let md5str = format!("{:x}", digest);
		let avatar_url = "http://www.gravatar.com/avatar/".to_string()
			+ &md5str
			+ "?s=128&d=identicon";
		let new_user = InsertableUser {
			email: user.email,
			username: user.username,
			password: hash_password,
			created_at: Utc::now().naive_utc(),
			avatar: avatar_url,
		};

		diesel::insert_into(users::table).values(&new_user).execute(connection)?;
		users::table.order(users::created_at.desc()).first(connection)
	}
}
