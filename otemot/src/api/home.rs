use crate::actor::Oa;
use actix::Addr;
use actix_web::web;

pub fn index(_state: web::Data<Addr<Oa>>) -> &'static str {
    "Hello World!"
}
