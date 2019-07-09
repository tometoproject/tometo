#![warn(clippy::all)]
#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate diesel;

mod actor;
mod api;
mod errors;
mod handlers;
mod messages;
mod models;
mod schema;
mod token;

use crate::actor::Oa;
use crate::api::{auth, home, status};
use actix::prelude::*;
use actix_cors::Cors;
use actix_files::Files;
use actix_identity::{CookieIdentityPolicy, IdentityService};
use actix_web::{middleware::Logger, web, App, HttpServer};
use diesel::{r2d2::ConnectionManager, PgConnection};
use std::env;

fn main() {
    print!("Checking environment variables... ");
    ::std::env::set_var("RUST_LOG", "actix_web=info");
    env_logger::init();
    dotenv::from_path("./otemot/.env").ok();
    let sys = actix_rt::System::new("otemot");
    let database_url = std::env::var("DATABASE_URL").expect("DATABASE_URL must be set!");
    let port = env::var("PORT").expect("PORT must be set!");
    let dsn = env::var("SENTRY_DSN").expect("SENTRY_DSN must be set!");
    let environment = env::var("RUST_ENV").expect("RUST_ENV must be set!");
    let is_development = environment == "development";
    let secret = env::var("COOKIE_SECRET").expect("COOKIE_SECRET must be set!");
    env::var("JWT_SECRET").expect("JWT_SECRET must be set!");
    let ot_hostname = env::var("OT_HOSTNAME").expect("OT_HOSTNAME must be set!");
    let tm_hostname = env::var("TM_HOSTNAME").expect("TM_HOSTNAME must be set!");
    let _guard = sentry::init((
        dsn,
        sentry::ClientOptions {
            environment: Some(environment.into()),
            ..Default::default()
        },
    ));
    sentry::integrations::panic::register_panic_handler();
    println!("OK");

    print!("Initializing database connection... ");
    let manager = ConnectionManager::<PgConnection>::new(database_url);
    let pool = r2d2::Pool::builder()
        .build(manager)
        .expect("Failed to create pool!");
    println!("OK");

    let address: Addr<Oa> = SyncArbiter::start(4, move || Oa(pool.clone()));

    print!("Constructing HTTP server... ");
    HttpServer::new(move || {
        App::new()
            .data(address.clone())
            .wrap(
                Cors::new()
                    .allowed_origin(tm_hostname.as_ref())
                    .allowed_methods(vec!["GET", "POST", "DELETE"])
                    .supports_credentials(),
            )
            .wrap(Logger::default())
            .service(web::resource("/").route(web::get().to(home::index)))
            .wrap(IdentityService::new(
                CookieIdentityPolicy::new(secret.as_bytes())
                    .name("auth")
                    .path("/")
                    .secure(!is_development),
            ))
            .service(
                web::scope("/api")
                    .service(
                        web::resource("/auth")
                            .route(web::post().to_async(auth::signin))
                            .route(web::delete().to(auth::logout))
                            .route(web::get().to_async(auth::get_user)),
                    )
                    .service(web::resource("/register").route(web::post().to_async(auth::signup)))
                    .service(
                        web::resource("/status/new")
                            .route(web::post().to_async(status::create_status)),
                    )
                    .service(
                        web::resource("/status/{status_id}")
                            .route(web::get().to_async(status::get_status)),
                    ),
            )
            .service(Files::new("/storage", "./storage"))
    })
    .bind(format!("127.0.0.1:{}", port))
    .unwrap()
    .start();
    println!("OK");
    println!("Running at {}", ot_hostname);

    sys.run().unwrap();
}
