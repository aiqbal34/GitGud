import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from flask import Flask, jsonify, request
from flask_cors import CORS
import json
from openai import OpenAI
import os
from dotenv import load_dotenv
import random
from pydantic import BaseModel
import openai
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import time
from datetime import datetime, timedelta



SKILLS = [
    "HTML", "CSS", "JavaScript", "React", "Angular", "Vue.js",
    "Python", "Java", "C++", "PHP", "Ruby", "Go", "Node.js",
    "Assembly Language", "Swift", "Kotlin", "C#", "Perl",
    "Scala", "TypeScript", "Dart", "Haskell",
    "Bootstrap", "jQuery", "Express.js", "Django", "Spring",
    "Laravel", "TensorFlow", "PyTorch", "Keras",
    "Git", "Agile", "Waterfall", "Unit testing",
    "Integration testing", "APIs", "Web Services", "SQL",
    "NoSQL", "MySQL", "PostgreSQL", "MongoDB", "Oracle",
    "SQLite", "Cassandra", "CouchDB",
    "Docker", "Kubernetes", "Jenkins", "Ansible",
    "Heroku", "DigitalOcean", "Linode",
    "Software Design Patterns", "Formal Languages & Automata Theory",
    "Compiler Design", "Operating Systems Design", "Computer Architecture",
    "Distributed Systems", "Computer Graphics", "Human-Computer Interaction (HCI)",
    "Natural Language Processing (NLP)", "Computer Vision", "Robotics",
    "Software Engineering Principles",
    "User Research", "Usability Testing", "Information Architecture",
    "User Interface (UI) Design", "User Experience (UX) Writing", "Wireframing",
    "Prototyping", "Interaction Design", "Visual Design", "Accessibility",
    "UI/UX Design", "User Empathy", "Usability Heuristics",
    "User Persona Development", "Card Sorting", "A/B Testing", "User Flows",
    "Design Thinking", "Iterative Design", "User Interface (UI) Patterns",
    "Microinteractions", "Visual Communication", "Color Theory", "Typography", "SwiftUI", "XCode", "iOS Development"
]

# Load environment variables from .env file
load_dotenv()


client = OpenAI()

app = Flask(__name__)

CORS(app)


# Initialize Firebase with the service account key JSON file
cred = credentials.Certificate("serviceAccount.json")
firebase_admin.initialize_app(cred)

# Get a Firestore client
db = firestore.client()




@app.route('/')
def get_collection():
    # Reference to the "private" collection
    private_ref = db.collection('private')

    # Retrieve documents from the collection
    docs = private_ref.stream()

    # Accumulate documents into a list
    collection_data = []
    for doc in docs:
        docDict = doc.to_dict()
        if docDict['userID'] != request.args.get('currUser'):
            collection_data.append(docDict)

    # Return the list as a JSON response
    return jsonify(collection_data)

@app.route('/removeTeamMember', methods=['GET'])
def removeTeamMember():
    try:
        # Retrieve request parameters
        currUserID = request.args.get('currUser')
        currUserTeam = request.args.get('currTeam')
        removeUserID = request.args.get('UserToRemove')
        

        # Debugging prints
        print("This is the user to be removed:", removeUserID)
        # Can't remove Self
        if currUserID == removeUserID:
            return jsonify({'error': 'Unauthorized'}), 403
        
        

        # Fetch team document
        doc_ref_team = db.collection('team').document(currUserTeam)
        doc_team = doc_ref_team.get()
        if not doc_team.exists:
            return jsonify({'error': 'Team not found'}), 404
        team_data = doc_team.to_dict()
        print("team: ", team_data)

        # Fetch current user document
        doc_ref_currUser = db.collection('private').document(currUserID)
        doc_currUser = doc_ref_currUser.get()
        if not doc_currUser.exists:
            return jsonify({'error': 'Current user not found'}), 404
        curr_user_data = doc_currUser.to_dict()
        print("admin: ", curr_user_data)

        # Fetch removed user document
        doc_ref_removeUser = db.collection('private').document(removeUserID)
        doc_removeUser = doc_ref_removeUser.get()
        if not doc_removeUser.exists:
            return jsonify({'error': 'Current user not found'}), 404
        remove_user_data = doc_removeUser.to_dict()
        print("remove me: ", remove_user_data)

        # Authorization check
        if 'admin' not in team_data or team_data['admin'] != curr_user_data['userID']:
            return jsonify({'error': 'Unauthorized'}), 403
    
        # Remove user from team dictionary
        del team_data['people'][remove_user_data['name']]
        print(team_data['people'])
        doc_ref_team.update({'people': team_data['people']})

        # Remove team from user's connections
        if 'teamConnections' in remove_user_data and currUserTeam in remove_user_data['teamConnections']:
            remove_user_data['teamConnections'].remove(currUserTeam)
            doc_ref_removeUser.update({'teamConnections': remove_user_data['teamConnections']})
            return jsonify({'message': 'User removed successfully'}), 200
        else:
            return jsonify({'error': 'User to remove not found in the team'}), 404

    except Exception as e:
        print(f"Error type: {type(e).__name__}, Error details: {str(e)}")
        return jsonify({'error': 'Server Error', 'details': str(e)}), 500



