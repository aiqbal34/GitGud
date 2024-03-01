# MileStone 2 Notes


## Third party libraries
We plan to use Apple CloudKit to stay native since it is pretty much integrated with Swiftui and takes a burden away from authentication.
We also plan to use a styling library if need be since styling/ animations are something that takes a lot of time, and it would be easy to outsource it.
We are going to use PhoneNumberKit too since we have an OTP

## Apis
Firebase authentication API, Firebase FireStore with SwiftUI 

## Testing

We will have our roommates test the app and tell us how easy it was to make an account, and how intuitive the UI is, and have them rate it from one to 10. We will also ask them if they have any specific aspects of the UI they would want to be changed to make it more intuitive.

## Trello Board
https://trello.com/b/xOBGAbyp/maszina-board

# Sprint Planning 3

## Project Description
Our app revolutionizes team formation for computer science projects. With customizable profiles and a swipe-based interface akin to dating apps, users effortlessly find like-minded teammates based on tech expertise. Whether it's for hackathons or startup ventures, our app simplifies collaboration, providing the ideal platform to create your custom team that matches your needs and vision.

## Design
https://www.figma.com/file/yob2jpxYQR4JvoPlybnWfp/MasZina?type=design&node-id=0-1&mode=design&t=TgnGmMCK0L4CDCyf-0


### Meeting Notes
In our meeting we discussed an alternative option for our backend based on our needs, we settled on Firebase and AppEngine. We also further discussed the architecture for our app and white boarded how we plan on implementing the backend for querying data for displaying the users and teams. We also decided to specialize the purpose of our app and added the UI Views for a feature where the users can specify what they are looking for in team members and find a tailored team with a click of a button. We were able to get the backend working for the user to create an account and log in to the app, and either match with a user or press next and proceed to view other users. By next time we plan to have the team member find functionality working and also implement an algorithm that filters through members to find the best match.


### Individual tasks:

### Aariz Iqbal:
Done:
- Created the backend and database 
- Created authorization UI flow
- Implemented the registration process

To Do:
- Fetch and display user profiles from the database


Blocks:
None

### Isa Bukhari
Done:
- Researched backend option to Firebase
- Implemented Settings Page UI
- Implemented EnterOTPView

To Do:
- Create a connection View
- Polish Overall UI


Blocks:
- None

### Sajid Hussein
Done:
- Updated Figma to include teamBuilder
- Implemented HomeView, TeamMemberView, FindMemebersView
- Implemented a search functionality for arrays
- Implemented the Navigation System

To Do:
- Implement the algorithm for the teambuilder filtering logic based on compatability 

Blocks:
- None




