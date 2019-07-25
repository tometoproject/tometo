use crate::actor::Oa;
use crate::models::user::{SigninUser, SignupUser};
use actix::Addr;
use actix_identity::Identity;
use actix_web::{web, Error, HttpResponse, Responder, ResponseError};
use futures::Future;

use crate::handlers::user::LoggedUser;
use crate::models::user::SlimUser;
use crate::token::create_token;

pub fn signup(
    signup_user: web::Json<SignupUser>,
    state: web::Data<Addr<Oa>>,
) -> impl Future<Item = HttpResponse, Error = Error> {
    state
        .send(signup_user.into_inner())
        .from_err()
        .and_then(|res| match res {
            Ok(signup_msg) => Ok(HttpResponse::Ok().json(signup_msg)),
            Err(err) => Ok(err.error_response()),
        })
}

pub fn signin(
    signin_user: web::Json<SigninUser>,
    id: Identity,
    state: web::Data<Addr<Oa>>,
) -> impl Future<Item = HttpResponse, Error = Error> {
    state
        .send(signin_user.into_inner())
        .from_err()
        .and_then(move |res| match res {
            Ok(signin_msg) => {
                let token = create_token(&SlimUser {
                    username: signin_msg.username.clone(),
                })?;
                id.remember(token);
                Ok(HttpResponse::Ok().json(signin_msg))
            }
            Err(err) => Ok(err.error_response()),
        })
}

pub fn logout(id: Identity) -> impl Responder {
    id.forget();
    HttpResponse::Ok()
}

pub fn get_user(logged_user: LoggedUser) -> HttpResponse {
    HttpResponse::Ok().json(logged_user)
}