@app.route('/createBasicAccount', methods=['POST'])
def createBasicAccountinDB():

    body_data = request.data
    # print(body_data)
    decoded_body_data = json.loads(body_data.decode('utf-8'))
    doc_ref = db.collection('private').document(decoded_body_data['userID'])
    doc_ref.set(decoded_body_data)
    public_ref = db.collection('shared').document(decoded_body_data['userID'])

    return jsonify({
        'message': "Successful"
    }), 200

@app.route('/updateUser', methods=['POST'])
def updateUser():
    currUserID = request.args.get('currUser')
    doc_ref = db.collection('private').document(currUserID)
    doc_refDict = doc_ref.get().to_dict()
    body_data = request.data
    # print(body_data)
    decoded_body_data = json.loads(body_data.decode('utf-8'))
    for key, value in decoded_body_data.items():
        # Check if the value is not None and it's not an empty list
        if value != "" and (not isinstance(value, list) or value):
            doc_refDict[key] = value
        if isinstance(value, list) and len(value) > 1:
            doc_refDict[key] = value
    doc_ref.update(doc_refDict)
    
    return jsonify({
        'message': "Successful"
    }), 200

@app.route('/getCurrentUser')
def getCurrentUser():
    currUserID = request.args.get('currUser')
    
    if not currUserID:
        return jsonify({'error': 'currUser parameter is required'}), 400
    
    doc_ref = db.collection('private').document(currUserID)
    doc_snapshot = doc_ref.get()
    
    if doc_snapshot.exists:
        user_data = doc_snapshot.to_dict()
        return jsonify(user_data)
    else:
        return jsonify({'error': 'User not found'}), 404

    
@app.route('/getCurrentUserTeams')
def getTeams():
    currUserID = request.args.get('currUser')
    doc_ref = db.collection('private').document(currUserID)
    doc_snapshot = doc_ref.get()
    userData = doc_snapshot.to_dict()
    
    userTeam = {'teamConnections' : [], 'teamRequests' : []}
    
    for teamRequest in userData['teamRequests']:
        teamRef = db.collection('team').document(teamRequest)
        teamRefData = teamRef.get().to_dict()
        if teamRefData:
            userTeam['teamRequests'].append(teamRefData)

    for teamConnection in userData['teamConnections']:
        teamRef = db.collection('team').document(teamConnection)
        teamRefData = teamRef.get().to_dict()
        if teamRefData:
            userTeam['teamConnections'].append(teamRefData)

    print(userTeam)
    return jsonify(userTeam), 200
    
    


@app.route('/match')
def sendMatchToRequest():
    currUserID = request.args.get('currUser')
    sentUserID = request.args.get('sentUser')

    currRef = db.collection('private').document(currUserID)
    currRefDict = currRef.get().to_dict()

    sentRef = db.collection('private').document(sentUserID)
    sentRefDict = sentRef.get().to_dict()

    sentRefDict['requests'].append(currRefDict)

    sentRef.update(sentRefDict)

    return jsonify({
        'message': 'Successful'
    }), 200


