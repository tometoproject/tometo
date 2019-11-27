# tometo [![Build Status](https://ci.marisa.cloud/api/badges/t/tometo/status.svg)](https://ci.marisa.cloud/t/tometo)

Tometo is a social network focused on text-to-speech. It's written in
[Rust](https://rust-lang.org) using the [Rocket](https://rocket.rs) web library,
[Diesel](https://diesel.rs) for talking to a PostgreSQL server, can generate TTS
audio from Google Cloud, and optionally store generated artifacts on
S3-compatible services. The frontend is written in JavaScript using
[Vue](https://vuejs.org), with [Vue Rouer](https://router.vuejs.org) for routing
and [Vuex](https://vuex.vuejs.org) for state management.

## Reporting Issues

Please report issues on our [GitHub issue tracker](https://github.com/tometoproject/tometo/issues)!

## Documentation

If you want to work on Tometo, or just play around with it locally, please
follow the [Installation documentation](https://docs.tometo.org/installation/).
There's other documentation on there that might be worth reading, too.

## License

Tometo is licensed under the [Prosperity public license](./LICENSE), meaning you
can't use it commercially. This doesn't make it Open Source software, but that
distinction is not important to us.
