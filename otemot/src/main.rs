#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;
#[macro_use]
extern crate diesel;
#[macro_use]
extern crate serde_derive;

mod db;
mod schema;
mod user;
mod avatar;
mod status;
mod storage;

use rocket_contrib::serve::StaticFiles;
use rocket::http::Method;
use rocket::config::{Config as RocketConfig, Environment};
use rocket_cors::{CorsOptions, AllowedHeaders, AllowedOrigins};

#[get("/")]
fn index() -> &'static str {
	"Hello world!"
}

fn main() {
	let mut cfg = config::Config::default();
	cfg.merge(config::File::new("config.json", config::FileFormat::Json))
		.unwrap()
		.merge(config::Environment::new().separator("_"))
		.unwrap();

	let db_url = cfg
        .get::<String>("otemot.database_url")
        .expect("otemot.database_url unset!");
    cfg.get::<String>("otemot.storage")
        .expect("otemot.storage unset!");
    cfg.get::<String>("otemot.google_credentials")
        .expect("otemot.google_credentials unset!");
    let cookie_secret = cfg
        .get::<String>("otemot.secrets.cookie")
        .expect("otemot.secrets.cookie unset!");
    cfg.get::<String>("otemot.secrets.jwt")
        .expect("otemot.secrets.jwt unset!");
    let ot_hostname = cfg
        .get::<String>("otemot.hostname")
        .expect("otemot.hostname unset!");
			
			let port = cfg
        .get::<u16>("otemot.port")
        .expect("otemot.port unset!");
    cfg.get::<String>("otemot.external_url")
        .expect("otemot.external_url unset!");
    let tm_hostname = cfg
        .get::<String>("tometo.hostname")
        .expect("tometo.hostname unset!");
    let mut dsn = cfg.get::<String>("otemot.dsn").expect("otemot.dsn unset!");
    let c_environment = cfg.get::<String>("otemot.env").expect("otemot.env unset!");
		let environment;
		match c_environment.as_str() {
			"development" => environment = Environment::Development,
			"production" => environment = Environment::Production,
			"staging" => environment = Environment::Staging,
			_ => environment = Environment::Development,
		}
    if &dsn[0..3] != "http" {
        dsn = String::new();
    }

	let rocket_config = RocketConfig::build(environment)
		.address(ot_hostname)
		.port(port)
		.secret_key(cookie_secret)
		.finalize().unwrap();
	let cors = CorsOptions {
		allowed_origins: AllowedOrigins::some_exact(&[tm_hostname]),
		allowed_methods: vec![Method::Get, Method::Post, Method::Delete].into_iter().map(From::from).collect(),
		allowed_headers: AllowedHeaders::all(),
		allow_credentials: true,
		..Default::default()
	}
		.to_cors().unwrap();
	let mut rocket = rocket::custom(rocket_config)
		.manage(db::connect(db_url))
		.mount("/", routes![index])
		.mount("/storage", StaticFiles::from("otemot/storage"))
		.attach(cors);

	rocket = user::mount(rocket);
	rocket = avatar::mount(rocket);
	rocket = status::mount(rocket);

	rocket.launch();
}