@app.route('/rejectRequest')
def rejectRequest():
    currUserID = request.args.get('currUser')
    rejectUserID = request.args.get('rejectedUser')
    currRef = db.collection('private').document(currUserID)
    currRefDict = currRef.get().to_dict()

    requests = currRefDict['requests']

    removedRequest = [
        request for request in requests if request['userID'] != rejectUserID]

    currRefDict['requests'] = removedRequest
    currRef.update(currRefDict)

    return jsonify({
        'message': 'Successful'
    }), 200


@app.route('/rejectTeamRequest', methods=['POST'])
def rejectTeamRequest():
    currUserID = request.args.get('currUser')
    currRef = db.collection('private').document(currUserID)
    currRefDict = currRef.get().to_dict()
    

    body_data = request.data

    team_data = json.loads(body_data.decode('utf-8'))

    teams = currRefDict['teamRequests']
    removed_team = [team for team in teams if team_data != team]
    currRefDict['teamRequests'] = removed_team
    currRef.update(currRefDict)

    return jsonify({
        'message': 'Successful'
    }), 200


@app.route('/acceptTeamRequest', methods=['POST'])
def acceptTeamRequest():
    currUserID = request.args.get('currUser')
    currRef = db.collection('private').document(currUserID)
    currRefDict = currRef.get().to_dict()

    body_data = request.data

    team_data = json.loads(body_data.decode('utf-8'))

    #Add it to the users team Connections
    currRefDict['teamConnections'].append(team_data)
    #Remove from the Requests
    removed_team = [team for team in currRefDict['teamRequests'] if team_data != team] 
    currRefDict['teamRequests'] = removed_team
    #Append the current user to the people in the Team
    teamRef = db.collection('team').document(team_data)
    teamRefDict = teamRef.get().to_dict()
    teamRefDict['people'][currRefDict['name']] = currRefDict['userID']
    teamRefDict['emails'].append(currRefDict['email'])
    teamRef.set(teamRefDict)

    # Ensure that 'teamConnections' in currRefDict is an array

    currRef.update(currRefDict)

    return jsonify({
        'message': 'Successful'
    }), 200


@app.route('/acceptRequestAccepter')
def acceptRequest():
    currUserID = request.args.get('currUser')
    acceptUserID = request.args.get('acceptUser')
    print(currUserID)
    print(acceptUserID)
    currRef = db.collection('private').document(currUserID)
    currRefDict = currRef.get().to_dict()
    acceptRef = db.collection('private').document(acceptUserID)
    acceptRefDict = acceptRef.get().to_dict()
    if currRefDict is None or acceptRefDict is None:
        return jsonify({'error': 'User not found'}), 404
    currRefRequests = currRefDict['requests']
    currRefRequests = [currRefRequest for currRefRequest in currRefRequests if currRefRequest.get(
        'userID') != acceptUserID]
    currRefDict['requests'] = currRefRequests
    currRefDict['connections'].append(acceptRefDict)

    currRef.set(currRefDict)

    currRefDict['requests'] = []
    currRefDict['connections'] = []
    acceptRefDict['connections'].append(currRefDict)

    acceptRef.set(acceptRefDict)

    return jsonify({'message': 'Successful'}), 200


# TODO
@app.route('/sendTeamMatch', methods=['POST'])
def sendTeamMatch():
    sentUserID = request.args.get('sentUser')
    sentRef = db.collection('private').document(sentUserID)
    sentRefDict = sentRef.get().to_dict()
    body_data = request.data
    print(body_data)

    team_data = json.loads(body_data.decode('utf-8'))

    sentRefDict['teamRequests'].append(team_data)

    sentRef.set(sentRefDict)

    return jsonify({'message': 'Successful'}), 200

