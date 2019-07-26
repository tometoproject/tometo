use crate::db;
use crate::user::model::{CreateUser, LoginUser, SlimUser, User};
use rocket::http::{self, Cookie, Cookies};
use rocket_contrib::json::Json;

pub mod model;
pub mod token;

#[post("/", data = "<user>")]
fn register(user: Json<CreateUser>, connection: db::Connection) -> Result<String, http::Status> {
	let user = user.into_inner();

	if user.username.is_empty()
		|| user.password.is_empty()
		|| user.confirmPassword.is_empty()
		|| user.email.is_empty()
	{
		return Err(http::Status::BadRequest);
	}

	let res = User::create(user, &connection).map_err(|_| http::Status::InternalServerError);

	match res {
		Ok(_) => Ok("Successfully created user!".into()),
		Err(e) => Err(e),
	}
}

#[post("/", data = "<user>")]
fn login(
	user: Json<LoginUser>,
	connection: db::Connection,
	mut cookies: Cookies,
) -> Result<Json<SlimUser>, http::Status> {
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
fn logout(mut cookies: Cookies) -> () {
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
