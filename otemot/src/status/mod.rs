use crate::db;
use crate::error::OError;
use crate::status::model::{CreateStatus, GetStatus, GetStatusResponse, Status};
use crate::user::model::SlimUser;
use rocket_contrib::json::Json;
use uuid::Uuid;

pub mod model;

#[post("/", data = "<status>")]
fn create_status(
	user: SlimUser,
	status: Json<CreateStatus>,
	connection: db::Connection,
) -> Result<Json<Uuid>, OError> {
	let status = status.into_inner();

	let res = Status::create(status, &user.username, &connection)?;

	Ok(Json(res))
}

#[get("/<id>")]
fn get_status(id: String, connection: db::Connection) -> Result<Json<GetStatusResponse>, OError> {
	let status = GetStatus { id };
	let res = Status::get(status, &connection)?;
	Ok(Json(res))
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket
		.mount("/api/status/new", routes![create_status])
		.mount("/api/status", routes![get_status])
}
