# Contributing

Thanks for contributing to SchoolBot! Just so you know, all contributors agree
to abide by our [Code of Conduct](CODE_OF_CONDUCT.md) and license their work
under the [Contributor License Agreement](#contributor-license-agreement).

## Workflow

We follow thoughtbot's **[Git Protocol][protocol]** for all work, from both
maintainers and contributors. Contributors without write access should create
feature branches in their own GitHub fork of the project, and a maintainer will
perform the final merge.

Before contributing a new feature, please [open an issue][issues] to discuss it.
The Vermonster team is responsible for maintaining all contributed code, and to
keep the project focused, we may not want to accept all proposed features.

[protocol]: https://github.com/thoughtbot/guides/tree/master/protocol/git
[issues]: https://github.com/Vermonster/schoolbot/issues

## Development

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % bin/setup

It assumes you have a machine equipped with Ruby, Postgres, Node, etc. If not,
set up your machine with [this script].

[this script]: https://github.com/Vermonster/laptop-local

After setting up, this script will run the application using [Heroku Local]:

    % bin/serve

To access the app in development, use the `lvh.me` domain. This resolves to
127.0.0.1, but allows arbitrary subdomains to be used. For instance, with the
development seed data, try <http://brockton.lvh.me:3000>.

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

### Testing

To run all available test suites and linters, use the default Rake task:

    % rake

To run only the Rails or Ember test suites, use the appropriate Rake tasks:

    % rake spec
    % rake ember:test

Be aware that using the `rspec` command (e.g. for faster focused testing) will
not automatically rebuild the Ember app. Use `ember build -w` for this, or just
keep `bin/serve` running.

### Deployment

Deploy to staging and production with:

    $ bin/deploy staging
    $ bin/deploy production

This assumes you have run `bin/setup`, and all values in `client/.env` and
`client/.env.deploy.<target>` are set correctly. The values for Vermonster's
deployment can be found in a pinned item in the `#schoolbot` Slack channel.

## Contributor License Agreement

If you submit a Contribution to this application's source code, you hereby grant
Vermonster LLC a worldwide, royalty-free, exclusive, perpetual, and irrevocable
license, with the right to grant or transfer an unlimited number of
non-exclusive licenses or sublicenses to third parties, under the Copyright
covering the Contribution to use the Contribution by all means, including but
not limited to:

* to publish the Contribution,

* to modify the Contribution, to prepare Derivative Works based upon or
  containing the Contribution and to combine the Contribution with other
  software code,

* to reproduce the Contribution in original or modified form,

* to distribute, to make the Contribution available to the public, display and
  publicly perform the Contribution in original or modified form.
