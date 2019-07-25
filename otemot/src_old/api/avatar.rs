use crate::actor::Oa;
use crate::handlers::user::LoggedUser;
use crate::models::avatar::{CreateAvatar, CreateAvatarJson};
use actix::Addr;
use actix_web::{web, Error, HttpResponse, ResponseError};
use futures::Future;

pub fn create_avatar(
    user: LoggedUser,
    avatar: web::Json<CreateAvatarJson>,
    state: web::Data<Addr<Oa>>,
) -> impl Future<Item = HttpResponse, Error = Error> {
    let cavatar = CreateAvatar::from_json(avatar.into_inner(), user.username);

    state.send(cavatar).from_err().and_then(|res| match res {
        Ok(new_avatar_msg) => Ok(HttpResponse::Ok().json(new_avatar_msg)),
        Err(err) => Ok(err.error_response()),
    })
}
