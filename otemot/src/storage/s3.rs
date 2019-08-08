use crate::storage::Storage;
use crate::error::{new_ejson, OError};
use rusoto_core::Region;
use rusoto_s3::{S3Client, S3, PutObjectRequest, DeleteObjectRequest};
use either::Either;
use std::path::PathBuf;
use std::fs::File;
use std::io::Read;
use futures::Future;

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
        Ok(format!("https://tometo-devel.s3.fr-par.scw.cloud/{}", key))
    }

    fn put(&self, key: String, upload: Either<PathBuf, Vec<u8>>) -> Result<bool, OError> {
        let body;
        match upload {
            Either::Left(path) => {
                let file = File::open(path)?;
                file.read_to_end(body)?;
            }
            Either::Right(bytes) => {
                *body = bytes
            }
        }
        let opt = PutObjectRequest {
            // FIXME: substitute this with config variables
            bucket: String::from("tometo-devel"),
            key,
            body: Some(*body.into()),
            ..Default::default()
        };
        self.client.put_object(opt).map_err(|e| OError::InternalServerError(new_ejson("uh oh!"))).wait()?;
        Ok(true)
    }

    fn delete(&self, key: String) -> Result<bool, OError> {
        let opt = DeleteObjectRequest {
            // FIXME: substitute this with config variables
            bucket: String::from("tometo-devel"),
            key,
            ..Default::default()
        };
        self.client.delete_object(opt).map_err(|e| OError::InternalServerError(new_ejson("uh oh!"))).wait()?;
        Ok(true)
    }
}
