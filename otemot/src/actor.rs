use actix::{Actor, SyncContext};
use diesel::pg::PgConnection;
use diesel::r2d2::{ConnectionManager, Pool};

pub struct Oa(pub Pool<ConnectionManager<PgConnection>>);

impl Actor for Oa {
    type Context = SyncContext<Self>;
}
