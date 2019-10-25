use crate::avatar::model::Avatar;
use crate::error::{new_ejson, OError};
use crate::schema::{avatars, statuses, users};
use crate::storage::create_storage;
use crate::user::model::User;
use diesel::prelude::*;
use either::Either;
use std::fs;
use std::path::PathBuf;
use std::process::Command;
use uuid::Uuid;

#[table_name = "statuses"]
#[derive(Debug, Serialize, Deserialize, Queryable, Insertable, AsChangeset)]
pub struct Status {
	pub id: String,
	pub content: String,
	pub avatar_id: String,
	pub related_status_id: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CreateStatus {
	pub content: String,
	pub id: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GetStatus {
	pub id: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GetStatusResponse {
	pub avatar_name: String,
	pub audio: String,
	pub timestamps: String,
	pub pic1: String,
	pub pic2: String,
}

impl Status {
	pub fn create(
		status: CreateStatus,
		username: &str,
		connection: &PgConnection,
	) -> Result<Uuid, OError> {
		let user = users::table
			.filter(users::username.eq(username))
			.first::<User>(connection)?;
		let avatar = avatars::table
			.filter(avatars::user_id.eq(user.id))
			.first::<Avatar>(connection)
			.map_err(|_| OError::BadRequest(new_ejson("Create an avatar first!")))?;
		let res = genstatus(status.content, status.id, avatar, connection)?;
		Ok(res)
	}

	pub fn get(status: GetStatus, connection: &PgConnection) -> Result<GetStatusResponse, OError> {
		let status = statuses::table
			.filter(statuses::id.eq(status.id))
			.first::<Status>(connection)?;
		let avatar = avatars::table
			.filter(avatars::id.eq(&status.avatar_id))
			.first::<Avatar>(connection)?;
		let mut cfg = config::Config::default();
		cfg.merge(config::File::new("config.toml", config::FileFormat::Toml))
			.unwrap()
			.merge(config::Environment::new().separator("_"))
			.unwrap();
		let storage = create_storage(cfg.get::<String>("otemot.storage").unwrap());
		let audio_path = storage.get(format!("{}.ogg", &status.id))?;
		let timestamps_path = storage.get(format!("{}.json", &status.id))?;
		let pic1_path = storage.get(format!("{}-1.png", &status.avatar_id))?;
		let pic2_path = storage.get(format!("{}-2.png", &status.avatar_id))?;
		Ok(GetStatusResponse {
			audio: audio_path,
			timestamps: timestamps_path,
			avatar_name: avatar.name,
			pic1: pic1_path,
			pic2: pic2_path,
		})
	}

	pub fn get_comments(status: GetStatus, connection: &PgConnection) -> Result<Vec<GetStatusResponse>, OError> {
		let mut result = Vec::new();
		let status_comments = statuses::table
			.filter(statuses::related_status_id.eq(status.id))
			.load::<Status>(connection)?;
		let mut cfg = config::Config::default();
		cfg.merge(config::File::new("config.toml", config::FileFormat::Toml))
			 .unwrap()
			 .merge(config::Environment::new().separator("_"))
			 .unwrap();
		let storage = create_storage(cfg.get::<String>("otemot.storage").unwrap());
		for status in status_comments {
			let avatar = avatars::table
				.filter(avatars::id.eq(&status.avatar_id))
				.first::<Avatar>(connection)?;
			let audio_path = storage.get(format!("{}.ogg", &status.id))?;
			let timestamps_path = storage.get(format!("{}.json", &status.id))?;
			let pic1_path = storage.get(format!("{}-1.png", &status.avatar_id))?;
			let pic2_path = storage.get(format!("{}-2.png", &status.avatar_id))?;
			result.push(GetStatusResponse {
				audio: audio_path,
				timestamps: timestamps_path,
				avatar_name: avatar.name,
				pic1: pic1_path,
				pic2: pic2_path,
			});
		}
		Ok(result)
	}
}

fn genstatus(content: String, id: Option<String>, avatar: Avatar, conn: &PgConnection) -> Result<Uuid, OError> {
	let mut cfg = config::Config::default();
	cfg.merge(config::File::new("config.toml", config::FileFormat::Toml))
		.unwrap()
		.merge(config::Environment::new().separator("_"))
		.unwrap();
	let storage = create_storage(cfg.get::<String>("otemot.storage").unwrap());
	let new_id = Uuid::new_v4();
	Command::new("/usr/bin/env")
		.arg("node")
		.arg("otemot/tts.js")
		.arg(&content)
		.args(&["-p", &avatar.pitch.to_string()])
		.args(&["-s", &avatar.speed.to_string()])
		.args(&["-n", &new_id.to_string()])
		.output()?;

	let mut pbuf = PathBuf::from("otemot/gentts");
	pbuf.push(&new_id.to_string());
	let mut audio_path = PathBuf::from(&pbuf);
	audio_path.push("temp.ogg");
	let mut text_path = PathBuf::from(&pbuf);
	text_path.push("out.json");
	storage.put(
		format!("{}.ogg", new_id.to_string()),
		Either::Left(audio_path),
	)?;
	storage.put(
		format!("{}.json", new_id.to_string()),
		Either::Left(text_path),
	)?;

	let new_status = Status {
		id: new_id.to_string(),
		content,
		avatar_id: avatar.id,
		related_status_id: id,
	};

	diesel::insert_into(statuses::table)
		.values(&new_status)
		.execute(conn)?;

	fs::remove_dir_all(&pbuf)?;

	Ok(new_id)
}
