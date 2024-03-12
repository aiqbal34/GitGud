import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from flask import Flask, jsonify, request
from flask_cors import CORS
import json
from openai import OpenAI
import os
from dotenv import load_dotenv


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

@app.route('/createBasicAccount', methods=['POST'])
def createBasicAccountinDB():
    
    body_data = request.data
    #print(body_data)
    decoded_body_data = json.loads(body_data.decode('utf-8'))
    doc_ref = db.collection('private').document(decoded_body_data['userID'])
    doc_ref.set(decoded_body_data)
    public_ref = db.collection('shared').document(decoded_body_data['userID'])

    return jsonify({
        'message': "Successful"
        })

@app.route('/getCurrentUser')
def getCurrentUser():
    currUserID = request.args.get('currUser')
    # Assuming 'currUser' is a field in the 'private' document
    doc_ref = db.collection('private').document(currUserID)
    doc_snapshot = doc_ref.get()
    doc_snapshot.to_dict()
    # Check if the document exists
    if doc_snapshot.exists:
        user_data = doc_snapshot.to_dict()
        return jsonify(user_data)
    else:
        return jsonify({'error': 'User not found'}), 404

@app.route('/match')
def sendMatchToRequest():
    currUserID =  request.args.get('currUser')
    sentUserID =  request.args.get('sentUser')
    
    currRef = db.collection('private').document(currUserID)
    currRefDict = currRef.get().to_dict()
    
    sentRef = db.collection('private').document(sentUserID)
    sentRefDict = sentRef.get().to_dict()
    
    sentRefDict['requests'].append(currRefDict)
    
    sentRef.update(sentRefDict)
    
    
    
    return jsonify({
        'message': 'Successful'
    })
    
@app.route('/rejectRequest')
def rejectRequest():
    currUserID = request.args.get('currUser')
    rejectUserID = request.args.get('rejectedUser')
    currRef = db.collection('private').document(currUserID)
    currRefDict = currRef.get().to_dict()
    
    requests = currRefDict['requests']
    
    removedRequest = [request for request in requests if request['userID'] != rejectUserID]
    
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
    
    teams = currRefDict['teamRequests']
    removed_team = [team for team in teams if team_data != team]
    currRefDict['teamRequests'] = removed_team
    
    team_data['people'].append(currRefDict['name'])
    team_data['emails'].append(currRefDict['email'])
    team_data['ids'].append(currRefDict['userID'])
    
    for ids in team_data['ids']:
        temp_ref = db.collection('private').document(ids)
        temp_refDict = temp_ref.get().to_dict()
        for team in temp_refDict.get('teamConnections', []):
            if team.get('project', {}).get('projectName') == team_data['project']['projectName']:
                # Remove the current team connection if the project name matches
                temp_refDict['teamConnections'].remove(team)
        
        # Append team_data to the member's teamConnections
        temp_refDict.setdefault('teamConnections', []).append(team_data)
        
        temp_ref.update(temp_refDict)
                
    # Ensure that 'teamConnections' in currRefDict is an array
    currRefDict.setdefault('teamConnections', []).append(team_data)
    
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
    currRefRequests = [currRefRequest for currRefRequest in currRefRequests if currRefRequest.get('userID') != acceptUserID]
    currRefDict['requests'] = currRefRequests
    currRefDict['connections'].append(acceptRefDict)
    
    currRef.set(currRefDict)
    
   
    
    currRefDict['requests'] = []
    currRefDict['connections'] = []
    acceptRefDict['connections'].append(currRefDict)
    
    acceptRef.set(acceptRefDict)
    
    
    
    return jsonify({'message': 'Successful'}), 200


#TODO
@app.route('/sendTeamMatch', methods=['POST'])
def sendTeamMatch():
    sentUserID =  request.args.get('sentUser')
    sentRef = db.collection('private').document(sentUserID)
    sentRefDict = sentRef.get().to_dict()
    body_data = request.data
    
    team_data = json.loads(body_data.decode('utf-8'))

    sentRefDict['teamRequests'].append(team_data)
    
    sentRef.set(sentRefDict)
    
    return jsonify({'message': 'Successful'}), 200



@app.route('/createTeam', methods=['POST'])
def createTeam():
    currUserID =  request.args.get('currUser')

    body_data = request.data
    
    team_data = json.loads(body_data.decode('utf-8'))
    
    currRef = db.collection('private').document(currUserID)
    currRefDict = currRef.get().to_dict()
    
    team_data['people'].append(currRefDict['name'])
    team_data['emails'].append(currRefDict['email'])
    team_data['ids'].append(currRefDict['userID'])
    
    currRefDict['teamConnections'].append(team_data)
    
    currRef.set(currRefDict)
    return jsonify({'message': 'Successful'}), 200

@app.route('/findMember')
def filterMembers():
    skills = request.args.getlist('skills')
    user_experienceLevel = request.args.get('experienceLevel')

    candidates = []
    users_ref = db.collection('private')
    docs = users_ref.stream()

    for doc in docs:
        user = doc.to_dict()
        user_skills = user.get('skills', [])
        score = sum(skill in user_skills for skill in skills)
        if 'experienceLevel' in user and user['experienceLevel'] == user_experienceLevel:
            score += 3
        candidates.append({'user': user, 'score': score})

    compatible_candidates = sorted(candidates, key=lambda x: x['score'], reverse=True)

    # Extract only the original user dictionaries from the candidates list
    original_users = [candidate['user'] for candidate in compatible_candidates]

    print("this is the list:", original_users)

    # Continue with the rest of your code...

    # The original_users list contains the user dictionaries sorted by score.
    return jsonify(original_users)






# AI SECTION *************************************************

class Member:
    def __init__(self, string: str):
        self.number, self.skills, self.experienceLevel = self.extract_attributes(string)

    def extract_attributes(self, string: str):
        number = string[0]
        skills = []
        experienceLevel = ""

        string = string.replace("Skills: ", "")

        levels = ["Beginner", "Medium", "Experienced"]

        stringarr = string.split(",")
        print(stringarr)

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
    print(MemberList)
    
    for responseMember in MemberList:
        memberList.append(Member(responseMember).to_dict())

    return memberList

            
        




@app.route('/generateTeam', methods=['POST'])
def generate_team():
    
    body_data = request.data
    #print(body_data)
    decoded_body_data = json.loads(body_data.decode('utf-8'))
    completion = client.chat.completions.create(
    model="gpt-3.5-turbo",
    messages = [
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
                        Format your answer like, Member1: Beginner or Medium or experienced , Skills: List Only Five skills, make sure to only choose from {', '.join(map(str, SKILLS))}. Use commas as separators, do not give numbered list"
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

if __name__ == "__main__":
    app.run(debug=True)


#[{'number': '1', 'skills': 
# ['Experienced', 'Skills', 'JavaScript', 'React', 'Nodejs', 'APIs', 'Git\n\n'], 'experienceLevel': '1'}, 
# {'number': '2', 'skills': ['Experienced', 'Skills', 'UIUX', 'Design', 'User', 'Research', 'Wireframing', 'Prototyping', 'User', 'Empathy\n\n'], 'experienceLevel': '2'}, 
# {'number': '3', 'skills': ['Medium', 'Skills', 'Python', 'Django', 'SQL', 'Docker', 'Agile'], 'experienceLevel': '3'}]
