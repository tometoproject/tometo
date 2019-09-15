use crate::error::{new_ejson, OError};
use crate::user::model::SlimUser;
use chrono::{Duration, Local};
use jsonwebtoken::{decode, encode, Header, Validation};

#[derive(Debug, Serialize, Deserialize)]
struct Claim {
	/// Issuer
	iss: String,
	/// Subject
	sub: String,
	/// Issued at
	iat: i64,
	/// Expiry
	exp: i64,
	/// ID
	id: i32,
	/// Username
	username: String,
}

impl Claim {
	fn with_user_data(id: i32, username: &str) -> Self {
		Claim {
			iss: "localhost".into(),
			sub: "auth".into(),
			id,
			username: username.to_owned(),
			iat: Local::now().timestamp(),
			exp: (Local::now() + Duration::hours(24)).timestamp(),
		}
	}
}

impl From<Claim> for SlimUser {
	fn from(claims: Claim) -> Self {
		SlimUser {
			id: claims.id,
			username: claims.username,
		}
	}
}

pub fn create_token(data: &SlimUser) -> Result<String, OError> {
	let claims = Claim::with_user_data(data.id, data.username.as_str());
	encode(&Header::default(), &claims, get_secret().as_ref())
		.map_err(|_err| OError::InternalServerError(new_ejson("Error while creating JWT!")))
}

pub fn decode_token(token: &str) -> Result<SlimUser, OError> {
	decode::<Claim>(token, get_secret().as_ref(), &Validation::default())
		.map(|data| Ok(data.claims.into()))
		.map_err(|_err| OError::InternalServerError(new_ejson("Error while decoding JWT!")))?
}

fn get_secret() -> String {
	let mut cfg = config::Config::default();
	cfg.merge(config::File::new("config.toml", config::FileFormat::Toml))
		.unwrap();
	cfg.get::<String>("otemot.secrets.jwt")
		.unwrap_or_else(|_| "temp".into())
}
