import firebase_admin
import time
from firebase_admin import credentials
from firebase_admin import firestore
# initializations 
cred = credentials.Certificate('key.json')
firebase_admin.initialize_app(cred)
db = firestore.client()
#reading all data
benutzer_ref = db.collection(u'benutzer')
benutzer = benutzer_ref.stream()
for doc in benutzer: 
    print(doc.to_dict())
#reading one data record
myoggradio_ref = db.collection('benutzer').document('myoggradio')
myoggradio = myoggradio_ref.get()
if myoggradio.exists:
    record = myoggradio.to_dict()
    print(record["name"])
#set a (new) record
record = {
        'name': 'Graaf',
        'vorname': 'Franz',
        'sprachen': ['java', 'python'],
		'lastlogin': time.time()
    }
db.collection('benutzer').document('FranzGraaf').set(record)
#update an existing record
myoggradio_ref = db.collection('benutzer').document('myoggradio')
myoggradio = myoggradio_ref.get()
if myoggradio.exists:
    record = myoggradio.to_dict()
    record["lastlogin"] = time.time()
    db.collection('benutzer').document('myoggradio').set(record)	
#Ausgabe Uhrzeit
print(time.time())