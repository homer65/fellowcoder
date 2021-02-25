import firebase_admin
from firebase_admin import credentials, firestore, storage
from global_functions import url_to_date
from test.test_tempfile import TestGetCandidateNames
from datetime import datetime

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
    
    def addChatToUser(self, pseudonym, chatid, partner):
        dokument_ref = self.db.collection('benutzer').document(pseudonym)
        dokument = dokument_ref.get()
        if dokument.exists:
            pydokument = dokument.to_dict()
            try:
                chats = pydokument["chats"]
            except:
                chats = {}
            chats[chatid] = partner
            self.db.collection('benutzer').document(pseudonym).update({"chats":chats})
            return

    def addChat(self, chatid, user):
        daten = {}
        jetzt = str(datetime.now())
        daten[jetzt] = {"user":user,"text":""}
        self.db.collection('chats').document(chatid).set(daten) 
        return
    
    def addChatNachricht(self, pseudonym, chatid, nachricht):
        dokument_ref = self.db.collection('chats').document(chatid)
        dokument = dokument_ref.get()
        if dokument.exists:
            pydokument = dokument.to_dict()
            jetzt = str(datetime.now())
            pydokument[jetzt] = {"user":pseudonym,"text":nachricht}
            self.db.collection('chats').document(chatid).set(pydokument)
            
    def getChat(self, chatid):
        dokument_ref = self.db.collection('chats').document(chatid)
        dokument = dokument_ref.get()
        if dokument.exists:
            pydokument = dokument.to_dict()
            return pydokument
        else:
            return {"return":"ko"}
    
    def suchen(self,country,coding_languages,search_text):
        erg = {}
        benutzer_ref = self.db.collection('benutzer')
        benutzer = benutzer_ref.stream()
        for doc in benutzer:
            data = doc.to_dict()
            if self.test_suchkriterien(data,country,coding_languages,search_text): erg[doc.id] = data
        return erg
    
    def test_suchkriterien(self,data,country,coding_languages,search_text):
        erg = True
        if not country == "None":
            try:
                if not data["land"] == country: erg = False
            except:
                erg = False
        if not search_text == "None":
            try:
                if data["beschreibungstext"].find(search_text) == -1 : erg = False
            except:
                erg = False
        if not coding_languages == "None":
            ok = False
            for language in coding_languages:
                try:
                    for test_language_key in data["sprachen"]:
                        if language == test_language_key: ok = True
                except:
                    ok = False
            if not ok: erg = False
        return erg