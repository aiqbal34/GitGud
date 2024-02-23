# MileStone 1 Notes

## Design
*insert design here

## Third party libraries
We plan to use apple CloudKit to stay native since it is pretty much integrated with swiftui and takes a burden away from authentication.
We also plan to use a styling libaray if need be since styling/ animations is something that takes a lot of time, and it would be easy to out source it.
We are going to use PhoneNumberKit too since we have an OTP

## Apis
CloudKit is somewhat like an api, and we have some features we might integrate an api if we have time, with that we may have to migrate to a backend server, since right now we don't really need one since we are just doing get requests and post requests and there is no need for transforming the data that is coming in

## Testing

We will have our roommates test the app and tell us how easy it was to make an account, how intuitive is the UI, and have them rate it from one to 10. We will also ask them if they had any specific aspects of the UI they would want to be changed to make it more intuitive.

## Meeting Notes

In our meeting we discussed our possible options for the backend and settled on CloudKit after doing research and compiling our ideas. We planned the architecture for our app and decided that we would have a private database for sensitive information and another database for storing public information about the user. Aariz set up the github repository and we all whiteboard the views for the app. After that we designed the individual views on figma and general flow of the app. We also started on implementing the designs for some of the views. We haven’t had any issues so far. 

