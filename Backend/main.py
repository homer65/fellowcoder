from flask import Flask
from flask import request, jsonify
import time
from firestore import Firestore
import json
from flask_cors import CORS
from firebase_admin import auth
import datetime
from global_functions import url_to_date
import os

debug=True
app = Flask(__name__)
CORS(app, supports_credentials=True)
fs = Firestore()




"""@app.route('/<name>',methods=['GET','POST'])
def controller(name):
    if debug: print("Debug:controller:01: ",name)
    erg = '{"return":"ko","detail":"unbekannt"}'
    if name == "register.py": erg = register()
    elif name == "login.py": erg = login()
    elif name == "aendern.py": erg = aendern()
    elif name == "get_search_results.py": erg = get_search_results()
    elif name == "chateintrag_erstellen.py": erg = chateintrag_erstellen()
    elif name == "chatnachricht_hinzufuegen.py": erg = chatnachricht_hinzufuegen()
    elif name == "chateintrag_daten_lesen.py": erg = chateintrag_daten_lesen()
    return erg """

# START other functions --------------------------------------------------------------------------------------------------------------------
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
    if id_token == "null" : return ""
    else:
        user = auth.verify_id_token(id_token)
        return user["uid"]
# END other functions --------------------------------------------------------------------------------------------------------------------


# START interactions --------------------------------------------------------------------------------------------------------------------
@app.route('/get_search_data', methods=["POST"])
def get_search_data():
    pseudonym = get_uid()
    data = get_request_data()
    try:
        country = data["country"]
    except:
        country = "None"
    try:
        coding_languages = data["coding_languages"]
    except:
        coding_languages = "None"
    try:
        search_text=data["search_text"]
    except:
        search_text="None"
    if country == "" : country = "None"
    if coding_languages == [] : coding_languages = "None"
    if search_text == "" : search_text = "None"
    erg = fs.suchen(country,coding_languages,search_text,pseudonym)
    return json.dumps(erg,default=str)

@app.route('/create_user', methods=["POST", "GET"])
def create_user():
    pseudonym = get_uid()
    if pseudonym == None: return '{"return":"nok"}'
    data = get_request_data()
    data["registriert"] = url_to_date(data["registriert"])
    data["lastlogin"] = url_to_date(data["lastlogin"])
    fs.set_Pseudonym(pseudonym, data)
    return '{"return":"ok"}'

@app.route('/get_user', methods=["POST", "GET"])
def get_user():
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

    
def get_request_data():
    erg = json.loads(request.data);
    if debug: print("Debug:get_data:01: ",erg)
    return erg
    
def aendern():
    pseudonym = get_uid()
    data = get_request_data()
    return fs.aendern(pseudonym, data["feld"], data["wert"])      








def chateintrag_erstellen():
    pseudonym = get_uid()
    data = get_request_data()
    partner = data["Id"]
    chatid = pseudonym + partner
    ok = True
    rc = fs.addChatToUser(pseudonym,chatid,partner)
    if not rc: ok = False
    rc = fs.addChatToUser(partner,chatid,pseudonym)
    if not rc: ok = False
    if ok:
        fs.addChat(chatid,pseudonym)
        return '{"return":"ok"}'
    return '{"return":"ko"}'

def chatnachricht_hinzufuegen():
    pseudonym = get_uid()
    data = get_request_data()
    chatid = data["chat_id"]
    nachricht = data["nachricht"]
    fs.addChatNachricht(pseudonym,chatid,nachricht)
    return '{"return":"ok"}'

def chateintrag_daten_lesen():
    # pseudonym = get_uid()
    data = get_request_data()
    chatid = data["chat_id"]
    chat = fs.getChat(chatid)
    return json.dumps(chat,default=str)
# END interactions --------------------------------------------------------------------------------------------------------------------



app.run() # for development
#app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080))) # for production