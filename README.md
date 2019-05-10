# metomo

## Reporting Issues

To report an issue, you will need a user account. After signing up and
verifying your email, you can report an issue by opening a new task. To do that,
select the star next to your user avatar in the top bar and click "Create Task".
Enter a title, description and "Metomo" in the "Tags" section (it should
auto-complete). That way, the right people will be notified.

## Local Setup

Metomo is functionally split into two parts — the frontend, which is a Vue.js
app that's kept in this repository, and the backend, which is a Rust app that's
kept at [rOM](https://p.veb.cool/source/omotem).

In order to get the system running on your computer, you'll need some
prerequisites:

- PostgreSQL
- Node.js, the latest LTS or Stable version should work
- Rust, the latest Stable version should work, although you do need at least
  version 1.32.0

After you've installed Rust, you should also install `diesel-cli`, which is what
powers our database management:

```sh
cargo install diesel-cli
```

Then, you can clone the repositories. Make sure you have a user account and that
you've added your SSH key to Phabricator
([here's](https://p.veb.cool/w/new-user-guide/) a guide on that):

```sh
git clone ssh://vcs@p.veb.cool:2222/source/metomo.git
git clone ssh://vcs@p.veb.cool:2222/source/omotem.git
```

It's not strictly necessary to have them be siblings in the same directory, but
if you want to use a convenience script to have both apps run at once, you
should (although this currently doesn't work correctly, see
[T11](https://p.veb.cool/T11)).

### Metomo (rMT)

Once you're in the directoy, you'll want to install its dependencies:

```sh
npm install
```

There's not much more to it! We provide a couple of convenience commands for
doing stuff:

- `npm start`: Runs the frontend and watches for changes
- `npm run build`: Builds a production-ready JavaScript distribution
- `npm run watch`: Runs and watches both the front and the backend, but
  currently doesn't work correctly (see [T11](https://p.veb.cool/T11))
  
You will also want to set the `API_URL` environment variable. You can do this
via creating a `.env` file in the root of the repository (this file won't be
tracked). The contents should look like this:

```
API_URL=http://localhost:4001
```

Of course, the port depends on what port you are running the server on.

### Omotem (rOM)

Assuming that you've set up your PostgreSQL access, create a `.env` file in the
repository root and fill it with the following:

```
DATABASE_URL=postgres://user:password@localhost/dbname
PORT=4001
```

Replace the example parts with your own. Feel free to adjust the port number,
just make sure you also change the `API_URL` variable in the frontend.

Next up, to make the app aware of the database, run this command:

```sh
diesel setup
```

If your database is misconfigured, the output from this command will let you
know.

Now you can run the backend:

```sh
cargo run
```

If you want to automatically watch and restart when there's a file change,
you can use `cargo-watch`:

```sh
cargo install cargo-watch
cargo watch -x run
```

## Contributing

If you want to send in a pull request (we call them Revisions here), the
project follows the global workflow for Differential Revisions. A guide on
how to contribute a Revision can be found [here](https://p.veb.cool/w/differential-guide/).


