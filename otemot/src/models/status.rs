use crate::errors::ServiceError;
use crate::messages::{NewStatusMsg, StatusMsg};
use crate::schema::statuses;
use actix::Message;
use uuid::Uuid;

#[table_name = "statuses"]
#[derive(Clone, Debug, Serialize, Deserialize, PartialEq, Identifiable, Queryable)]
pub struct Status {
    pub id: String,
    pub content: String,
    pub pitch: i32,
    pub user_id: i32,
}

#[table_name = "statuses"]
#[derive(Debug, Serialize, Deserialize, Clone, Insertable)]
pub struct NewStatus<'a> {
    pub id: &'a str,
    pub content: &'a str,
    pub pitch: i32,
    pub user_id: i32,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct CreateStatusJson {
    pub content: String,
    pub pitch: i32,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct CreateStatus {
    pub content: String,
    pub pitch: i32,
    pub username: String,
}

impl CreateStatus {
    pub fn from_json(s: CreateStatusJson, username: String) -> Self {
        CreateStatus {
            content: s.content,
            pitch: s.pitch,
            username,
        }
    }
}

#[derive(Deserialize, Serialize, Debug)]
pub struct GetStatus {
    pub id: String,
    pub hostname: String,
}

impl Message for GetStatus {
    type Result = Result<StatusMsg, ServiceError>;
}

impl Message for CreateStatus {
    type Result = Result<NewStatusMsg, ServiceError>;
}

impl Default for Status {
    fn default() -> Self {
        Status {
            id: Uuid::new_v4().to_string(),
            content: "".to_string(),
            pitch: 0,
            user_id: 0,
        }
    }
}
