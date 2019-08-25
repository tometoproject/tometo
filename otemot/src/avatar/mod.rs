use crate::avatar::model::{Avatar, CreateAvatar};
use crate::db;
use crate::error::{new_ejson, OError};
use crate::storage::create_storage;
use crate::user::model::SlimUser;
use rocket::http::ContentType;
use rocket::Data;
use rocket_multipart_form_data::{
	MultipartFormData, MultipartFormDataField, MultipartFormDataOptions, RawField, TextField,
};

pub mod model;

#[post("/", data = "<data>")]
fn create_avatar(
	user: SlimUser,
	content_type: &ContentType,
	data: Data,
	connection: db::Connection,
) -> Result<String, OError> {
	let mut options = MultipartFormDataOptions::new();
	options
		.allowed_fields
		.push(MultipartFormDataField::text("pitch"));
	options
		.allowed_fields
		.push(MultipartFormDataField::text("speed"));
	options
		.allowed_fields
		.push(MultipartFormDataField::text("language"));
	options
		.allowed_fields
		.push(MultipartFormDataField::text("gender"));
	options
		.allowed_fields
		.push(MultipartFormDataField::raw("pic1").size_limit(1_000_000));
	options
		.allowed_fields
		.push(MultipartFormDataField::raw("pic2").size_limit(1_000_000));
	let formdata = MultipartFormData::parse(content_type, data, options).unwrap();
	let pitch = formdata.texts.get("pitch");
	let speed = formdata.texts.get("speed");
	let language = formdata.texts.get("language");
	let gender = formdata.texts.get("gender");
	let pic1 = formdata.raw.get("pic1");
	let pic2 = formdata.raw.get("pic2");
	if pitch.is_none()
		|| speed.is_none()
		|| language.is_none()
		|| gender.is_none()
		|| pic1.is_none()
		|| pic2.is_none()
	{
		return Err(OError::BadRequest(new_ejson(
			"Please fill out all of the fields!",
		)));
	}
	let single_lang = match language.unwrap() {
		TextField::Single(v) => v,
		TextField::Multiple(v) => v.first().unwrap(),
	};
	let single_pitch = match pitch.unwrap() {
		TextField::Single(v) => v,
		TextField::Multiple(v) => v.first().unwrap(),
	};
	let single_speed = match speed.unwrap() {
		TextField::Single(v) => v,
		TextField::Multiple(v) => v.first().unwrap(),
	};
	let single_gender = match gender.unwrap() {
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

	let avatar = CreateAvatar {
		pitch: single_pitch.text.parse::<i16>()?,
		speed: single_speed.text.parse::<f32>()?,
		language: single_lang.text.clone(),
		gender: single_gender.text.clone(),
	};
	let id = Avatar::create(avatar, &user.username, &connection)?;

	let mut cfg = config::Config::default();
	cfg.merge(config::File::new("config.toml", config::FileFormat::Toml))
		.unwrap()
		.merge(config::Environment::new().separator("_"))
		.unwrap();
	let storage = create_storage(cfg.get::<String>("otemot.storage").unwrap());
	storage.put(
		format!("{}-1.png", id),
		either::Either::Right(single_pic1.raw.clone()),
	)?;
	storage.put(
		format!("{}-2.png", id),
		either::Either::Right(single_pic2.raw.clone()),
	)?;
	Ok("Avatar successfully created!".into())
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket.mount("/api/avatar/new", routes![create_avatar])
}
