use crate::actor::Oa;
use crate::errors::ServiceError;
use crate::messages::NewResourceMsg;
use crate::models::avatar::{Avatar, CreateAvatar, NewAvatar};
use crate::models::user::User;
use actix::Handler;
use diesel::{ExpressionMethods, QueryDsl, RunQueryDsl};
use uuid::Uuid;

impl Handler<CreateAvatar> for Oa {
    type Result = Result<NewResourceMsg, ServiceError>;

    fn handle(&mut self, avatar: CreateAvatar, _: &mut Self::Context) -> Self::Result {
        use crate::schema::avatars::dsl::*;
        use crate::schema::users::dsl::{username, users};

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
