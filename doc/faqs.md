# Frequently Asked Questions

* [Bus Tracking](#bus-tracking)
* [Bus Assignments](#bus-assignments)
* [Security](#security)
* [Compatibility](#compatibility)
* [Accessibility](#accessibility)


## Bus Tracking

#### How does SchoolBot track bus locations?

Currently SchoolBot requires a bus fleet equipped with Zonar tracking units and
access to the [Zonar Ground Traffic Control][zonargtc] service. See the
[onboarding guide](onboarding.md#zonar-credentials) for details on the required
credentials and permissions.

[zonargtc]: http://www.zonarsystems.com/solutions/ground-traffic-control/

#### How reliable and up-to-date is the tracking?

Assuming your Zonar units are configured with Rapid Response Rate, bus positions
will usually be delayed by no more than 15 seconds. However, tracking data is
uploaded over the cellular network, so bus positions may become outdated if a
bus travels through an area of poor cell service. SchoolBot accounts for this
and provides a clear indicator on the map when a displayed position is outdated.

Please note that Rapid Response Rate is not the default configuration, and if
your units are using typical Zonar defaults, positions will be delayed by about
two minutes. SchoolBot can still display them, but they will likely not be very
useful to parents and guardians.

#### Can SchoolBot predict bus arrival times?

SchoolBot currently has no way of knowing where your bus stops are or how they
are connected into routes, so it cannot offer any predictive features (such as
arrival time estimates). The app can only show parents and guardians where their
student's bus currently is.


## Bus Assignments

#### How does SchoolBot know which bus a student is on?

SchoolBot relies on regular "pushes" of student bus assignments from the school
district's student information system. This will typically require setting up
some sort of automated export script that runs within the district network. See
the [API documentation](api/v0.md) for the technical details of this process.

#### What if students take different buses in the morning and afternoon?

SchoolBot does not have a concept of "assignment schedules" – each student can
only be assigned to one bus. The recommended workaround is to have your
assignment export script run regularly (e.g. once an hour), checking the current
time when it does, and exporting only the assignments that currently apply.

#### Can SchoolBot track students getting on and off their bus?

SchoolBot currently does not integrate with any electronic student ID systems,
so the app's knowledge is limited to bus-related data that can be acquired from
Zonar Ground Traffic Control.


## Security

#### How does SchoolBot transmit and store data?

SchoolBot enforces secure connections to the service at all times by using HTTPS
Strict Transport Security. App hosting and data storage for schoolbot.io is
provided by [Heroku](https://www.heroku.com/home), a trusted service with strong
confidentiality agreements, using datacenters in the United States.

SchoolBot never receives, transmits, or stores any personally identifiable
student data, and as a result is compliant with [FERPA][ferpa]. See the below
questions for details.

[ferpa]: http://www2.ed.gov/policy/gen/guid/fpco/ferpa/index.html

#### How do parents and guardians sign into SchoolBot?

SchoolBot has a standalone self-service account system that requires only an
email address and password. Currently the app does not integrate with any Single
Sign-On provider.

#### How do parents and guardians verify their identity?

To track the location of a student's bus, a parent or guardian must enter the
student's last name, date of birth, and student ID number. This same data is
exported from the school district's student information system as part of the
bus assignment "push". In both cases the data is anonymized before transmission,
so SchoolBot never handles personally identifiable student information. See the
[API documentation](api/v0.md) for the technical details of the anonymization.


## Compatibility

#### How do parents and guardians get the SchoolBot app?

SchoolBot is technically a web site, so parents and guardians can access it by
simply typing the address into their web browser, whether on a desktop computer,
laptop, tablet, or smartphone. There's no "app" to download, and the site can be
easily pinned to a device's desktop or home screen as a bookmark.

#### What devices does SchoolBot work on?

SchoolBot works on any device with a modern web browser – the latest versions of
Internet Explorer, Edge, Firefox, Chrome, and Safari are all supported.

SchoolBot *may* work with reduced functionality on some older versions of
Internet Explorer, but Microsoft has officially dropped all support for versions
other than the latest, so we do not support them either. Users of IE10 and below
are advised to upgrade to IE11, Edge, or a different browser.

SchoolBot does not work on the built-in "Browser" app seen on some Android
devices. Users of these devices are advised to install and use Chrome instead.


## Accessibility

#### Is SchoolBot available in multiple languages?

SchoolBot is offered primarily in English, but the app is fully localizable
using the [Crowdin][crowdin] platform. Anyone can sign up for a free Crowdin
account and apply to become a translator – contributed translations are made
available to all SchoolBot users. The project and current list of languages can
be found at: **<https://crowdin.com/project/schoolbot>**

If your school district has professional translators who would like to help
translate SchoolBot, we can grant "Proofreader" status to their Crowdin
accounts. This will allow them to not only suggest translations, but edit and
mark them as approved.

[crowdin]: https://crowdin.com/
