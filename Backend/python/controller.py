from flask import Flask
from flask import request
from flask_cors import CORS
import time
from firestore import Firestore
import json

app = Flask(__name__)
CORS(app, supports_credentials=True)

@app.route('/<name>')
def controller(name):
    erg = '{"return":"ko","detail":"unbekannt"}'
    if name == "register.py": erg = register()
    return erg 

def register():
    erg = '{"return":"ko"}'
    pseudonym = request.values.get("pseudonym")
    bildurl = request.values.get("bildurl")
    name = request.values.get("name")
    vorname = request.values.get("vorname")
    land = request.values.get("land")
    sprachen = json.loads(request.data)["sprachen"]
    beschreibungstext = request.values.get("beschreibungstext")
    geburtsdatum = request.values.get("geburtsdatum")
    registriert = time.time()
    lastlogin = registriert
    if pseudonym == None: return '{"return":"ko","detail":"Kein Pseudonym vorgegeben"}'
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