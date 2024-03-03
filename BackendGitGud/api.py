import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from flask import Flask, jsonify, request
from flask_cors import CORS
import json

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
        collection_data.append(doc.to_dict())

    # Return the list as a JSON response
    return jsonify(collection_data)

@app.route('/createBasicAccount', methods=['POST'])
def test_putting_function():
    
    body_data = request.data
    print(body_data)
    
    decoded_body_data = json.loads(body_data.decode('utf-8'))
    
    
    doc_ref = db.collection('private').document(decoded_body_data['userID'])
    
    
    doc_ref.set(decoded_body_data)
    
    public_ref = db.collection('shared').document(decoded_body_data['userID'])
    
    

    return jsonify({
        'message': "Successful"
        })

if __name__ == "__main__":
    app.run(debug=True)
