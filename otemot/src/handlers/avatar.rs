use actix::Handler;
use uuid::Uuid;
use crate::actor::Oa;
use crate::models::avatar::{CreateAvatar, NewAvatar};
use crate::messages::NewResourceMsg;
use crate::errors::ServiceError;
use crate::models::user::User;
use diesel::{QueryDsl, RunQueryDsl, ExpressionMethods};

impl Handler<CreateAvatar> for Oa {
	type Result = Result<NewResourceMsg, ServiceError>;

	fn handle(&mut self, avatar: CreateAvatar, _: &mut Self::Context) -> Self::Result {
		use crate::schema::avatars::dsl::*;
		use crate::schema::users::dsl::{users, username};

		let conn = &self.0.get().unwrap();
		let user = users
			.filter(username.eq(&avatar.username))
			.load::<User>(conn)
			.map_err(|_| ServiceError::InternalServerError)?
			.pop();
		
		match user {
			None => Err(ServiceError::Unauthorized),
			Some(u) => {
				let new_id = Uuid::new_v4();
				let new_avatar = NewAvatar {
					id: &new_id.to_string(),
					user_id: u.id,
					pitch: avatar.pitch,
					speed: avatar.speed,
					language: &avatar.language,
					gender: &avatar.gender,
				};

				diesel::insert_into(avatars)
					.values(&new_avatar)
					.execute(conn)
					.map_err(|_| ServiceError::InternalServerError)?;
				
				Ok(NewResourceMsg {
					status: 200,
					id: Some(new_id),
					message: None,
				})
			}
		}
	}
}