@app.route('/createTeam', methods=['POST'])
def createTeam():
    try:
        # Get current user ID from query parameters
        currUserID = request.args.get('currUser')
        if not currUserID:
            return jsonify({'error': 'Missing current user ID'}), 400

        # Parse the JSON body of the request
        body_data = request.data
        team_data = json.loads(body_data.decode('utf-8'))

        # Retrieve current user's reference and data
        currRef = db.collection('private').document(currUserID)
        currRefDict = currRef.get().to_dict()
        if not currRefDict:
            return jsonify({'error': 'Current user not found'}), 404

        # Initialize 'teamConnections' if not present
        if 'teamConnections' not in currRefDict:
            currRefDict['teamConnections'] = []

        # Prepare team data with admin and people fields
        team_data['admin'] = currUserID  # Set current user as admin
        teamName = team_data['teamID']

        # Initialize 'people' field as a map {userID: userName}
        team_data['people'] = {currRefDict['name']: currUserID}

        # Create or update team document
        teamRef = db.collection('team')
        singleTeamRef = teamRef.document(teamName)
        singleTeamRef.set(team_data)

        # Update current user's team connections
        currRefDict['teamConnections'].append(teamName)
        currRef.update(currRefDict)

        return jsonify({'message': 'Team created successfully', 'teamID': teamName}), 200

    except Exception as e:
        return jsonify({'error': 'Server error', 'details': str(e)}), 500



@app.route('/findMember')
def filterMembers():
    skills = request.args.getlist('skills')
    user_experienceLevel = request.args.get('experienceLevel')

    candidates = []
    users_ref = db.collection('private')
    docs = users_ref.stream()

    for doc in docs:
        user = doc.to_dict()
        user_skills = user.get('techStack', [])
        score = sum(skill in user_skills for skill in skills)
        candidates.append({'user': user, 'score': score})

    compatible_candidates = sorted(
        candidates, key=lambda x: x['score'], reverse=True)

    # Extract only the original user dictionaries from the candidates list
    original_users = [candidate['user'] for candidate in compatible_candidates]

    

    # Continue with the rest of your code...

    # The original_users list contains the user dictionaries sorted by score.
    return jsonify(original_users)


# AI SECTION *************************************************

class Member:
    def __init__(self, string: str):
        self.number, self.skills, self.experienceLevel = self.extract_attributes(
            string)

    def extract_attributes(self, string: str):
        number = string[0]
        skills = []
        experienceLevel = ""

        string = string.replace("Skills: ", "")

        levels = ["Beginner", "Medium", "Experienced"]

        stringarr = string.split(",")
       

        for word in stringarr:
            # Check for the experience level
            for level in levels:
                if word.find(level) != -1:
                    experienceLevel = level
            # Check for skills
            if word.strip() in SKILLS:
                skills.append(word.strip())

        return number, skills, experienceLevel

    def to_dict(self) -> dict:
        member_dict = {}
        member_dict['number'] = self.number
        member_dict['skills'] = self.skills
        member_dict['experienceLevel'] = self.experienceLevel
        return member_dict


def extract_data(Members) -> list[dict]:
    memberList = []
    MemberList = Members.split("Member")
    MemberList.pop(0)
    

    for responseMember in MemberList:
        memberList.append(Member(responseMember).to_dict())

    return memberList


@app.route('/generateTeam', methods=['POST'])
def generate_team():

    body_data = request.data
    print(body_data)
    decoded_body_data = json.loads(body_data.decode('utf-8'))
    completion = client.chat.completions.create(
        model="gpt-3.5-turbo-0301",
        messages=[
            {
                "role": "system",
                "content": f"I want to build a project. Here are some details about it. I need {decoded_body_data['teamSize']} people working with me. \
                        The type of project is a {decoded_body_data['projectType']}. The name of the project is {decoded_body_data['projectName']}. \
                        Here is a brief description about what the project does: {decoded_body_data['description']}. What skills do the other members need? \
                        Here is a list of skills to choose from {', '.join(map(str, SKILLS))}"
            },
            {
                "role": "user",
                "content": f"I want you to choose the five most needed skills per member and list the possible experience level they need.\
                        If they can be a beginner and still work on it say so. Choose from beginner, medium, experienced. \
                        I want you to list it as Member1: Skills Needed: 1, 2, 3, 4, 5. \
                        Format your answer like, Member1: Beginner or Medium or experienced , Skills: List Only Five skills, make sure to only choose from {', '.join(map(str, SKILLS))}. Use commas as separators, do not give numbered list \
                        Make sure to only give {decoded_body_data['teamSize']} people."
            }
        ]
    )

    generated_message = completion.choices[0].message.content
    print(generated_message)
    data = extract_data(completion.choices[0].message.content)
    print(data)
    

    return jsonify(
        data
    )
