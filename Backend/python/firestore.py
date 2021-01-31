import firebase_admin
from firebase_admin import credentials, firestore, storage
from global_functions import url_to_date

global anzahl_init_firebase
anzahl_init_firebase = 0

class Firestore:

    def __init__(self):
        super().__init__()
        global anzahl_init_firebase
        anzahl_init_firebase = anzahl_init_firebase + 1
        if anzahl_init_firebase <= 1:
            self.init_firestore_app()
        self.db = firestore.client()

    def init_firestore_app(self):
        cred = credentials.Certificate("key.json")
        self.default_app = firebase_admin.initialize_app(cred, {
        'storageBucket': u'fellowcoder-org-dev.appspot.com' 
        })
        self.default_bucket = storage.bucket()

    def get_bucket(self):
        return self.default_bucket
    
    def has_Pseudonym(self,pseudonym):
        dokument_ref = self.db.collection('benutzer').document(pseudonym)
        dokument = dokument_ref.get()
        if dokument.exists:
            return True
        return False

    def set_Pseudonym(self,pseudonym,daten):
        self.db.collection('benutzer').document(pseudonym).set(daten)
    
    def update_Pseudonym(self,pseudonym,daten):
        self.db.collection('benutzer').document(pseudonym).update(daten)

    def get_Benutzer(self,pseudonym):
        dokument_ref = self.db.collection('benutzer').document(pseudonym)
        dokument = dokument_ref.get()
        return dokument.to_dict()
    
    def aendern(self, pseudonym, feld, wert):
        try:
            if feld == "geburtsdatum":
                wert = url_to_date(wert)
            self.db.collection('benutzer').document(pseudonym).update({
                feld: wert,
            })
            return '{"return":"ok"}'
        except Exception as e:
            print(e)
            return '{"return":"ko"}'