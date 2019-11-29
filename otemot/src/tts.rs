use std::fs;
use std::io::{Write, BufWriter};
use std::process::Command;
use serde_json::Value;
use isahc::prelude::*;
use base64::decode;

pub fn synthesize(name: &str, text: String, pitch: Option<i16>, speed: Option<f32>) -> Result<(), Box<dyn std::error::Error>> {
	let mut cfg = config::Config::default();
	cfg.merge(config::File::new("config.toml", config::FileFormat::Toml))
		.unwrap()
		.merge(config::Environment::new().separator("_"))
		.unwrap();

	fs::create_dir_all(format!("otemot/gentts/{}", name))?;

	if cfg.get::<String>("otemot.speech").unwrap() == "google" {
		let api_key = cfg.get::<String>("otemot.google.key").unwrap();
		let json_data = serde_json::json!({
			"input": {
				"text": text
			},
			"voice": {
				"languageCode": "en-US",
				"name": "en-US-Standard-B"
			},
			"audioConfig": {
				"audioEncoding": "OGG_OPUS",
				"pitch": pitch.unwrap_or(0),
				"speakingRate": speed.unwrap_or(1.0),
			},
		});
		let mut res = Request::post(format!("https://texttospeech.googleapis.com/v1/text:synthesize?key={}", api_key))
			.header("Content-Type", "application/json")
			.body(json_data.to_string())?
			.send()?;

		let body = res.body_mut().json::<Value>().unwrap();
		let mut buffer = BufWriter::new(fs::File::create(format!("otemot/gentts/{}/temp.ogg", name))?);
		buffer.write_all(&decode(body["audioContent"].as_str().unwrap()).unwrap())?;
		buffer.flush()?;
	} else {
		let scale_pitch = (pitch.unwrap() + 20) / 40 * 99;
		let scale_speed = (((speed.unwrap() - 0.25 ) / 3.75 * 370.0) + 80.0).floor();
		Command::new("espeak")
			.args(&[
				"-p", &scale_pitch.to_string(),
				"-s", &scale_speed.to_string(),
				"-w", &format!("otemot/gentts/{}/temp.wav", name),
				&text,
			])
			.output()?;
		Command::new("ffmpeg")
			.args(&[
				"-i", &format!("otemot/gentts/{}/temp.wav", name),
				"-c:a", "libopus",
				"-b:a", "96K",
				&format!("otemot/gentts/{}/temp.ogg", name),
			])
			.output()?;
	}

	fs::write(format!("otemot/gentts/{}/temp.txt", name), &text.split(' ').collect::<Vec<&str>>().join("\n"))?;
	Command::new("python3")
		.args(&[
			"-m",
			"aeneas.tools.execute_task",
			&format!("otemot/gentts/{}/temp.ogg", name),
			&format!("otemot/gentts/{}/temp.txt", name),
			"task_language=eng|os_task_file_format=json|is_text_type=plain",
			&format!("otemot/gentts/{}/out.json", name),
		])
		.output()?;
	Ok(())
}
