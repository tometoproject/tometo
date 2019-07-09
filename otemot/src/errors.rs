use actix_web::{error::ResponseError, HttpResponse};
use derive_more::Display;
use diesel::result::{DatabaseErrorKind, Error as DBError};
use std::convert::From;
use uuid::ParseError;

#[derive(Serialize)]
struct ErrorJson {
    message: String,
}

impl ErrorJson {
    fn new(str: String) -> ErrorJson {
        ErrorJson { message: str }
    }
}

#[derive(Debug, Display)]
pub enum ServiceError {
    #[display(fmt = "Internal Server Error")]
    InternalServerError,

    #[display(fmt = "BadRequest = {}", _0)]
    BadRequest(String),

    #[display(fmt = "NotFound = {}", _0)]
    NotFound(String),

    #[display(fmt = "Unauthorized")]
    Unauthorized,
}

impl ResponseError for ServiceError {
    fn error_response(&self) -> HttpResponse {
        match *self {
            ServiceError::InternalServerError => HttpResponse::InternalServerError()
                .json(ErrorJson::new("Internal Server Error!".to_string())),
            ServiceError::BadRequest(ref message) => {
                HttpResponse::BadRequest().json(ErrorJson::new(message.to_string()))
            }
            ServiceError::NotFound(ref message) => {
                HttpResponse::NotFound().json(ErrorJson::new(message.to_string()))
            }
            ServiceError::Unauthorized => {
                HttpResponse::Unauthorized().json(ErrorJson::new("Unauthorized!".to_string()))
            }
        }
    }
}

impl From<ParseError> for ServiceError {
    fn from(_: ParseError) -> ServiceError {
        ServiceError::BadRequest("Invalid UUID".into())
    }
}

impl From<DBError> for ServiceError {
    fn from(error: DBError) -> ServiceError {
        match error {
            DBError::DatabaseError(kind, info) => {
                if let DatabaseErrorKind::UniqueViolation = kind {
                    let message = info.details().unwrap_or_else(|| info.message()).to_string();
                    return ServiceError::BadRequest(message);
                }
                ServiceError::InternalServerError
            }
            _ => ServiceError::InternalServerError,
        }
    }
}

impl From<std::io::Error> for ServiceError {
    fn from(_: std::io::Error) -> ServiceError {
        ServiceError::InternalServerError
    }
}
