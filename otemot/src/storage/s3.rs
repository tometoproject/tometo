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
	config: config::Config,
}

impl S3Storage {
	pub fn new() -> Self {
		let mut cfg = config::Config::default();
		cfg.merge(config::File::new("config.json", config::FileFormat::Json))
			.unwrap()
			.merge(config::Environment::new().separator("_"))
			.unwrap();
		let region = Region::Custom {
			name: cfg
				.get::<String>("otemot.s3_storage.endpoint.name")
				.unwrap(),
			endpoint: cfg.get::<String>("otemot.s3_storage.endpoint.url").unwrap(),
		};
		let client = S3Client::new(region);
		S3Storage {
			client,
			config: cfg,
		}
	}
}

impl Storage for S3Storage {
	fn get(&self, key: String) -> Result<String, OError> {
		let bucket = self.config.get::<String>("otemot.s3_storage.bucket")?;
		let endpoint = self
			.config
			.get::<String>("otemot.s3_storage.endpoint.url")?;
		Ok(format!("https://{}.{}/{}", bucket, endpoint, key))
	}

	fn put(&self, key: String, upload: Either<PathBuf, Vec<u8>>) -> Result<bool, OError> {
		let request;
		let bucket = self.config.get::<String>("otemot.s3_storage.bucket")?;
		match upload {
			Either::Left(path) => {
				let mut body: Vec<u8> = vec![];
				let mut file = File::open(path)?;
				file.read_to_end(&mut body)?;
				request = PutObjectRequest {
					bucket,
					acl: Some("public-read".into()),
					key,
					body: Some(body.into()),
					..Default::default()
				};
			}
			Either::Right(bytes) => {
				let body = bytes.to_owned();
				request = PutObjectRequest {
					bucket,
					acl: Some("public-read".into()),
					key,
					body: Some(body.into()),
					..Default::default()
				};
			}
		}
		self.client.put_object(request).sync().map_err(|_e| {
			OError::InternalServerError(new_ejson(format!("Upload error: {:?}", _e).as_ref()))
		})?;
		Ok(true)
	}

	fn delete(&self, key: String) -> Result<bool, OError> {
		let bucket = self.config.get::<String>("otemot.s3_storage.bucket")?;
		let opt = DeleteObjectRequest {
			bucket,
			key,
			..Default::default()
		};
		self.client
			.delete_object(opt)
			.map_err(|_e| {
				OError::InternalServerError(new_ejson(format!("Upload error: {:?}", _e).as_ref()))
			})
			.wait()?;
		Ok(true)
	}
}