# Web Scraping SECTION *************************************************


@app.route('/fetch_hackathons')
def fetch_hackathons():
    # Perform web scraping and store data in Firestore
    driver = setup_driver()
    driver.get('https://devpost.com/hackathons')
    hackathons = scroll_and_collect(driver)
    hackathon_data = extract_details(hackathons)
    driver.quit()
    
    # Store data in Firestore
    store_in_firestore(hackathon_data)
    hackathon_data = retrieve_from_firestore()

    return jsonify(hackathon_data)

def retrieve_from_firestore():
    hackathon_data = []
    docs = db.collection('hackathons').stream()
    for doc in docs:
        hackathon_data.append(doc.to_dict())
    return hackathon_data

def setup_driver():
    chrome_options = Options()  
    chrome_options.add_argument("--headless")  
    chrome_options.add_argument('log-level=3')  
    path_to_chromedriver = './chromedriver'
    service = Service(executable_path=path_to_chromedriver)
    return webdriver.Chrome(service=service, options=chrome_options)

def scroll_and_collect(driver, target_count=20):
    hackathons = []
    last_length = 0
    retries = 0
    max_retries = 5  

    while len(hackathons) < target_count and retries < max_retries:
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(2)
        html = driver.page_source
        soup = BeautifulSoup(html, 'lxml')
        hackathons = soup.find_all("div", class_="hackathon-tile")

        if len(hackathons) > last_length:
            last_length = len(hackathons)
        else:
            retries += 1  

        if len(hackathons) >= target_count:
            return hackathons[:target_count]

    return hackathons

def extract_details(hackathons):
    hackathon_data = []
    for hackathon in hackathons:
        image_tag = hackathon.find("img", class_="hackathon-thumbnail")
        image_url = "https:" + image_tag['src'] if image_tag and image_tag['src'].startswith("//") else image_tag['src'] if image_tag else "N/A"

        details = {
            "title": hackathon.find("h3", class_="mb-4").text.strip() if hackathon.find("h3", class_="mb-4") else "N/A",
            "status": hackathon.find("div", class_="status-label").text.strip() if hackathon.find("div", class_="status-label") else "N/A",
            "submission_period": hackathon.find("div", class_="submission-period").text.strip() if hackathon.find("div", class_="submission-period") else "N/A",
            "prize_amount": hackathon.find("div", class_="prize").text.strip() if hackathon.find("div", class_="prize") else "N/A",
            "participants": hackathon.find("div", class_="participants").text.strip() if hackathon.find("div", class_="participants") else "N/A",
            "location": hackathon.find("div", class_="info-with-icon").text.strip() if hackathon.find("div", class_="info-with-icon") else "N/A",
            "host": hackathon.find("span", class_="host-label").text.strip() if hackathon.find("span", class_="host-label") else "N/A",
            "themes": [theme.text.strip() for theme in hackathon.find_all("span", class_="theme-label")] if hackathon.find_all("span", class_="theme-label") else ["N/A"],
            "image_url": image_url
        }
        hackathon_data.append(details)
    return hackathon_data


def store_in_firestore(hackathon_data):
    # Clear existing hackathon data to avoid duplicates
    docs = db.collection('hackathons').stream()
    for doc in docs:
        doc.reference.delete()
        
    for hackathon in hackathon_data:
        db.collection('hackathons').add(hackathon)

if __name__ == '__main__':
    app.run(debug=True)
