# flutter_location_example

This app demonstrates how to get the current location from the user.

It shows how to ask for permission and handle the different stages of permission (granted, denied, etc).
It also shows how to display the current location continuously, using the `provider` package.

The app demonstrates two different ways to get the current location:

- Using the [`location`](https://pub.dev/packages/location) package
- Using the [`geolocator`](https://pub.dev/packages/geolocator) package

Each package has it's own repository, which can be swapped out.

## Using the `location` / `geolocator` packages

In order to get the packages running, I had to do some additional setup, not documented in the package's documentation.
 
[Fix for Kotlin compilation problem](https://github.com/Baseflow/flutter-geolocator/issues/1441#issuecomment-1968127135)

## Known issues

Currently, getting the location using the `location` package is not working on **iOS**.