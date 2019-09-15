use crate::avatar::model::Avatar;
use crate::db::Connection;
use crate::error::{new_ejson, OError};
use crate::schema::{avatars, users};
use crate::user::token::decode_token;
use bcrypt::{hash, verify, DEFAULT_COST};
use chrono::{NaiveDateTime, Utc};
use diesel::prelude::*;
use diesel::PgConnection;
use md5::compute;
use rocket::http;
use rocket::request::{FromRequest, Outcome, Request};

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

#[derive(Serialize, Deserialize, Debug)]
pub struct SlimUser {
	pub id: i32,
	pub username: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PollResponse {
	pub has_avatar: bool,
}

impl From<User> for SlimUser {
	fn from(user: User) -> Self {
		SlimUser {
			id: user.id,
			username: user.username,
		}
	}
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

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginUser {
	pub username: String,
	pub password: String,
}

impl User {
	pub fn create(user: CreateUser, connection: &PgConnection) -> Result<(), OError> {
		let hash_password = match hash(&user.password, DEFAULT_COST) {
			Ok(h) => h,
			Err(e) => panic!(e),
		};
		let digest = compute(&user.email);
		let md5str = format!("{:x}", digest);
		let avatar_url =
			"http://www.gravatar.com/avatar/".to_string() + &md5str + "?s=128&d=identicon";
		let new_user = InsertableUser {
			email: user.email,
			username: user.username,
			password: hash_password,
			created_at: Utc::now().naive_utc(),
			avatar: avatar_url,
		};

		diesel::insert_into(users::table)
			.values(&new_user)
			.execute(connection)?;
		Ok(())
	}

	pub fn check_password(user: &LoginUser, connection: &PgConnection) -> Result<i32, OError> {
		let db_user = users::table
			.filter(users::username.eq(&user.username))
			.first::<User>(connection)?;
		match verify(&user.password, &db_user.password) {
			Ok(valid) if valid => Ok(db_user.id),
			Ok(valid) if !valid => Err(OError::BadRequest(new_ejson("Password doesn't match!"))),
			_ => Err(OError::InternalServerError(new_ejson(
				"Error while verifying password",
			))),
		}
	}

	pub fn check_avatar(user: &SlimUser, connection: &PgConnection) -> Result<bool, OError> {
		let av = avatars::table
			.filter(avatars::user_id.eq(user.id))
			.first::<Avatar>(connection);

		match av {
			Ok(_) => Ok(true),
			Err(diesel::result::Error::NotFound) => Ok(false),
			Err(_) => Err(OError::InternalServerError(new_ejson(
				"Unexpected database error!",
			))),
		}
	}
}

impl<'a, 'r> FromRequest<'a, 'r> for SlimUser {
	type Error = ();

	fn from_request(request: &'a Request<'r>) -> Outcome<Self, Self::Error> {
		let conn = request.guard::<Connection>()?.0;
		let jwt = request.cookies().get_private("auth");
		if jwt.is_none() {
			return Outcome::Failure((http::Status::Unauthorized, ()));
		}
		let user = decode_token(&jwt.unwrap().value());
		if user.is_err() {
			return Outcome::Failure((http::Status::Unauthorized, ()));
		}
		let query = users::table
			.filter(users::username.eq(&user.unwrap().username))
			.first::<User>(&conn);
		match query {
			Ok(u) => Outcome::Success(u.into()),
			Err(_) => Outcome::Failure((http::Status::Unauthorized, ())),
		}
	}
}
