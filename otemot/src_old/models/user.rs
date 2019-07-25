use crate::errors::ServiceError;
use crate::messages::{DefaultMsg, LoginMsg};
use crate::schema::users;
use actix::Message;
use chrono::{NaiveDateTime, Utc};

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq, Identifiable, Queryable)]
pub struct User {
    pub id: i32,
    pub email: String,
    pub username: String,
    pub password: String,
    pub created_at: NaiveDateTime,
    pub avatar: String,
}

/// Struct that only holds the username for encoding into a session cookie.
#[derive(Debug, Serialize, Deserialize)]
pub struct SlimUser {
    pub username: String,
}

impl From<User> for SlimUser {
    fn from(user: User) -> SlimUser {
        SlimUser {
            username: user.username,
        }
    }
}

#[derive(Debug, Serialize, Deserialize, Insertable)]
#[table_name = "users"]
pub struct NewUser<'a> {
    pub email: &'a str,
    pub username: &'a str,
    pub password: &'a str,
    pub created_at: NaiveDateTime,
    pub avatar: &'a str,
}

#[derive(Deserialize, Serialize, Debug)]
#[allow(non_snake_case)]
pub struct SignupUser {
    pub username: String,
    pub email: String,
    pub password: String,
    pub confirmPassword: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct SigninUser {
    pub username: String,
    pub password: String,
}

impl Message for SignupUser {
    type Result = Result<DefaultMsg, ServiceError>;
}

impl Message for SigninUser {
    type Result = Result<LoginMsg, ServiceError>;
}

impl Default for User {
    fn default() -> Self {
        User {
            id: 0,
            email: "".to_string(),
            username: "".to_string(),
            password: "".to_string(),
            created_at: Utc::now().naive_utc(),
            avatar: "".to_string(),
        }
    }
}
