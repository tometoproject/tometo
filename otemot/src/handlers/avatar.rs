use actix::Handler;
use uuid::Uuid;
use crate::actor::Oa;
use crate::models::avatar::{CreateAvatar, NewAvatar, Avatar};
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
		
        if user.is_none() {
            return Err(ServiceError::Unauthorized);
        }

        let authed_user = user.unwrap();

        let existing_avatar = avatars
            .filter(user_id.eq(&authed_user.id))
            .load::<Avatar>(conn)
            .map_err(|_| ServiceError::InternalServerError)?
            .pop();
        
        if existing_avatar.is_some() {
            return Err(ServiceError::BadRequest(
                "You can't create more than one Avatar!".to_string(),
            ));
        }

        let new_id = Uuid::new_v4();
        let new_avatar = NewAvatar {
            id: &new_id.to_string(),
            user_id: authed_user.id,
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
