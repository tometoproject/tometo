use crate::error::OError;
use crate::storage::local::LocalStorage;
use std::path::PathBuf;

pub mod local;

pub trait Storage {
	fn get(&self, key: String) -> Result<String, OError>;
	fn put(&self, key: String, path: &PathBuf) -> Result<bool, OError>;
	fn delete(&self, key: String) -> Result<bool, OError>;
}

pub fn create_storage(method: String) -> impl Storage {
	match method.as_ref() {
		"local" | _ => LocalStorage::new(),
	}
}
