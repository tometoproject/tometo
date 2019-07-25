use chrono::{Duration, Local};
use jsonwebtoken::{decode, encode, Header, Validation};
use crate::user::model::SlimUser;
use rocket::http::Status;

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
    /// Username
    username: String,
}

impl Claim {
    fn with_username(username: &str) -> Self {
        Claim {
            iss: "localhost".into(),
            sub: "auth".into(),
            username: username.to_owned(),
            iat: Local::now().timestamp(),
            exp: (Local::now() + Duration::hours(24)).timestamp(),
        }
    }
}

impl From<Claim> for SlimUser {
    fn from(claims: Claim) -> Self {
        SlimUser {
            username: claims.username,
        }
    }
}

pub fn create_token(data: &SlimUser) -> Result<String, Status> {
    let claims = Claim::with_username(data.username.as_str());
    encode(&Header::default(), &claims, get_secret().as_ref())
        .map_err(|_err| Status::InternalServerError)
}

pub fn decode_token(token: &str) -> Result<SlimUser, Status> {
    decode::<Claim>(token, get_secret().as_ref(), &Validation::default())
        .map(|data| Ok(data.claims.into()))
        .map_err(|_err| Status::InternalServerError)?
}

fn get_secret() -> String {
    let mut cfg = config::Config::default();
    cfg.merge(config::File::new("config.json", config::FileFormat::Json))
        .unwrap();
    cfg.get::<String>("otemot.secrets.jwt")
        .unwrap_or_else(|_| "temp".into())
}
