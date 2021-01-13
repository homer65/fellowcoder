import firebase_admin
from firebase_admin import credentials, firestore, storage


class Firestore:

    def __init__(self):
        super().__init__()
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
