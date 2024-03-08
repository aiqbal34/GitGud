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
        "R", "Scala", "TypeScript", "Dart", "Haskell",
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
        "UI/UX Design Tools (e.g., Figma, Adobe XD)", "User Empathy", "Usability Heuristics",
        "User Persona Development", "Card Sorting", "A/B Testing", "User Flows",
        "Design Thinking", "Iterative Design", "User Interface (UI) Patterns",
        "Microinteractions", "Visual Communication", "Color Theory", "Typography"
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
    print(body_data)
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
    print(doc_snapshot.to_dict())
    # Check if the document exists
    if doc_snapshot.exists:
        user_data = doc_snapshot.to_dict()
        return jsonify(user_data)
    else:
        return jsonify({'error': 'User not found'}), 404

#TODO
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




# AI SECTION *************************************************

def extract_data(Members) -> list[dict]:
    print(Member)
    memberList = []
    MemberList = Members.split("Member")
    MemberList.pop(0)
    for responseMember in MemberList:
        print(responseMember)
        memberList.append(Member(responseMember).to_dict())
        
    return memberList


        
class Member:
    def __init__(self, string: str):
        self.number, self.skills, self.experienceLevel = self.extract_attributes(string)

    def extract_attributes(self, string: str):
        
        number = string[0]
        filteredString = "".join(char if char.isalnum() or char.isspace() else "" for char in string)
        filteredString = filteredString.replace("Skills:", "")
        stringarr = filteredString.split(" ")
        experienceLevel = stringarr.pop(0)
        skills = stringarr
        for skill in skills:
            skill.strip()

        return number, skills, experienceLevel

    def to_dict(self) -> dict:
        member_dict = {}
        member_dict['number'] = self.number
        member_dict['skills'] = self.skills
        member_dict['experienceLevel'] = self.experienceLevel
        return member_dict

        
            
        




@app.route('/generateTeam', methods=['POST'])
def generate_team():
    
    body_data = request.data
    print(body_data)
    decoded_body_data = json.loads(body_data.decode('utf-8'))
    completion = client.chat.completions.create(
    model="gpt-3.5-turbo",
messages = [
    {
        "role": "system",
        "content": f"I want to build a project. Here are some details about it. I need {decoded_body_data['teamSize']} people working with me. The type of project is a {decoded_body_data['projectType']}. The name of the project is {decoded_body_data['projectName']}. Here is a brief description about what the project does: {decoded_body_data['response']}. What skills do the other members need? Here is a list of skills to choose from {', '.join(map(str, SKILLS))}"
    },
    {
        "role": "user",
        "content": f"I want you to choose the five most needed skills per member and list the possible experience level they need. If they can be a beginner and still work on it say so. Choose from beginner, medium, experienced. I want you to list it as Member1: Skills Needed: 1, 2, 3, 4, 5. Format your answer like, Member1: (Beginner, Medium, Experienced ), Skills"
    }
]
    )
    
    generated_message = completion.choices[0].message.content
    print(generated_message)
     
    print(extract_data(completion.choices[0].message.content))
    
    return jsonify({
        'response' : generated_message
    })

if __name__ == "__main__":
    app.run(debug=True)


#[{'number': '1', 'skills': 
# ['Experienced', 'Skills', 'JavaScript', 'React', 'Nodejs', 'APIs', 'Git\n\n'], 'experienceLevel': '1'}, 
# {'number': '2', 'skills': ['Experienced', 'Skills', 'UIUX', 'Design', 'User', 'Research', 'Wireframing', 'Prototyping', 'User', 'Empathy\n\n'], 'experienceLevel': '2'}, 
# {'number': '3', 'skills': ['Medium', 'Skills', 'Python', 'Django', 'SQL', 'Docker', 'Agile'], 'experienceLevel': '3'}]
