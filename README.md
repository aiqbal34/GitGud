# Final Project Submission

## Overveiw
GitGud is an iOS app that allows users interested in collaborating on CS projects to create profiles, view others’ skills and experience, and connect based on project requirements. It also includes a feature to analyze project descriptions using AI and suggest a tailored team with the necessary skills needed to build the project.

## Code Layout
The application begins with a login view if the user is not logged in. Alternatively, if the user doesn't have an account, they are directed to the registration process. This process is part of the RegLoginFlow.

The primary tabs of our app are situated within the NavigationFlow. This includes tabs leading to Settings, Connections, Team Builder, and Home views.

The TeamBuilder App encompasses additional views and functionalities, all encapsulated within the TeamBuildFlow. Within this flow, the FindMembers View allows users to select the individuals they require for their team.
The API file contains the necessary structs and classes, along with all the API calls made to our backend.

Login Info: SarahMiller@gmail.com Password: 1234567
Login Info: BryanLee@gmail.com Password: 1234567

## Testing and Building App
To build our app just clone the repository and run the app on the XCode simulator. We are hosting the backend on Heroku

IF it seems like the backend is not working where no users are showing up you might need to run the backend on your own. 
In the backend file you have to install the reqiurements using the command pip install  -r requirements.txt
you would need an API key to enter in the .env file
Once everything is set up, enter python app.py in the terminal to run it. THIS IS ONLY IF THE BACKEND DOESN'T WORK INITIALLY


# MileStone 2 Notes


## Third party libraries
We plan to use Apple CloudKit to stay native since it is pretty much integrated with SwiftUI and takes a burden away from authentication.
We also plan to use a styling library if need be since styling/ animations are something that takes a lot of time, and it would be easy to outsource it.
We are going to use PhoneNumberKit too since we have an OTP

## Apis
Firebase authentication API, Firebase FireStore with SwiftUI 

## Testing

We will have our roommates test the app and tell us how easy it was to make an account, and how intuitive the UI is, and have them rate it from one to 10. We will also ask them if they have any specific aspects of the UI they would want to be changed to make it more intuitive.

## Trello Board
https://trello.com/b/xOBGAbyp/maszina-board

# Sprint Planning 4

## Project Description
Our app revolutionizes team formation for computer science projects. With customizable profiles and a swipe-based interface akin to dating apps, users effortlessly find like-minded teammates based on tech expertise. Whether it's for hackathons or startup ventures, our app simplifies collaboration, providing the ideal platform to create your custom team that matches your needs and vision.

## Design
https://www.figma.com/file/yob2jpxYQR4JvoPlybnWfp/MasZina?type=design&node-id=0-1&mode=design&t=TgnGmMCK0L4CDCyf-0


### Meeting Notes
In our meeting we discussed an the flow of tream builder feature and how to handle different uses cases. we discussed the design and implementation of a team builder feature that leverages GPT for enhancing the process of finding team members and auto-filling skills. We outlined a user-centric approach beginning with project leaders providing a detailed project description. We decided how to handle the backend implemention for the feature.

### Individual tasks:

### Aariz Iqbal:
Done:
- worked on the ai api and finished connecting all the views
- added the matching feature
- fixed bugs in the ui

To Do:
- fix more bugs in the ui and work on the filterstion feature when doing a make team


Blocks:
None

### Isa Bukhari
Done:
- Researched Actors and how to implement
- Fixed UI bugs
- Created connections view and tab for requests

To Do:
- Polish Overall UI
- Implement accept request functionality
- Fix prompt for AI api request


Blocks:
- None

### Sajid Hussein
Done:
- Fixed UI bugs
- Helped implement and create the connectinsview
  
To Do:
- polish the ui and fix bugs
- implement connectionView Functionality

Blocks:
- None




