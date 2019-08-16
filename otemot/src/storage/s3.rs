use crate::error::{new_ejson, OError};
use crate::storage::Storage;
use either::Either;
use futures::Future;
use rusoto_core::Region;
use rusoto_s3::{DeleteObjectRequest, PutObjectRequest, S3Client, S3};
use std::fs::File;
use std::io::Read;
use std::path::PathBuf;

#[derive(Clone)]
pub struct S3Storage {
	client: S3Client,
}

impl S3Storage {
	pub fn new() -> Self {
		let region = Region::Custom {
			name: String::from("fr-par"),
			endpoint: String::from("https://s3.fr-par.scw.cloud"),
		};
		let client = S3Client::new(region);
		S3Storage { client }
	}
}

impl Storage for S3Storage {
	fn get(&self, key: String) -> Result<String, OError> {
		// FIXME: substitute this with config variables
		Ok(format!("https://tometo-test.s3.fr-par.scw.cloud/{}", key))
	}

	fn put(&self, key: String, upload: Either<PathBuf, Vec<u8>>) -> Result<bool, OError> {
		let request;
		match upload {
			Either::Left(path) => {
				let mut body: Vec<u8> = vec![];
				let mut file = File::open(path)?;
				file.read_to_end(&mut body)?;
				request = PutObjectRequest {
					// FIXME: substitute this with config variables
					bucket: String::from("tometo-test"),
					acl: Some("public-read".into()),
					key,
					body: Some(body.into()),
					..Default::default()
				};
			}
			Either::Right(bytes) => {
				let body = bytes.to_owned();
				request = PutObjectRequest {
					// FIXME: substitute this with config variables
					bucket: String::from("tometo-test"),
					acl: Some("public-read".into()),
					key,
					body: Some(body.into()),
					..Default::default()
				};
			}
		}
		self.client
			.put_object(request).sync()
			.map_err(|_e| OError::InternalServerError(new_ejson(format!("Upload error: {:?}", _e).as_ref())))?;
		Ok(true)
	}

	fn delete(&self, key: String) -> Result<bool, OError> {
		let opt = DeleteObjectRequest {
			// FIXME: substitute this with config variables
			bucket: String::from("tometo-test"),
			key,
			..Default::default()
		};
		self.client
			.delete_object(opt)
			.map_err(|_e| OError::InternalServerError(new_ejson(format!("Upload error: {:?}", _e).as_ref())))
			.wait()?;
		Ok(true)
	}
}
