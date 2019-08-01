use crate::avatar::model::{Avatar, CreateAvatar};
use crate::db;
use crate::error::OError;
use crate::user::model::SlimUser;
use rocket_contrib::json::Json;

pub mod model;

#[post("/", data = "<avatar>")]
fn create_avatar(
	user: SlimUser,
	avatar: Json<CreateAvatar>,
	connection: db::Connection,
) -> Result<String, OError> {
	let avatar = avatar.into_inner();

	Avatar::create(avatar, &user.username, &connection)?;

	Ok("Successfully created Avatar!".to_string())
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket.mount("/api/avatar/new", routes![create_avatar])
}
