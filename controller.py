from flask import Flask
from flask import request
from postgres import Postgres

app = Flask(__name__)

@app.route('/<name>')
def controller(name):
    erg = "{unbekannt}"
    if name == "login.py": erg = login()
    elif name == "setpasswort.py" : erg = setpasswort()
    return erg

def setpasswort():
    erg = '{"return":"ok"}'
    benutzer = request.values.get("benutzer")
    passwort = request.values.get("passwort")
    if (not benutzer == None) and (not passwort == None):
        postgres = Postgres()
        passwort_hash = convert(passwort)
        postgres.setPasswort(benutzer,passwort_hash) 
    else:
        erg = '{"return":"ko"}'
    return erg       

def login():
    erg = '{"return":"ko"}'
    benutzer = request.values.get("benutzer")
    passwort = request.values.get("passwort")
    if (not benutzer == None) and (not passwort == None):
        postgres = Postgres()
        db_passwort = postgres.selectPasswort(benutzer)
        if db_passwort == convert(passwort): erg = '{"return":"ok"}'
        else:
            erg = '{return":ko","detail":"Passwort stimmt nicht"}'
    else: erg = '{return":ko","detail":"Benutzer oder Passwort nicht angegeben"'
    return erg

def convert(passwort):
    erg = "hash" + str(hash(bytes(passwort,'UTF-8')))
    return erg