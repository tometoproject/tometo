use crate::errors::ServiceError;
use crate::storage::local::LocalStorage;
use std::path::PathBuf;

pub mod local;

pub trait Storage {
    fn get(&self, key: String) -> Result<String, ServiceError>;
    fn put(&self, key: String, path: &PathBuf) -> Result<bool, ServiceError>;
    fn delete(&self, key: String) -> Result<bool, ServiceError>;
}

pub fn create_storage(method: String) -> impl Storage {
    match method.as_ref() {
        "local" | _ => LocalStorage::new(),
    }
}
