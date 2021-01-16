from flask import Flask
from flask import request
import time
from firestore import Firestore
#import json

app = Flask(__name__)

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
    email = request.values.get("email")
    #sprachen_als_array = json.loads(request.data)["sprachen"]
    sprache1 = request.values.get("sprache1")
    sprache2 = request.values.get("sprache2")
    sprache3 = request.values.get("sprache3")
    sprache4 = request.values.get("sprache4")
    sprache5 = request.values.get("sprache5")
    sprachen = {}
    sprachen["sprache1"] = sprache1
    sprachen["sprache2"] = sprache2
    sprachen["sprache3"] = sprache3
    sprachen["sprache4"] = sprache4
    sprachen["sprache5"] = sprache5
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
    dict["email"] = email 
    dict["sprachen"] = sprachen 
    #dict["sprachen"] = ["Python", "PHP", "JAVA"] 
    dict["registriert"] = registriert 
    dict["lastlogin"] = lastlogin
    firestore.set_Pseudonym(pseudonym,dict)
    return '{"return":"ok"}'
    return erg
