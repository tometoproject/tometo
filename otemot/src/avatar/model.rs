use crate::error::{new_ejson, OError};
use crate::schema::{avatars, users};
use crate::user::model::User;
use diesel::prelude::*;
use diesel::PgConnection;
use uuid::Uuid;

#[table_name = "avatars"]
#[derive(Debug, Serialize, Deserialize, Queryable, AsChangeset, Insertable)]
pub struct Avatar {
	pub id: String,
	pub user_id: i32,
	pub pitch: i16,
	pub speed: f32,
	pub language: String,
	pub gender: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct CreateAvatar {
	pub pitch: i16,
	pub speed: f32,
	pub language: String,
	pub gender: String,
}

impl Avatar {
	pub fn create(
		avatar: CreateAvatar,
		username: &str,
		connection: &PgConnection,
	) -> Result<String, OError> {
		let user = users::table
			.filter(users::username.eq(username))
			.first::<User>(connection)?;
		let existing_avatar = avatars::table
			.filter(avatars::user_id.eq(user.id))
			.first::<Avatar>(connection);
		if existing_avatar.is_ok() {
			return Err(OError::BadRequest(new_ejson(
				"You can only have one avatar!",
			)));
		}
		let new_id = Uuid::new_v4();
		let new_avatar = Avatar {
			id: new_id.to_string(),
			user_id: user.id,
			pitch: avatar.pitch,
			speed: avatar.speed,
			language: avatar.language,
			gender: avatar.gender,
		};

		diesel::insert_into(avatars::table)
			.values(&new_avatar)
			.execute(connection)?;
		Ok(new_id.to_string())
	}
}
