# Tometo

[![Build status](https://badge.buildkite.com/01b5ac8d7f2c0b0e20a6401bd35815de56291e1c342afcee61.svg)](https://buildkite.com/mokou/tometo)

Tometo is a social network focused on text-to-speech. It's written in
[Elixir](https://elixir-lang.org) using the
[Phoenix](https://phoenixframework.org) web library and can generate TTS
audio from Google Cloud. The frontend is written in JavaScript using
[Vue](https://vuejs.org), with [Vue Router](https://router.vuejs.org) for routing
and [Vuex](https://vuex.vuejs.org) for state management.

## Quick Links

- **All current tasks:** https://git.tometo.org/tag/tometo/
- **Create a new Tometo task:** https://git.tometo.org/maniphest/task/edit/form/1/
- **Documentation:** https://docs.tometo.org

## Local Installation

Installation is easy! All you have to do is set up
[Vagrant](https://vagrantup.com) on your computer, download the repository
either via Git or as a [ZIP
file](https://github.com/tometoproject/tometo/archive/master.zip), and then run
the following in the downloaded folder:

``` sh
vagrant up
# After that's done:
vagrant ssh
```

This will put you in a small virtual machine that has Tometo running in it. The
best part is that the content in your downloaded folder automatically
synchronizes with your virtual machine! If you just want to run Tometo, type:

``` sh
script/watch
```

For more installation information, see our [installation
docs](https://docs.tometo.org/installation.html).

## Reporting Issues

Please follow our [documentation on reporting a bug](https://docs.tometo.org/contributing/bug.html)!

## Documentation

If you want to work on Tometo, or just play around with it locally, please
follow the [Installation documentation](https://docs.tometo.org/installation.html).
There's other documentation on there that might be worth reading, too.

## License

Tometo is licensed under the [Prosperity public license](https://prosperitylicense.com/), meaning you
can't use it commercially. This doesn't make it Open Source software, but that
distinction is not important to us.
