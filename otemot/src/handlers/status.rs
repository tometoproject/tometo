use crate::actor::Oa;
use crate::errors::ServiceError;
use crate::messages::{NewStatusMsg, StatusMsg};
use crate::models::status::{CreateStatus, GetStatus, NewStatus, Status};
use crate::models::user::User;
use actix::Handler;
use diesel::{ExpressionMethods, QueryDsl, RunQueryDsl};
use sentry::capture_message;
use std::process::Command;
use uuid::Uuid;
use sensitive_words::words;

impl Handler<CreateStatus> for Oa {
    type Result = Result<NewStatusMsg, ServiceError>;

    fn handle(&mut self, status: CreateStatus, _: &mut Self::Context) -> Self::Result {
        use crate::schema::statuses::dsl::*;
        use crate::schema::users::dsl::*;

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
            ))
        }

        let conn = &self.0.get().unwrap();
        let user = users
            .filter(&username.eq(&status.username))
            .load::<User>(conn)
            .map_err(|_| ServiceError::InternalServerError)?
            .pop();

        let new_id = Uuid::new_v4();
        let conn = &self.0.get().unwrap();
        let command_out = Command::new("/usr/bin/env")
            .arg("node")
            .arg("otemot/tts.js")
            .arg(&status.content)
            .args(&["-p", &status.pitch.to_string()])
            .args(&["-s", "1.0"])
            .args(&["-n", &new_id.to_string()])
            .output()?;

        if !command_out.status.success() {
            capture_message(
                String::from_utf8(command_out.stderr).unwrap().as_str(),
                sentry::Level::Error,
            );
            return Err(ServiceError::InternalServerError);
        } else {
            dbg!(String::from_utf8(command_out.stdout).unwrap());
        }

        match user {
            None => Err(ServiceError::Unauthorized),
            Some(luser) => {
                let new_status = NewStatus {
                    id: &new_id.to_string(),
                    content: &status.content,
                    pitch: status.pitch,
                    user_id: luser.id,
                };
                diesel::insert_into(statuses)
                    .values(&new_status)
                    .execute(conn)
                    .map_err(|_| ServiceError::InternalServerError)?;

                Ok(NewStatusMsg {
                    status: 200,
                    id: Some(new_id),
                    message: None,
                })
            }
        }
    }
}

impl Handler<GetStatus> for Oa {
    type Result = Result<StatusMsg, ServiceError>;

    fn handle(&mut self, status: GetStatus, _: &mut Self::Context) -> Self::Result {
        use crate::schema::statuses::dsl::*;

        let conn = &self.0.get().unwrap();
        let status_result = statuses
            .filter(&id.eq(&status.id))
            .load::<Status>(conn)
            .map_err(|_| ServiceError::InternalServerError)?
            .pop();

        if status_result.is_none() {
            return Err(ServiceError::NotFound("No status found!".to_string()));
        }

        let hostname = ::std::env::var("OT_HOSTNAME").expect("OT_HOSTNAME must be set!");
        Ok(StatusMsg {
            status: 200,
            audio: format!("{}/storage/{}.mp3", &hostname, &status.id),
            content: status_result.unwrap().content,
            timestamps: format!("{}/storage/{}.json", &hostname, &status.id),
        })
    }
}

fn check_for_bad_words(message: &str) -> bool {
    let words = words();
    message.split(' ').any(move |w| words.contains(&w.to_string()))
}
