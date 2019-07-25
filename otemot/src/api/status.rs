use crate::actor::Oa;
use crate::handlers::user::LoggedUser;
use crate::models::status::{CreateStatus, CreateStatusJson, GetStatus};
use actix::Addr;
use actix_web::{web, Error, HttpResponse, ResponseError};
use futures::Future;

pub fn create_status(
    user: LoggedUser,
    status: web::Json<CreateStatusJson>,
    state: web::Data<Addr<Oa>>,
) -> impl Future<Item = HttpResponse, Error = Error> {
    let cstatus = CreateStatus::from_json(status.into_inner(), user.username);

    state.send(cstatus).from_err().and_then(|res| match res {
        Ok(new_status_msg) => Ok(HttpResponse::Ok().json(new_status_msg)),
        Err(err) => Ok(err.error_response()),
    })
}

pub fn get_status(
    status_id: web::Path<String>,
    state: web::Data<Addr<Oa>>,
    cfg: web::Data<config::Config>,
) -> impl Future<Item = HttpResponse, Error = Error> {
    state
        .send(GetStatus {
            id: status_id.to_string(),
            hostname: cfg.get::<String>("otemot.external_url").unwrap(),
        })
        .from_err()
        .and_then(|res| match res {
            Ok(status_msg) => Ok(HttpResponse::Ok().json(status_msg)),
            Err(err) => Ok(err.error_response()),
        })
}
