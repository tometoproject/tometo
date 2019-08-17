use crate::avatar::model::{Avatar, CreateAvatar};
use crate::db;
use crate::error::{new_ejson, OError};
use crate::storage::create_storage;
use crate::user::model::SlimUser;
use rocket::http::ContentType;
use rocket::Data;
use rocket_contrib::json::Json;
use rocket_multipart_form_data::{
	MultipartFormData, MultipartFormDataField, MultipartFormDataOptions, RawField, TextField,
};

pub mod model;

#[post("/", data = "<avatar>")]
fn create_avatar(
	user: SlimUser,
	avatar: Json<CreateAvatar>,
	connection: db::Connection,
) -> Result<String, OError> {
	let avatar = avatar.into_inner();

	Avatar::create(avatar, &user.username, &connection)?;

	Ok("Successfully created Avatar!".to_string())
}

#[post("/upload", data = "<data>")]
fn upload_avatar_pictures(content_type: &ContentType, data: Data) -> Result<String, OError> {
	let mut options = MultipartFormDataOptions::new();
	options
		.allowed_fields
		.push(MultipartFormDataField::text("id"));
	options
		.allowed_fields
		.push(MultipartFormDataField::raw("pic1").size_limit(1_000_000));
	options
		.allowed_fields
		.push(MultipartFormDataField::raw("pic2").size_limit(1_000_000));
	let formdata = MultipartFormData::parse(content_type, data, options).unwrap();
	let id = formdata.texts.get("id");
	let pic1 = formdata.raw.get("pic1");
	let pic2 = formdata.raw.get("pic2");
	if id.is_none() || pic1.is_none() || pic2.is_none() {
		return Err(OError::BadRequest(new_ejson(
			"Please fill out all of the fields!",
		)));
	}
	let single_id = match id.unwrap() {
		TextField::Single(v) => v,
		TextField::Multiple(v) => v.first().unwrap(),
	};
	let single_pic1 = match pic1.unwrap() {
		RawField::Single(v) => v,
		RawField::Multiple(v) => v.first().unwrap(),
	};
	let single_pic2 = match pic2.unwrap() {
		RawField::Single(v) => v,
		RawField::Multiple(v) => v.first().unwrap(),
	};
	let mut cfg = config::Config::default();
	cfg.merge(config::File::new("config.json", config::FileFormat::Json))
		.unwrap()
		.merge(config::Environment::new().separator("_"))
		.unwrap();
	let storage = create_storage(cfg.get::<String>("otemot.storage").unwrap());
	storage.put(
		format!("{}-1.png", single_id.text),
		either::Either::Right(single_pic1.raw.clone()),
	)?;
	storage.put(
		format!("{}-2.png", single_id.text),
		either::Either::Right(single_pic2.raw.clone()),
	)?;
	Ok("Successfully uploaded images!".into())
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket.mount(
		"/api/avatar/new",
		routes![create_avatar, upload_avatar_pictures],
	)
}
