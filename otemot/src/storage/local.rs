use crate::storage::Storage;
use std::fs;
use std::path::PathBuf;
use rocket::http::Status;

#[derive(Debug, Clone)]
pub struct LocalStorage {
    hostname: String,
}

impl LocalStorage {
    pub fn new() -> Self {
        let mut cfg = config::Config::default();
        cfg.merge(config::File::new("config.json", config::FileFormat::Json))
            .unwrap()
            .merge(config::Environment::new().separator("_"))
            .unwrap();

        let protocol = cfg.get::<String>("otemot.local_storage.protocol").unwrap();
        let hostname = cfg.get::<String>("otemot.hostname").unwrap();
        LocalStorage { hostname: format!("{}://{}", protocol, hostname) }
    }
}

impl Storage for LocalStorage {
    fn get(&self, key: String) -> Result<String, Status> {
        let mut path = PathBuf::from("otemot/storage");
        path.push(&key);
        if !path.exists() {
            Err(Status::NotFound)
        } else {
            Ok(format!("{}/storage/{}", self.hostname, &key))
        }
    }

    fn put(&self, key: String, path: &PathBuf) -> Result<bool, Status> {
        if !path.exists() {
            return Ok(false);
        }

        let mut pb = PathBuf::from("otemot/storage");
        pb.push(&key);
        fs::rename(path, pb).map_err(|_| Status::InternalServerError)?;
        Ok(true)
    }

    fn delete(&self, key: String) -> Result<bool, Status> {
        let mut path = PathBuf::from("otemot/storage");
        path.push(key);
        if !path.exists() {
            Ok(false)
        } else {
            fs::remove_file(path).map_err(|_| Status::InternalServerError)?;
            Ok(true)
        }
    }
}
