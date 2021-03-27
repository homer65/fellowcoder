import 'dart:convert';
import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:http/http.dart' as http;
import 'package:cooky/cooky.dart' as cookie;

class Backend_Com {
  static String _be_url =
      "http://127.0.0.1:5000"; // http://127.0.0.1:5000 // https://python-be-qw2twiy6eq-ey.a.run.app (development) //  https://python-be-xql2dlgaqa-ey.a.run.app (production)

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
    String url = _be_url + "/get_search_results.py";
    Map<String, dynamic> data = search_data;
    //print(data);
    Map _response1 = (await Backend_Com().postdata(url, jsonEncode(data)));
    //print(_response1);
    List<DB_User> _response = [];
    _response1.values.forEach((value) {
      _response.add(DB_User.fromJson(value));
    });
    /*_response = [
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
    ];*/
    return _response;
  }

  Future chateintrag_erstellen(String partner_id) async {
    String url = _be_url + "/chateintrag_erstellen.py";
    Map<String, dynamic> data = {"Id": partner_id};
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    return _response;
  }

  Future chatnachricht_hinzufuegen(String chat_id, String nachricht) async {
    String url = _be_url + "/chatnachricht_hinzufuegen.py";
    Map<String, dynamic> data = {"chat_id": chat_id, "nachricht": nachricht};
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    return _response;
  }

  Future<List<Map<String, dynamic>>> chateintrag_daten_lesen(
    String chat_id,
  ) async {
    String url = _be_url + "/chateintrag_daten_lesen.py";
    Map<String, dynamic> data = {"chat_id": chat_id};
    List<dynamic> _response =
        (await Backend_Com().postdata(url, jsonEncode(data)))["messages"];
    //print(_response);
    List<Map<String, dynamic>> _response_format = [];
    Map<String, dynamic> _respone_element;
    _response.forEach((value) {
      _respone_element = {};
      value.forEach((key, value) {
        _respone_element[key] = value;
      });
      _response_format.add(_respone_element);
    });
    return _response_format;
  }
}
