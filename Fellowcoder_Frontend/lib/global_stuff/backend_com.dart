import 'dart:convert';
import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:http/http.dart' as http;
import 'package:cooky/cooky.dart' as cookie;

class Backend_Com {
  static String _be_url = "http://127.0.0.1:5000";

  Future getdata(String url) async {
    refresh_id_token();
    var _header = {"id_token": cookie.get("id_token")};
    http.Response response = await http.get(url, headers: _header);
    return json.decode(response.body);
  }

  Future postdata(String url, dynamic data) async {
    refresh_id_token();
    var _header = {"id_token": cookie.get("id_token")};
    http.Response response = await http.post(url, body: data, headers: _header);
    return json.decode(response.body);
  }

  Future<String> get_image_from_storage(String image_name) async {
    // gets an public link to view an image from the storage
    String url =
        _be_url + "/get_image_from_storage?image=" + image_name.toString();
    String _storage_image = await Backend_Com().getdata(url);
    return _storage_image;
  }

  Future create_user() async {
    String url = _be_url + "/register.py";
    Map<String, dynamic> data = {
      "name": null,
      "vorname": null,
      "bildurl": null,
      "bild_name": null,
      "geburtsdatum": null,
      "land": "Deutschland",
      "beschreibungstext": null,
      "sprachen": [],
      "registriert": DateTime.now().toString(),
      "lastlogin": DateTime.now().toString(),
    };
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    return _response;
  }

  Future<DB_User> get_user() async {
    String url = _be_url + "/login.py";
    Map<String, dynamic> data = null;
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    return DB_User.fromJson(_response["detail"]);
  }

  Future change_userdata(String feld, dynamic wert) async {
    String url = _be_url + "/aendern.py";
    if (feld == "geburtsdatum") {
      wert = wert.toString();
    }
    Map<String, dynamic> data = {"feld": feld, "wert": wert};
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    return _response;
  }

  Future<List<DB_User>> get_search_data(
    Map<String, dynamic> search_data,
  ) async {
    String url = _be_url + "/suchen.py";
    Map<String, dynamic> data = search_data;
    print(data);
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    print(_response);
    _response = [
      DB_User(
          name: "Testnutzer1",
          sprachen: ["C#"],
          land: "Deutschland",
          beschreibungstext: "asdyxc"),
      DB_User(name: "Testnutzer2"),
      DB_User(name: "Testnutzer3"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer")
    ];
    return _response;
  }

  //TODO: chateintrag_erstellen
  //TODO: chateintrag_bei_nutzer_erstellen
  //TODO: chatnachricht_hinzufügen

  Future<List<Map<String, dynamic>>> get_complete_chat(
    String chat_id,
  ) async {
    String url = _be_url + "/get_complete_chat.py";
    /*Map<String, dynamic> data = {"chat_id": chat_id};
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    print(_response);*/
    var _response = [
      {"time": DateTime.now(), "user_id": "der", "text": "hi"},
      {"time": DateTime.now(), "user_id": "ich", "text": "hallo"},
      {"time": DateTime.now(), "user_id": "der", "text": "alles klar?"}
    ];
    return _response;
  }
}
