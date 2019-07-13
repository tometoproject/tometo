# Contributing to Tometo

Thanks for your interest in contributing to Tometo!
There are more than one way to contribute to the project, and we appreciate
all of them.

If you have any questions, feel free to ask them in the [Tometo Discord server][discord]!
As a reminder, all contributors, in whichever way, are required to follow
the [Code of Conduct](./CODE_OF_CONDUCT.md).

## Feature Requests

If you have ideas or even concrete suggestions for a feature or an enhancement,
it's best to discuss it first on Discord before diving into the specifics. If you
feel up to implement it, open a [pull request](#pull-requests)!

## Bug Reports

While we wish everything in here worked perfectly, bugs are natural to occur.
This is why we recommend that, even when you're not sure it's a bug, to report
it anyways.

Please search for already existing or similar reports first before you open
an issue, although GitLab does show similar issue titles as you go about
creating your bug report.

It also makes our lives much easier if the issue title is as descriptive as
possible. This can be the specific error message given, the steps you used
to reproduce it, or something else that's unique to the bug you're
experiencing.

Filing a bug report happens in the `tometo/issues` repository, and you can
find a link to create a new issue [here](https://marisa.cloud/tometo/issues/issues/new).

If you're running Tometo locally, please include as much information as possible
about your setup, what Rust version you use, what Node version, your operating
system, stack traces, et cetera. To get nice backtraces from Rust (e.g. Otemot),
there's a special environment variable you can set:

```
RUST_BACKTRACE=1 cargo run
# or
RUST_BACKTRACE=1 npm run watch
```

## Pull Requests

_(or Merge Requests, as GitLab calls them)_

Pull/Merge Requests are how we usually land code for Tometo. We use a simple
model, where every contributor pushes changes either to their fork or to a branch
on the main repository, and then brings those changes into the master branch.

_(Please make Pull Requests against the `master` branch)_

If you're bringing latest changes from `master` into your branch, please always
rebase instead of merging. Also, please make sure that fixup commits are squashed
into other related commits with meaningful commit messages.

Always make sure that your code conforms to the style guidelines by running the
following:

```
npm run lint
cargo fmt
```

(otherwise, our CI will complain for you)

Please don't annoy anyone to review your pull request, people have limited time,
and sometimes other things have priorities.

## Issue Triage

Issues on `tometo/issues` have specific labels, which should be mostly self-explanatory,
but here's some notes on them anyways:

- Don't use `Priority: Critical` or preferably even `Priority: High` unless discussed previously
- `Epic` refers to an issue that tracks a multitude of other issues, e.g. a large feature
- The `Status:` labels can be assigned using the [issue board](https://marisa.cloud/tometo/issues/boards)

[discord]: https://discord.gg/xqTEcaw
