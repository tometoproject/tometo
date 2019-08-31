use crate::db::{self, DefaultMessage};
use crate::error::{new_ejson, OError};
use crate::user::model::{CreateUser, LoginUser, SlimUser, User};
use rocket::http::{Cookie, Cookies};
use rocket_contrib::json::Json;

pub mod model;
pub mod token;

#[post("/", data = "<user>")]
fn register(
	user: Json<CreateUser>,
	connection: db::Connection,
) -> Result<Json<DefaultMessage>, OError> {
	let user = user.into_inner();

	if user.username.is_empty()
		|| user.password.is_empty()
		|| user.confirmPassword.is_empty()
		|| user.email.is_empty()
	{
		return Err(OError::BadRequest(new_ejson(
			"Please fill out all of the fields!",
		)));
	}

	User::create(user, &connection)?;
	Ok(Json(DefaultMessage {
		message: "Successfully registered! You can log in now.".into(),
	}))
}

#[post("/", data = "<user>")]
fn login(
	user: Json<LoginUser>,
	connection: db::Connection,
	mut cookies: Cookies,
) -> Result<Json<SlimUser>, OError> {
	let user = user.into_inner();
	User::check_password(&user, &connection)?;
	let token = token::create_token(&SlimUser {
		username: user.username.clone(),
	})?;
	cookies.add_private(Cookie::new("auth", token));
	Ok(Json(SlimUser {
		username: user.username.clone(),
	}))
}

#[delete("/")]
fn logout(mut cookies: Cookies) {
	cookies.remove_private(Cookie::named("auth"));
}

#[get("/")]
fn get_user(user: SlimUser) -> Json<SlimUser> {
	Json(user)
}

pub fn mount(rocket: rocket::Rocket) -> rocket::Rocket {
	rocket
		.mount("/api/register", routes![register])
		.mount("/api/auth", routes![login, logout, get_user])
}
