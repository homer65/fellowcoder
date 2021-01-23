from flask import Flask
from flask import request
import time
from firestore import Firestore
import json
from flask_cors import CORS
from firebase_admin import auth

app = Flask(__name__)
CORS(app, supports_credentials=True)

@app.route('/<name>',methods=['GET','POST'])
def controller(name):
    erg = '{"return":"ko","detail":"unbekannt"}'
    if name == "register.py": erg = register()
    elif name == "login.py": erg = login()
    elif name == "aendern.py": erg = aendern()
    return erg 

def get_uid():
    id_token = request.headers["id_token"]
    if id_token == None: return "myoggradio" 
    user = auth.verify_id_token(id_token)
    return user["uid"]

def aendern():
    pseudonym = get_uid()
    if pseudonym == None: return '{"return":"ko","detail":"Kein Pseudonym vorgegeben"}'
    firestore = Firestore()
    if not firestore.has_Pseudonym(pseudonym): return '{"return":"ko","detail":"Pseudonym existiert nicht"}'
    dict = firestore.get_Benutzer(pseudonym)
    feld = request.values.get("feld")
    if feld == None: return '{"return":"ko","detail":"feld nicht angegeben"}'
    wert = request.values.get("wert")
    ok = False
    if feld == "beschreibungstext": ok = True
    elif feld == "bildurl": ok = True
    elif feld == "geburtsdatum": ok = True
    elif feld == "land": ok = True
    elif feld == "name": ok = True
    elif feld == "vorname": ok = True
    elif feld == "sprachen": ok = True
    if ok:
        dict[feld] = wert
        firestore.set_Pseudonym(pseudonym,dict)
        return '{"return":"ok"}'
    return '{"return":"ko","detail":"feld existiert nicht"}'
        

def login():
    pseudonym = get_uid()
    if pseudonym == None: return '{"return":"ko","detail":"Kein Pseudonym vorgegeben"}'
    firestore = Firestore()
    if not firestore.has_Pseudonym(pseudonym): return '{"return":"ko","detail":"Pseudonym existiert nicht"}'
    dict = firestore.get_Benutzer(pseudonym)
    dict_erg = {}
    dict_erg["return"] = "ok"
    dict_erg["detail"] = dict
    erg = json.dumps(dict_erg, indent = 4)
    return erg

def register():
    erg = '{"return":"ko"}'
    pseudonym = get_uid()
    if pseudonym == None: return '{"return":"ko","detail":"Kein Pseudonym vorgegeben"}'
    bildurl = request.values.get("bildurl")
    name = request.values.get("name")
    vorname = request.values.get("vorname")
    land = request.values.get("land")
    #sprachen = json.loads(request.data)["sprachen"]
    sprachen = json.loads(request.values.get("sprachen"))
    beschreibungstext = request.values.get("beschreibungstext")
    geburtsdatum = request.values.get("geburtsdatum")
    registriert = time.time()
    lastlogin = registriert
    firestore = Firestore()
    if firestore.has_Pseudonym(pseudonym): return '{"return":"ko","detail":"Pseudonym existiert schon"}'
    dict = {}
    dict["bildurl"] = bildurl
    dict["name"] = name
    dict["vorname"] = vorname
    dict["land"] = land  
    dict["sprachen"] = sprachen 
    dict["geburtsdatum"] = geburtsdatum
    dict["beschreibungstext"] = beschreibungstext 
    dict["registriert"] = registriert 
    dict["lastlogin"] = lastlogin
    firestore.set_Pseudonym(pseudonym,dict)
    return '{"return":"ok"}'
    return erg

app.run()
