use crate::actor::{Oa, Conn};
use crate::errors::ServiceError;
use crate::messages::{NewResourceMsg, StatusMsg};
use crate::models::status::{CreateStatus, GetStatus, NewStatus, Status};
use crate::models::avatar::Avatar;
use crate::models::user::User;
use actix::Handler;
use diesel::{ExpressionMethods, QueryDsl, RunQueryDsl};
use sensitive_words::words;
use std::process::Command;
use uuid::Uuid;

impl Handler<CreateStatus> for Oa {
    type Result = Result<NewResourceMsg, ServiceError>;

    fn handle(&mut self, status: CreateStatus, _: &mut Self::Context) -> Self::Result {
        use crate::schema::users::dsl::{username, users};
        use crate::schema::avatars::dsl::{avatars, user_id};

        if status.content.is_empty() {
            return Err(ServiceError::BadRequest(
                "Please enter a message!".to_string(),
            ));
        }

        if status.content.len() > 500 {
            return Err(ServiceError::BadRequest(
                "Statuses can only be up to 500 characters!".to_string(),
            ));
        }

        if check_for_bad_words(&status.content) {
            return Err(ServiceError::BadRequest(
                "Please refrain from using this language in your statuses.".to_string(),
            ));
        }

        let conn = &self.0.get().unwrap();
        let user = users
            .filter(username.eq(&status.username))
            .load::<User>(conn)
            .map_err(|_| ServiceError::InternalServerError)?
            .pop();
        
        if let Some(authed_user) = user {
            let avatar = avatars
                .filter(user_id.eq(&authed_user.id))
                .load::<Avatar>(conn)
                .map_err(|_| ServiceError::InternalServerError)?
                .pop();
            
            if avatar.is_none() {
                return Err(ServiceError::BadRequest(
                    "Please create an Avatar first!".to_string(),
                ));
            }
            
            let res = genstatus(status.content, avatar.unwrap(), &conn)?;
            Ok(NewResourceMsg {
                status: 200,
                id: Some(res),
                message: None,
            })
        } else {
            Err(ServiceError::Unauthorized)
        }
    }
}

fn genstatus(content: String, avatar: Avatar, conn: Conn) -> Result<Uuid, ServiceError> {
    use crate::schema::statuses::dsl::statuses;

    let new_id = Uuid::new_v4();
    let command_out = Command::new("/usr/bin/env")
        .arg("node")
        .arg("otemot/tts.js")
        .arg(&content)
        .args(&["-p", &avatar.pitch.to_string()])
        .args(&["-s", &avatar.speed.to_string()])
        .args(&["-n", &new_id.to_string()])
        .output()?;

    if !command_out.status.success() {
        return Err(ServiceError::InternalServerError);
    }

    let new_status = NewStatus {
        id: &new_id.to_string(),
        content: &content,
        avatar_id: &avatar.id,
        related_status_id: None,
    };

    diesel::insert_into(statuses)
        .values(&new_status)
        .execute(conn)
        .map_err(|_| ServiceError::InternalServerError)?;

    Ok(new_id)
}

impl Handler<GetStatus> for Oa {
    type Result = Result<StatusMsg, ServiceError>;

    fn handle(&mut self, status: GetStatus, _: &mut Self::Context) -> Self::Result {
        use crate::schema::statuses::dsl::*;

        let conn = &self.0.get().unwrap();
        let status_result = statuses
            .filter(id.eq(&status.id))
            .load::<Status>(conn)
            .map_err(|_| ServiceError::InternalServerError)?
            .pop();

        if status_result.is_none() {
            return Err(ServiceError::NotFound("No status found!".to_string()));
        }

        Ok(StatusMsg {
            status: 200,
            audio: format!("{}/storage/{}.mp3", &status.hostname, &status.id),
            content: status_result.unwrap().content,
            timestamps: format!("{}/storage/{}.json", &status.hostname, &status.id),
        })
    }
}

fn check_for_bad_words(message: &str) -> bool {
    let words = words();
    message
        .split(' ')
        .any(move |w| words.contains(&w.to_string()))
}
