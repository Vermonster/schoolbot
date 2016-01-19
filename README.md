# SchoolBot

An app that parents can use to track the location of their student's school bus.

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/Vermonster/laptop

After setting up, this script will run the application using [Heroku Local]:

    % bin/serve

To access the app in development, use the `lvh.me` domain. This resolves to
127.0.0.1, but allows arbitrary subdomains to be used. For instance, with the
development seed data, try <http://brockton.lvh.me:3000>.

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

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

Deploy to staging and production with:

    $ bin/deploy staging
    $ bin/deploy production

This requires that you have previously run `bin/setup`, and that all values in
`client/.env` are present and set correctly. The values can be found in a pinned
item in the project's Slack channel.
