use diesel::result::{DatabaseErrorKind, Error};
use rocket::response::Responder;
use rocket_contrib::json::Json;
use std::convert::From;

#[derive(Serialize, Debug, Deserialize)]
pub struct ErrorJson {
	pub message: String,
}

pub fn new_ejson(message: &str) -> Json<ErrorJson> {
	Json(ErrorJson {
		message: message.to_string(),
	})
}

#[derive(Responder, Debug)]
pub enum OError {
	#[response(status = 500)]
	InternalServerError(Json<ErrorJson>),
	#[response(status = 400)]
	BadRequest(Json<ErrorJson>),
	#[response(status = 404)]
	NotFound(Json<ErrorJson>),
	#[response(status = 401)]
	Unauthorized(Json<ErrorJson>),
}

impl From<Error> for OError {
	fn from(err: Error) -> OError {
		match err {
			Error::DatabaseError(kind, info) => {
				if let DatabaseErrorKind::UniqueViolation = kind {
					let message = info.details().unwrap_or_else(|| info.message());
					return OError::BadRequest(new_ejson(message));
				}
				OError::InternalServerError(new_ejson("Database error"))
			}
			_ => OError::InternalServerError(new_ejson("Database error")),
		}
	}
}

impl From<std::io::Error> for OError {
	fn from(_: std::io::Error) -> OError {
		OError::InternalServerError(new_ejson("Internal IO error"))
	}
}