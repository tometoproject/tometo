use crate::error::OError;
use crate::storage::local::LocalStorage;
use crate::storage::s3::S3Storage;
use either::Either;
use std::path::PathBuf;

pub mod local;
pub mod s3;

pub trait Storage {
	fn get(&self, key: String) -> Result<String, OError>;
	fn put(&self, key: String, path: Either<PathBuf, Vec<u8>>) -> Result<bool, OError>;
	fn delete(&self, key: String) -> Result<bool, OError>;
}

pub fn create_storage(method: String) -> Box<(dyn Storage + 'static)> {
	match method.as_ref() {
		"s3" => Box::new(S3Storage::new()),
		"local" | _ => Box::new(LocalStorage::new()),
	}
}
