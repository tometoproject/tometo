use uuid::Uuid;
use crate::schema::avatars;
use crate::errors::ServiceError;
use crate::messages::NewResourceMsg;
use actix::Message;

#[table_name = "avatars"]
#[derive(Clone, Debug, Serialize, Deserialize, PartialEq, Identifiable, Queryable)]
pub struct Avatar {
	pub id: String,
	pub user_id: i32,
	pub pitch: i16,
	pub speed: f32,
	pub language: String,
	pub gender: String,
}

#[table_name = "avatars"]
#[derive(Debug, Serialize, Deserialize, Clone, Insertable)]
pub struct NewAvatar<'a> {
	pub id: &'a str,
	pub user_id: i32,
	pub pitch: i16,
	pub speed: f32,
	pub language: &'a str,
	pub gender: &'a str,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct CreateAvatarJson {
	pub pitch: i16,
	pub speed: f32,
	pub language: String,
	pub gender: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct CreateAvatar {
	pub pitch: i16,
	pub speed: f32,
	pub language: String,
	pub gender: String,
	pub username: String,
}

impl CreateAvatar {
	pub fn from_json(a: CreateAvatarJson, username: String) -> Self {
		CreateAvatar {
			username,
			pitch: a.pitch,
			speed: a.speed,
			language: a.language,
			gender: a.gender,
		}
	}
}

impl Message for CreateAvatar {
	type Result = Result<NewResourceMsg, ServiceError>;
}

impl Default for Avatar {
	fn default() -> Self {
		Avatar {
			id: Uuid::new_v4().to_string(),
			user_id: 0,
			pitch: 10,
			speed: 1.0,
			language: String::from("en-US"),
			gender: String::from("f"),
		}
	}
}
