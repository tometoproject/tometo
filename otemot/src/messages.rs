use uuid::Uuid;

#[derive(Deserialize, Serialize, Debug)]
pub struct DefaultMsg {
    pub status: u16,
    pub message: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct LoginMsg {
    pub status: u16,
    pub username: String,
    pub message: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct NewResourceMsg {
    pub status: u16,
    pub id: Option<Uuid>,
    pub message: Option<String>,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct StatusMsg {
    pub status: u16,
    pub audio: String,
    pub content: String,
    pub timestamps: String,
}
