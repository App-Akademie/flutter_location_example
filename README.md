# flutter_location_example

This app demonstrates how to get the current location from the user.

It shows how to ask for permission and handle the different stages of permission (granted, denied, etc).
It also shows how to display the current location continuously, using the `provider` package.

The app demonstrates two different ways to get the current location:

- Using the `location` package
- Using the `geolocator` package

Each package has it's own repository, which can be swapped out.

## Notes

Currently, getting the location using the `location` package is not working on iOS.