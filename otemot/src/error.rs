use config::ConfigError;
use diesel::result::{DatabaseErrorKind, Error};
use rocket::response::Responder;
use rocket_contrib::json::Json;
use std::convert::From;
use std::num::{ParseFloatError, ParseIntError};

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
				OError::InternalServerError(new_ejson(&format!("Database Error: {:?}", kind)))
			}
			_ => OError::InternalServerError(new_ejson("Database Error")),
		}
	}
}

impl From<std::io::Error> for OError {
	fn from(_: std::io::Error) -> OError {
		OError::InternalServerError(new_ejson("Internal IO error"))
	}
}

impl From<ConfigError> for OError {
	fn from(err: ConfigError) -> OError {
		if let ConfigError::NotFound(st) = err {
			error!("Config property {} was not found!", st);
		}
		OError::InternalServerError(new_ejson("A server configuration error has occurred!"))
	}
}

impl From<ParseIntError> for OError {
	fn from(_: ParseIntError) -> OError {
		OError::BadRequest(new_ejson(
			"Failed to parse integer! Did you input a number?",
		))
	}
}

impl From<ParseFloatError> for OError {
	fn from(_: ParseFloatError) -> OError {
		OError::BadRequest(new_ejson("Failed to parse float! Did you input a number?"))
	}
}
