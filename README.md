# SchoolBot

This is the open-source code behind [SchoolBot](https://schoolbot.io), a web app
created by [Vermonster](http://www.vermonster.com) that parents and guardians of
students can use to track school bus locations.

School districts interested in offering SchoolBot have two options: Deploy and
maintain this code on their own servers, or purchase a subscription to
**schoolbot.io**, a deployment of SchoolBot hosted and supported by Vermonster.

## schoolbot.io

Our hosted SchoolBot service is available to any school district that meets the
basic requirements. Please contact us at <schoolbot@vermonster.com> for pricing.

## Requirements

Regardless of whether you subscribe to the schoolbot.io service or host your own
installation of SchoolBot, the basic requirements are:

1. School buses must be tracked using [Zonar Ground Traffic Control][zonargtc].
2. Students must be assigned to buses in your student information system using
   a unique bus identifier that is also present in Zonar.
3. You must have a way of regularly exporting (and anonymizing) bus assignment
   data from your student information system to the SchoolBot API.

[zonargtc]: http://www.zonarsystems.com/solutions/ground-traffic-control/

## Documentation

* See the **[onboarding guide](doc/onboarding.md)** for a detailed checklist of
  requirements to set up your school district on the schoolbot.io service (or on
  your own installation).

* See our **[FAQs](doc/faqs.md)** for answers to common questions about
  SchoolBot and the schoolbot.io service.

* See the **[hosting documentation](doc/hosting.md)** for guidance on setting
  up your own installation of SchoolBot.

## Hire Us

We are [Vermonster](http://www.vermonster.com), a team of product designers and
developers in Boston, MA. Is there a feature or integration you'd like see in
SchoolBot? Hire us and we'll build it for you as a consulting project. Contact
us at <schoolbot@vermonster.com> for more information.

## Contributing

See **[CONTRIBUTING.md](CONTRIBUTING.md)** to learn how to work on this project.

## License

SchoolBot is © 2016 Vermonster LLC. It is free software, and may be
redistributed under the terms specified in **[LICENSE.md](LICENSE.md)**.
