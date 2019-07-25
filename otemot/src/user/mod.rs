use crate::user::model::{User, CreateUser};
use crate::db;
use rocket::http;
use rocket_contrib::json::Json;

pub mod model;

#[post("/", data = "<user>")]
fn register(user: Json<CreateUser>, connection: db::Connection) -> Result<Json<User>, http::Status> {
	User::create(user.into_inner(), &connection)
		.map(Json)
		.map_err(|_| http::Status::InternalServerError)
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket
		.mount("/api/register", routes![register])
}
