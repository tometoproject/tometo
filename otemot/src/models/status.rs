use crate::errors::ServiceError;
use crate::messages::{NewResourceMsg, StatusMsg};
use crate::schema::statuses;
use actix::Message;
use uuid::Uuid;

#[table_name = "statuses"]
#[derive(Clone, Debug, Serialize, Deserialize, PartialEq, Identifiable, Queryable)]
pub struct Status {
    pub id: String,
    pub content: String,
    pub avatar_id: String,
    pub related_status_id: Option<String>,
}

#[table_name = "statuses"]
#[derive(Debug, Serialize, Deserialize, Clone, Insertable)]
pub struct NewStatus<'a> {
    pub id: &'a str,
    pub content: &'a str,
    pub avatar_id: &'a str,
    pub related_status_id: Option<&'a str>,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct CreateStatusJson {
    pub content: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct CreateStatus {
    pub content: String,
    pub username: String,
}

impl CreateStatus {
    pub fn from_json(s: CreateStatusJson, username: String) -> Self {
        CreateStatus {
            content: s.content,
            username
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
    type Result = Result<NewResourceMsg, ServiceError>;
}

impl Default for Status {
    fn default() -> Self {
        Status {
            id: Uuid::new_v4().to_string(),
            content: "".to_string(),
            avatar_id: "".to_string(),
            related_status_id: None,
        }
    }
}
