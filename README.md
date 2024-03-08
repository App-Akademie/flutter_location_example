# flutter_location_example

This app demonstrates how to get the current location from the user.

It shows how to ask for permission and handle the different stages of permission (granted, denied, etc).
It also shows how to display the current location continuously, using the `provider` package.

The app demonstrates two different ways to get the current location:

- Using the [`location`](https://pub.dev/packages/location) package
- Using the [`geolocator`](https://pub.dev/packages/geolocator) package

Each package has it's own repository, which can be swapped out.

## Location permission states

In an ideal world for the app developer, location would always be accessible.
However, the user has the right to deny access to their location, and the app must handle this gracefully.

There are several cases to consider:
- Location access is already granted
- The user is currently asked for permission
- The user has denied access to their location
- The user has denied access to their location and checked "Don't ask again"

The app needs to handle all those cases appropriately.

### When to ask for location permission

Usually, the user is asked for permission when the app is first started, eg. during onboarding.
However, the user can also change their mind and revoke access to their location at any time.
Therefore, the app should check for permission every time it needs to access the location and ask for permission if necessary.

## Using the `location` / `geolocator` packages

The `location` and `geolocator` packages are very similar, and can almost be used interchangeably.


However, the `geolocator` package is a bit more feature-rich, has more upvotes and seems to be maintained more actively.
There also was a problem with the `location` package (see below).

### Additional setup

In order to get the packages running, I had to do some additional setup, not documented in the package's documentation.
 
[Fix for Kotlin compilation problem](https://github.com/Baseflow/flutter-geolocator/issues/1441#issuecomment-1968127135)

## Known issues

Currently, getting the location using the `location` package is not working on **iOS**.