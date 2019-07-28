use crate::storage::local::LocalStorage;
use rocket::http::Status;
use std::path::PathBuf;

pub mod local;

pub trait Storage {
	fn get(&self, key: String) -> Result<String, Status>;
	fn put(&self, key: String, path: &PathBuf) -> Result<bool, Status>;
	fn delete(&self, key: String) -> Result<bool, Status>;
}

pub fn create_storage(method: String) -> impl Storage {
	match method.as_ref() {
		"local" | _ => LocalStorage::new(),
	}
}
