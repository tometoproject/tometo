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

fn main() {
    print!("Loading configuration file... ");
    let mut cfg = config::Config::default();
    cfg
        .merge(config::File::new("config.json", config::FileFormat::Json)).unwrap()
        .merge(config::Environment::new().separator("_")).unwrap();
    ::std::env::set_var("RUST_LOG", "actix_web=info");
    env_logger::init();
    println!("OK");

    print!("Ensuring configuration key completeness...");
    let database_url = cfg.get::<String>("otemot.database_url").expect("otemot.database_url unset!");
    let port = cfg.get::<i32>("otemot.port").expect("otemot.port unset!");
    cfg.get::<String>("otemot.storage").expect("otemot.storage unset!");
    cfg.get::<String>("otemot.google_credentials").expect("otemot.google_credentials unset!");
    let cookie_secret = cfg.get::<String>("otemot.secrets.cookie").expect("otemot.secrets.cookie unset!");
    cfg.get::<String>("otemot.secrets.jwt").expect("otemot.secrets.jwt unset!");
    let ot_hostname = cfg.get::<String>("otemot.hostname").expect("otemot.hostname unset!");
    let tm_hostname = cfg.get::<String>("tometo.hostname").expect("tometo.hostname unset!");
    let mut dsn = cfg.get::<String>("otemot.dsn").expect("otemot.dsn unset!");
    let environment = cfg.get::<String>("otemot.env").expect("otemot.env unset!");
    if &dsn[0..3] != "http" {
        dsn = String::new();
    }
    let is_development = environment == "development";
    println!("OK");

    print!("Initializing Sentry...");
    let _guard = sentry::init((
        dsn,
        sentry::ClientOptions {
            environment: Some(environment.into()),
            ..Default::default()
        },
    ));
    sentry::integrations::panic::register_panic_handler();
    println!("OK");

    let sys = actix_rt::System::new("otemot");

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
            .data(cfg.clone())
            .wrap(
                Cors::new()
                    .allowed_origin(tm_hostname.as_ref())
                    .allowed_methods(vec!["GET", "POST", "DELETE"])
                    .supports_credentials(),
            )
            .wrap(Logger::default())
            .service(web::resource("/").route(web::get().to(home::index)))
            .wrap(IdentityService::new(
                CookieIdentityPolicy::new(cookie_secret.as_bytes())
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
            .service(Files::new("/storage", "./otemot/storage"))
    })
    .bind(format!("127.0.0.1:{}", &ot_hostname.chars().rev().take(4).collect::<String>()))
    .unwrap()
    .start();
    println!("OK");
    println!("Running at {}", ot_hostname);

    sys.run().unwrap();
}
