use crate::user::model::{User, CreateUser, LoginUser, SlimUser};
use crate::db;
use rocket::http::{self, Cookies, Cookie};
use rocket_contrib::json::Json;

pub mod model;
pub mod token;

#[post("/", data = "<user>")]
fn register(user: Json<CreateUser>, connection: db::Connection) -> Result<Json<User>, http::Status> {
	User::create(user.into_inner(), &connection)
		.map(Json)
		.map_err(|_| http::Status::InternalServerError)
}

#[post("/", data = "<user>")]
fn login(user: Json<LoginUser>, connection: db::Connection, mut cookies: Cookies) -> Result<Json<SlimUser>, http::Status> {
	// imagine that actual auth happens here
	let token = token::create_token(&SlimUser {
		username: user.username.clone(),
	})?;
	cookies.add_private(Cookie::new("auth", token));
	Ok(Json(SlimUser { username: user.username.clone() }))
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket
		.mount("/api/register", routes![register])
		.mount("/api/auth", routes![login])
}
