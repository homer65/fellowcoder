from flask import Flask
from flask import request, jsonify
import time
from firestore import Firestore
import json
from flask_cors import CORS
from firebase_admin import auth
import datetime
from global_functions import url_to_date

debug=True
app = Flask(__name__)
CORS(app, supports_credentials=True)
fs = Firestore()




@app.route('/<name>',methods=['GET','POST'])
def controller(name):
    if debug: print("Debug:controller:01: ",name)
    erg = '{"return":"ko","detail":"unbekannt"}'
    if name == "register.py": erg = register()
    elif name == "login.py": erg = login()
    elif name == "aendern.py": erg = aendern()
    elif name == "suchen.py": erg = suchen()
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
    if id_token == "myoggradio" : return "myoggradio" 
    if debug: print("Debug:get_uid:01: ",id_token)
    user = auth.verify_id_token(id_token)
    return user["uid"]

def get_request_data():
    erg = json.loads(request.data);
    if debug: print("Debug:get_data:01: ",erg)
    return erg
    
def aendern():
    pseudonym = get_uid()
    data = get_request_data()
    return fs.aendern(pseudonym, data["feld"], data["wert"])      

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
    pseudonym = get_uid()
    if pseudonym == None: return 
    data = get_request_data()
    data["registriert"] = url_to_date(data["registriert"])
    data["lastlogin"] = url_to_date(data["lastlogin"])
    fs.set_Pseudonym(pseudonym, data)
    return '{"return":"ok"}'

def suchen():
    data = get_request_data()
    country = data["country"]
    coding_languages=data["coding_languages"]
    search_text=data["search_text"]
    erg = fs.suchen(country,coding_languages,search_text)
    return json.dumps(erg)

app.run()
