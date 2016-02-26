# Hosting SchoolBot

If you would like to offer SchoolBot in your school district, and especially if
you anticipate requiring any level of technical support, we strongly recommend
our hosted service **[schoolbot.io](https://schoolbot.io)**. However, SchoolBot
is open-source and it is possible to run a separate instance of the app on your
own infrastructure.

It's important to note that **we do not support third-party installations of
SchoolBot**. If you encounter something you think is an issue with SchoolBot
itself, rather than your installation of it, detailed [issue reports][issues]
are appreciated. However, we respond to these in our spare time and cannot
guarantee a quick resolution, or even that your issue will be resolved at all.

[issues]: https://github.com/Vermonster/schoolbot/issues

## Requirements

An unmodified installation of SchoolBot requires the following services:

* Dedicated domain or subdomain with an SSL certificate
* [Heroku][heroku] (at least 4 standard 1X dynos)
* [Heroku Postgres][postgres] or other Postgres provider
* [Heroku Redis][redis] or other persistent Redis provider
* [SendGrid][sendgrid] or other outbound email service
* [Amazon S3][s3] ([Cloudfront][cloudfront] recommended but not required)
* [Airbrake](https://airbrake.io/)
* [Geocodio](http://geocod.io/)
* [Mapbox Studio](https://www.mapbox.com/mapbox-studio/)

Airbrake, Geocodio, and Mapbox all offer free service tiers with usage limits
that should be sufficient for a single school district of average size.

SchoolBot can optionally integrate with the free [Intercom][intercom] platform
for easy tracking and analysis of user data. Intercom also offers paid plans for
in-app user messaging, but the current SchoolBot code does not support this.

[heroku]: https://heroku.com
[postgres]: https://www.heroku.com/postgres
[redis]: https://elements.heroku.com/addons/heroku-redis
[s3]: https://aws.amazon.com/s3/
[cloudfront]: https://aws.amazon.com/cloudfront/
[sendgrid]: https://sendgrid.com/
[intercom]: https://www.intercom.io/

## Multi-Tenancy

SchoolBot is a multi-tenant platform that can serve multiple school districts
using different subdomains of the same base domain (in the case of the service
we offer, this is `schoolbot.io`). If you are a transportation provider, for
example, you can offer SchoolBot to all school districts that use your buses.

Currently SchoolBot does not include a "single school district" operating mode.
If you are a single school district, you must set up SchoolBot on a dedicated
base domain (e.g. `schoolbot.my-district.org`), and set up your school district
as a subdomain within the app (e.g. `app.schoolbot.my-district.org`).

## District Setup

The initial setup of each school district (or editing of a school district's
attributes) must be performed manually from the Rails console. This assumes you
have gathered the data specified in the [onboarding guide](onboarding.md).

### Example

```ruby
district = District.create!(
  name: 'Springfield Public Schools',
  slug: 'springfield',
  contact_phone: '917-555-1234',
  contact_email: 'support@example.com',
  zonar_customer: 'abc1234',
  zonar_username: 'schoolbot',
  zonar_password: 'swordfish',
  logo: URI.parse('http://example.com/springfield-logo.svg')
)

SchoolImport.new(
  district: district,
  data: URI.parse('http://example.com/springfield-schools.csv').read
).import!
```

### Notes

* The "slug" is the part of the school district's subdomain that comes before
  the root domain.

* The logo can be assigned using any mechanism supported by Paperclip. In this
  example, it is uploaded to a [temporary storage service][storage] – Paperclip
  will download the file and then upload it to the configured S3 bucket.

* School data must be provided as CSV with a header row. "Name" and "Address"
  columns are required; "Latitude" and "Longitude" columns are optional (if not
  provided, the address will be geocoded using Geocodio).

* Once a school district is created, the app will immediately start requesting
  and recording Zonar bus data at regular intervals. If you don't want this to
  happen, set the school district's `is_active` attribute to `false`. Inactive
  school districts effectively do not exist, but can be easily activated later.

[storage]: https://www.google.com/search?q=temporary+file+upload
