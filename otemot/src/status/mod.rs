use crate::db;
use crate::status::model::{CreateStatus, GetStatus, GetStatusResponse, Status};
use crate::user::model::SlimUser;
use rocket::http;
use rocket_contrib::json::Json;
use uuid::Uuid;

pub mod model;

#[post("/", data = "<status>")]
fn create_status(
	user: SlimUser,
	status: Json<CreateStatus>,
	connection: db::Connection,
) -> Result<Json<Uuid>, http::Status> {
	let status = status.into_inner();

	let res = Status::create(status, &user.username, &connection);

	match res {
		Ok(r) => Ok(Json(r)),
		Err(e) => Err(e),
	}
}

#[get("/<id>")]
fn get_status(
	id: String,
	connection: db::Connection,
) -> Result<Json<GetStatusResponse>, http::Status> {
	let status = GetStatus { id };
	let res = Status::get(status, &connection);
	match res {
		Ok(r) => Ok(Json(r)),
		Err(e) => Err(e),
	}
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket
		.mount("/api/status/new", routes![create_status])
		.mount("/api/status", routes![get_status])
}
