# Omnibus

An app that parents can use to track the location of their student's school bus.

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/Vermonster/laptop

After setting up, this script will launch the application using [foreman]:

    % bin/serve

If you don't have `foreman`, see [Foreman's install instructions][foreman]. It
is [purposefully excluded from the project's `Gemfile`][exclude].

[foreman]: https://github.com/ddollar/foreman
[exclude]: https://github.com/ddollar/foreman/pull/437#issuecomment-41110407

## Running Tests

To run all available test suites and linters, use the default Rake task:

    % rake

To run only the Rails or Ember test suites, use the appropriate Rake tasks:

    % rake spec
    % rake ember:test

Be aware that using the `rspec` command (e.g. for faster focused testing) will
not automatically rebuild the Ember app. Use `ember build -w` for this, or just
keep `bin/serve` running.

## Deploying

If you have previously run the `bin/setup` script, you can deploy to staging and
production with:

    $ bin/deploy staging
    $ bin/deploy production
