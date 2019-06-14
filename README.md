# tometo

## Reporting Issues

To report an issue, you will need a user account. After signing up and
verifying your email, you can report an issue by opening a new task. To do that,
select the star next to your user avatar in the top bar and click "Create Task".
Enter a title, description and "Tometo" in the "Tags" section (it should
auto-complete). That way, the right people will be notified.

## Local Setup

Tometo is functionally split into two parts — the frontend, which is a Vue.js
app that's kept in this repository, and the backend, which is a Rust app that's
kept at [rOM](https://marisa.cloud/source/omotem).

In order to get the system running on your computer, you'll need some
prerequisites:

- PostgreSQL
- Node.js, the latest LTS or Stable version should work
- Rust, the latest Stable version should work, although you do need at least
  version 1.32.0
- Python 3, accessible under the `python3` executable, as well as `pip3`
- The Google Cloud SDK

After you've installed Rust, you should also install `diesel-cli`, which is what
powers our database management:

```
cargo install diesel-cli
```

You'll also want to install the TextGrid Python module:

```
pip3 install TextGrid
```

Then, you can clone the repositories. Make sure you have a user account and that
you've added your SSH key to Phabricator
([here's](https://marisa.cloud/w/new-user-guide/) a guide on that):

```
git clone ssh://vcs@marisa.cloud:2222/source/metomo.git
git clone ssh://vcs@marisa.cloud:2222/source/omotem.git
```

It's not strictly necessary to have them be siblings in the same directory, but
if you want to use a convenience script to have both apps run at once, you
should (although this currently doesn't work correctly, see
[T11](https://marisa.cloud/T11)).

### Metomo (rMT)

Once you're in the directoy, you'll want to install its dependencies:

```
npm install
```

There's not much more to it! We provide a couple of convenience commands for
doing stuff:

- `npm start`: Runs the frontend and watches for changes
- `npm run build`: Builds a production-ready JavaScript distribution
- `npm run watch`: Runs and watches both the front and the backend, but
  currently doesn't work correctly (see [T11](https://marisa.cloud/T11))
  
You will also want to set the `API_URL` environment variable. You can do this
via creating a `.env` file in the root of the repository (this file won't be
tracked). The easiest way to do this is by copying the example file:

```
cp .env.example .env
```

Of course, the port depends on what port you are running the server on.

### MFA

Omotem uses the
[Montreal Forced Aligner](https://montreal-forced-aligner.readthedocs.io/en/latest/)
to figure out timestamps for the generated audio. Download the 1.1.0 beta
release and extract it:

```
curl -LO https://github.com/MontrealCorpusTools/Montreal-Forced-Aligner/releases/download/v1.1.0-beta.2/montreal-forced-aligner_linux.tar.gz
tar xvf montreal-forced-aligner_linux.tar.gz
```

After that, copy the `montreal-forced-aligner` folder to a permanent location.
You'll also want to download a lexicon file for the English language. You can
find one [here](http://www.openslr.org/resources/11/librispeech-lexicon.txt).
Download and save that in the directory where your MFA is, as `lexicon.txt`.

### Omotem (rOM)

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

Now you can run the backend:

```
cargo run
```

If you want to automatically watch and restart when there's a file change,
you can use `cargo-watch`:

```
cargo install cargo-watch
cargo watch -x run
```

## Contributing

If you want to send in a pull request (we call them Revisions here), the
project follows the global workflow for Differential Revisions. A guide on
how to contribute a Revision can be found [here](https://marisa.cloud/w/differential-guide/).


