#![feature(proc_macro_hygiene, decl_macro, async_await)]
#![warn(clippy::all)]

#[macro_use]
extern crate rocket;
#[macro_use]
extern crate diesel;
#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate log;

mod avatar;
mod db;
mod error;
mod schema;
mod status;
mod storage;
mod user;

use crate::error::ErrorJson;
use rocket::config::{Config as RocketConfig, Environment};
use rocket::http::Method;
use rocket_contrib::json::Json;
use rocket_contrib::serve::StaticFiles;
use rocket_cors::{AllowedHeaders, AllowedOrigins, CorsOptions};

#[get("/")]
fn index() -> &'static str {
	"Hello world!"
}

fn main() {
	let _ = env_logger::try_init();
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

	let port = cfg.get::<u16>("otemot.port").expect("otemot.port unset!");
	cfg.get::<String>("otemot.external_url")
		.expect("otemot.external_url unset!");
	let tm_hostname = cfg
		.get::<String>("tometo.hostname")
		.expect("tometo.hostname unset!");
	let c_environment = cfg.get::<String>("otemot.env").expect("otemot.env unset!");
	let environment;
	match c_environment.as_str() {
		"development" => environment = Environment::Development,
		"production" => environment = Environment::Production,
		"staging" => environment = Environment::Staging,
		_ => environment = Environment::Development,
	}

	let rocket_config = RocketConfig::build(environment)
		.address(ot_hostname)
		.port(port)
		.secret_key(cookie_secret)
		.finalize()
		.unwrap();
	let cors = CorsOptions {
		allowed_origins: AllowedOrigins::some_exact(&[tm_hostname]),
		allowed_methods: vec![Method::Get, Method::Post, Method::Delete]
			.into_iter()
			.map(From::from)
			.collect(),
		allowed_headers: AllowedHeaders::all(),
		allow_credentials: true,
		..Default::default()
	}
	.to_cors()
	.unwrap();
	let mut rocket = rocket::custom(rocket_config)
		.manage(db::connect(db_url))
		.mount("/", routes![index])
		.mount("/storage", StaticFiles::from("otemot/storage"))
		.attach(cors);

	#[catch(401)]
	fn unauthorized() -> Json<ErrorJson> {
		Json(ErrorJson {
			message: String::from("Please log out and log in again!"),
		})
	}

	#[catch(404)]
	fn not_found() -> Json<ErrorJson> {
		Json(ErrorJson {
			message: String::from("Not found!"),
		})
	}

	#[catch(500)]
	fn server_error() -> Json<ErrorJson> {
		Json(ErrorJson {
			message: String::from("Internal server error."),
		})
	}

	rocket = user::mount(rocket);
	rocket = avatar::mount(rocket);
	rocket = status::mount(rocket);
	rocket
		.register(catchers![not_found, server_error, unauthorized])
		.launch();
}
