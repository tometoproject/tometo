use actix::Handler;
use actix_identity::Identity;
use actix_web::{dev::Payload, Error, FromRequest, HttpRequest};
use bcrypt::{hash, verify, DEFAULT_COST};
use chrono::Utc;
use diesel::{self, ExpressionMethods, QueryDsl, RunQueryDsl};
use md5::compute;

use crate::actor::Oa;
use crate::errors::ServiceError;
use crate::messages::{DefaultMsg, LoginMsg};
use crate::models::user::{NewUser, SigninUser, SignupUser, SlimUser, User};
use crate::token::decode_token;

impl Handler<SignupUser> for Oa {
    type Result = Result<DefaultMsg, ServiceError>;

    fn handle(&mut self, signup_user: SignupUser, _: &mut Self::Context) -> Self::Result {
        use crate::schema::users::dsl::*;

        if signup_user.username.is_empty()
            || signup_user.password.is_empty()
            || signup_user.confirmPassword.is_empty()
            || signup_user.email.is_empty()
        {
            return Err(ServiceError::BadRequest(
                "Please fill out all of the fields!".to_string(),
            ));
        }

        let conn = &self.0.get().unwrap();
        let user_result = users
            .filter(&username.eq(&signup_user.username))
            .load::<User>(conn)
            .map_err(|_| ServiceError::InternalServerError)?
            .pop();
        match user_result {
            Some(_) => Err(ServiceError::BadRequest("Already registered!".to_string())),
            None => {
                if signup_user.password == signup_user.confirmPassword {
                    let hash_password = match hash(&signup_user.password, DEFAULT_COST) {
                        Ok(h) => h,
                        Err(_e) => panic!(),
                    };
                    let digest = compute(&signup_user.email);
                    let md5str = format!("{:x}", digest);
                    let avatar_url = "http://www.gravatar.com/avatar/".to_string()
                        + &md5str
                        + "?s=128&d=identicon";
                    let new_user = NewUser {
                        email: &signup_user.email,
                        username: &signup_user.username,
                        password: &hash_password,
                        created_at: Utc::now().naive_utc(),
                        avatar: &avatar_url,
                    };
                    diesel::insert_into(users)
                        .values(&new_user)
                        .execute(conn)
                        .map_err(|_| ServiceError::InternalServerError)?;
                    Ok(DefaultMsg {
                        status: 200,
                        message: "User successfully created".to_string(),
                    })
                } else {
                    Err(ServiceError::BadRequest(
                        "Failed to create user".to_string(),
                    ))
                }
            }
        }
    }
}

impl Handler<SigninUser> for Oa {
    type Result = Result<LoginMsg, ServiceError>;

    fn handle(&mut self, signin_user: SigninUser, _: &mut Self::Context) -> Self::Result {
        use crate::schema::users::dsl::*;

        if signin_user.username.is_empty() || signin_user.password.is_empty() {
            return Err(ServiceError::BadRequest(
                "Please fill out all of the fields!".to_string(),
            ));
        }

        let conn = &self.0.get().unwrap();
        let login_user = users
            .filter(&username.eq(&signin_user.username))
            .load::<User>(conn)
            .map_err(|_| ServiceError::InternalServerError)?
            .pop();
        match login_user {
            Some(login_user) => match verify(&signin_user.password, &login_user.password) {
                Ok(valid) if valid => Ok(LoginMsg {
                    status: 200,
                    username: login_user.username,
                    message: "Signed in successfully!".to_string(),
                }),
                Ok(valid) if !valid => Err(ServiceError::BadRequest("Wrong password!".to_string())),
                _ => Err(ServiceError::InternalServerError),
            },
            None => Err(ServiceError::BadRequest("No user found!".to_string())),
        }
    }
}

pub type LoggedUser = SlimUser;

impl FromRequest for LoggedUser {
    type Error = Error;
    type Future = Result<LoggedUser, Error>;
    type Config = ();

    fn from_request(req: &HttpRequest, pl: &mut Payload) -> Self::Future {
        if let Some(identity) = Identity::from_request(req, pl)?.identity() {
            let user: SlimUser = decode_token(&identity)?;
            return Ok(user as LoggedUser);
        }
        Err(ServiceError::Unauthorized.into())
    }
}
