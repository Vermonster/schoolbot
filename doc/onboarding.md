# schoolbot.io Onboarding

The following are the base requirements for us to set up a school district on
the [schoolbot.io](https://schoolbot.io) service. If you intend to set up the
open-source SchoolBot code on your own infrastructure, please see the [hosting
documentation](hosting.md) for additional requirements.

## District Information

#### Logo

Your school district's logo will appear on the app's landing page. The logo must
be **transparent** and provided in a **vector format** (SVG is preferred). Keep
in mind your logo will be displayed on a light background, so light colors might
not show up well.

#### Name

Your school district's name will also appear on the app's landing page.

#### Subdomain

Each school district is assigned a subdomain of **schoolbot.io**, which serves
as the entry point into the app for users in that school district. For instance,
a hypothetical school district named "Springfield Public Schools" might have the
subdomain **springfield.schoolbot.io**.

Subdomain requirements:

* must be between 3 and 63 characters long
* must consist only of lowercase letters, numbers, and dashes ( - )
* must be unique among all school districts hosted on schoolbot.io

Choose your subdomain carefully, as it is difficult to change later. We
generally recommend keeping subdomains short, so they are easier to communicate
(e.g. over the phone) and easier to type (e.g. on a touch keyboard).

#### Support Email Address

We rely on individual school districts to provide front-line support for their
users. Your designated email address will be displayed in the "Help" section of
the app. If a user issue cannot be resolved on the school district side, it can
be forwarded to the SchoolBot support address.

#### Support Phone Number

Your designated phone number will also be displayed in the app's "Help" screen.

## School Names and Addresses

When users add a student to their account, for mapping purposes we also require
them to select which school the student attends. To provide this functionality,
we need a list of all the schools in your district and their street addresses.
The preferred format is a spreadsheet with "Name" and "Address" columns,
exported as CSV. We will automatically determine the physical location of each
school from its street address, but if you want to override this and provide
your own locations, include "Latitude" and "Longitude" columns in your
spreadsheet.

## Zonar Credentials

Provide credentials for a Zonar Ground Traffic Control account that has
permissions to use the ["Export Path" API endpoint][exportpath]. There are three
parts: **customer ID**, **username**, and **password**.

[exportpath]: https://docs.zonarsystems.net/manuals/OMI/en/exportpath.html

## Zonar Configuration

For the app to be useful to parents and guardians, your buses need to be sending
position updates to Zonar more frequently than the default setting of once every
2.5 minutes. Ask your transportation provider to enable a Zonar feature called
**Rapid Response Rate** – this will increase the rate to once every 10 seconds.

If you are unable to use Rapid Response Rate, the fallback option is to
configure your buses with the "**Edulog Parameters**" – this will result in
updates about once every 30 seconds.

## Localization

If your school district has professional translators who would like to help
translate SchoolBot, we can invite them to our translation platform. See the
[Accessibility FAQs](faqs.md#accessibility) for details.

## Student Bus Assignments

SchoolBot does not integrate with any specific student information system –
instead, it provides an API that school districts can use to export anonymized
student bus assignments. You'll need a scheduled or manually-executed process in
place that can provide us with these exports from whatever system you use. See
the [API Documentation](api/v0.md) for details.

Once all of the other information in this document has been provided, we can set
up your school district on schoolbot.io and give you an API key.
