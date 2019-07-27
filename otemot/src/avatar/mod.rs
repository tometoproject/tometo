use crate::avatar::model::{Avatar, CreateAvatar};
use crate::db;
use crate::user::model::SlimUser;
use rocket::http;
use rocket_contrib::json::Json;

pub mod model;

#[post("/", data = "<avatar>")]
fn create_avatar(
	user: SlimUser,
	avatar: Json<CreateAvatar>,
	connection: db::Connection,
) -> Result<String, http::Status> {
	let avatar = avatar.into_inner();

	let res = Avatar::create(avatar, &user.username, &connection);

	match res {
		Ok(_) => Ok("Successfully created Avatar!".to_string()),
		Err(e) => Err(e),
	}
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket.mount("/api/avatar/new", routes![create_avatar])
}
