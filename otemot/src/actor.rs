use actix::{Actor, SyncContext};
use diesel::pg::PgConnection;
use diesel::r2d2::{ConnectionManager, Pool};

pub struct Oa(pub Pool<ConnectionManager<PgConnection>>);

pub type Conn<'a> = &'a r2d2::PooledConnection<diesel::r2d2::ConnectionManager<diesel::PgConnection>>;

impl Actor for Oa {
    type Context = SyncContext<Self>;
}
