# tometo

Tometo is a social network focused on text-to-speech.

## Reporting Issues

To report an issue, you will need a user account. After signing up and
verifying your email, you can report an issue by opening a new issue [here](https://marisa.cloud/tometo/issues/issues/new).

## Local Setup

Tometo is functionally split into two parts — the frontend, which is a Vue.js
app that's kept in this repository, and the backend, which is a Rust app that's
kept in the `./otemot` folder.

In order to get the system running on your computer, you'll need some
prerequisites:

- A PostgreSQL server, and its development headers (sometimes called `postgresql-devel`)
- Node.js, the latest LTS or Stable version should work
- Rust, the latest Stable version should work, although you do need at least
  version 1.32.0
- Python 3, accessible under the `python3` executable, as well as `pip3`
  (plus development headers, sometimes separate as `python3-devel`)
- eSpeak (and its development headers, sometimes separate as `espeak-devel`)
- FFmpeg
- The Google Cloud SDK

After you've installed Rust, you should also install `diesel-cli`, which is what
powers our database management:

```
cargo install diesel_cli --no-default-features --features postgres
```

You'll also want to install `aeneas`, which parses text for us (this needs
ffmpeg and espeak installed and available):

```
pip3 install numpy aeneas
```

Then, you can clone the repository. Make sure you have a user account and that
you've added your SSH key to GitLab (if not, you can use the HTTPS checkout):

```
git clone git@marisa.cloud:tometo/tometo.git
```

### Tometo Setup

Once you're in the directoy, you'll want to install its dependencies:

```
npm install
```

There's not much more to it! We provide a couple of convenience commands for
doing stuff:

- `npm start`: Runs the frontend and watches for changes
- `npm run build`: Builds a production-ready JavaScript distribution in `dist/`
- `npm run watch`: Runs and watches both the front and the backend (run `cargo install cargo-watch` first)
  
You will also want to set the `API_URL` environment variable. You can do this
via creating a `.env` file in the root of the repository (this file won't be
tracked). The easiest way to do this is by copying the example file:

```
cp .env.example .env
```

Of course, the port depends on what port you are running the server on.

### Otemot Setup

First, go into the right directory:

```
cd otemot
```

Assuming that you've set up your PostgreSQL access, copy the `.env` file in the
repository root and replace its contents:

```
cp .env.example .env
```

Replace the example parts with your own. Feel free to adjust the port number,
just make sure you also change the `API_URL` variable in the frontend. The
`MFA_LOCATION` should point to the directory where your Montreal Forced Aligner
lives.

The `GOOGLE_APPLICATION_CREDENTIALS` points to a service account credential
file that you should have downloaded while setting up the Google Cloud SDK.
You can find more information on this
[here](https://cloud.google.com/docs/authentication/getting-started).

Next up, to make the app aware of the database, run this command:

```
diesel setup
```

If your database is misconfigured, the output from this command will let you
know.

Now you can back out of the directory and run the backend:

```
cd ..
cargo run
```

To watch when there's a file change, use `npm run watch` (which also watches
the frontend), but install `cargo-watch` first:

```
cargo install cargo-watch
npm run watch
```

## Contributing

Feel free to send merge requests! This section will be expanded on in the
future, surely.


