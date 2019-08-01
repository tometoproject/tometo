use crate::error::{new_ejson, OError};
use crate::storage::Storage;
use std::fs;
use std::path::PathBuf;

#[derive(Debug, Clone, Default)]
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

		let hostname = cfg.get::<String>("otemot.external_url").unwrap();
		LocalStorage { hostname }
	}
}

impl Storage for LocalStorage {
	fn get(&self, key: String) -> Result<String, OError> {
		let mut path = PathBuf::from("otemot/storage");
		path.push(&key);
		if !path.exists() {
			Err(OError::NotFound(new_ejson("File not found!")))
		} else {
			Ok(format!("{}/storage/{}", self.hostname, &key))
		}
	}

	fn put(&self, key: String, path: &PathBuf) -> Result<bool, OError> {
		if !path.exists() {
			return Ok(false);
		}

		let mut pb = PathBuf::from("otemot/storage");
		pb.push(&key);
		fs::rename(path, pb)?;
		Ok(true)
	}

	fn delete(&self, key: String) -> Result<bool, OError> {
		let mut path = PathBuf::from("otemot/storage");
		path.push(key);
		if !path.exists() {
			Ok(false)
		} else {
			fs::remove_file(path)?;
			Ok(true)
		}
	}
}
