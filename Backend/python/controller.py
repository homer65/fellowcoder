from flask import Flask
from flask import request, jsonify
import time
from firestore import Firestore
import json
from flask_cors import CORS
from firebase_admin import auth
import datetime
from global_functions import url_to_date

app = Flask(__name__)
CORS(app, supports_credentials=True)
fs = Firestore()




@app.route('/<name>',methods=['GET','POST'])
def controller(name):
    erg = '{"return":"ko","detail":"unbekannt"}'
    if name == "register.py": erg = register()
    elif name == "login.py": erg = login()
    elif name == "aendern.py": erg = aendern()
    return erg 

def get_storage_image(image):
    # START possible solution to prohibit a backend error by loading an event incorrectly --------------
    if image == "" or image == None:
        return "" 
    tries = 1
    while tries > 0:
        try:
            blob = fs.get_bucket().blob(image)
            blob.make_public()
            tries = 0
        except Exception as e:
            tries -= 1
            #time.sleep(1.5)
    # END possible solution to prohibit a backend error by loading an event incorrectly --------------
    return blob.public_url

@app.route('/get_image_from_storage', methods=["GET"])
def get_image_from_storage():
    try:
        image = get_storage_image(str(request.args["image"]))
        return jsonify(image)
    except Exception as e:
        print(e)
    return jsonify("0")

def get_uid():
    id_token = request.headers["id_token"]
    if id_token == None: return "myoggradio" 
    print(id_token)
    user = auth.verify_id_token(id_token)
    return user["uid"]

def aendern():
    pseudonym = get_uid()
    return fs.aendern(pseudonym, json.loads(request.data)["feld"], json.loads(request.data)["wert"])
    """if pseudonym == None: return '{"return":"ko","detail":"Kein Pseudonym vorgegeben"}'
    if not fs.has_Pseudonym(pseudonym): return '{"return":"ko","detail":"Pseudonym existiert nicht"}'
    dict = fs.get_Benutzer(pseudonym)
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
        fs.set_Pseudonym(pseudonym,dict)
        return '{"return":"ok"}'
    return '{"return":"ko","detail":"feld existiert nicht"}'"""
        

def login():
    pseudonym = get_uid()
    if pseudonym == None: return '{"return":"ko","detail":"Kein Pseudonym vorgegeben"}'
    if not fs.has_Pseudonym(pseudonym): return '{"return":"ko","detail":"Pseudonym existiert nicht"}'
    data = fs.get_Benutzer(pseudonym)
    data["Id"] = pseudonym
    dict_erg = {}
    dict_erg["return"] = "ok"
    dict_erg["detail"] = data
    erg = json.dumps(dict_erg, default=str, indent = 4)
    return erg


def register():
    #erg = '{"return":"ko"}'
    pseudonym = get_uid()
    if pseudonym == None: return '{"return":"ko","detail":"Kein Pseudonym vorgegeben"}'
    """bildurl = json.loads(request.data)["bildurl"]#request.values.get("bildurl")
    name = json.loads(request.data)["name"] #request.values.get("name")
    vorname = json.loads(request.data)["vorname"] #request.values.get("vorname")
    land = json.loads(request.data)["land"] #request.values.get("land")
    #sprachen = json.loads(request.data)["sprachen"]
    sprachen = json.loads(request.data)["sprachen"] #json.loads(request.values.get("sprachen"))
    beschreibungstext = json.loads(request.data)["beschreibungstext"] #request.values.get("beschreibungstext")
    geburtsdatum = json.loads(request.data)["geburtsdatum"] #request.values.get("geburtsdatum")
    registriert = time.time()
    lastlogin = registriert
    if fs.has_Pseudonym(pseudonym): return '{"return":"ko","detail":"Pseudonym existiert schon"}'
    dict = {}
    dict["bildurl"] = bildurl
    dict["name"] = name
    dict["vorname"] = vorname
    dict["land"] = land  
    dict["sprachen"] = sprachen 
    dict["geburtsdatum"] = geburtsdatum
    dict["beschreibungstext"] = beschreibungstext 
    dict["registriert"] = registriert 
    dict["lastlogin"] = lastlogin"""
    data = json.loads(request.data)
    data["registriert"] = url_to_date(data["registriert"])
    data["lastlogin"] = url_to_date(data["lastlogin"])
    #data = {"name": None, "vorname": None, "bildurl": None, "bild_name": None, "geburtsdatum": None, "land": None, "beschreibungstext": None, "sprachen": [], "registriert": datetime.datetime.now(), "lastlogin": datetime.datetime.now(),}
    fs.set_Pseudonym(pseudonym, data)#dict) # ich würde eine Variable nicht genau so nennen wie schon ein Datentyp heißt
    return '{"return":"ok"}'
    #return erg




app.run()
