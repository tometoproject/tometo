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
		.expect("otemot.database_url is unset!");

	let mut rocket = rocket::ignite()
		.manage(db::connect(db_url))
		.mount("/", routes![index])
		.mount("/storage", StaticFiles::from("otemot/storage"));

	rocket = user::mount(rocket);
	rocket = avatar::mount(rocket);
	rocket = status::mount(rocket);

	rocket.launch();
}
