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
    String url = _be_url + "/get_search_results.py";
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
      {"time": DateTime.now().toString(), "user_id": "der", "text": "hi"},
      {"time": DateTime.now().toString(), "user_id": "ich", "text": "hallo"},
      {
        "time": DateTime.now().toString(),
        "user_id": "der",
        "text": "alles klar?"
      },
      {
        "time": DateTime.now().toString(),
        "user_id": "ich",
        "text":
            """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec mattis est dui, at laoreet est malesuada a. Pellentesque rhoncus euismod lacus nec mollis. Morbi fermentum eros a velit vestibulum, vel dictum enim finibus. Etiam in urna mi. Nullam ac blandit neque. Suspendisse non viverra risus. Suspendisse porta turpis urna, id volutpat sem tempor eu. Sed neque diam, fermentum sit amet egestas eu, elementum non felis.

Maecenas id ligula at nunc suscipit laoreet nec tristique ligula. Quisque consectetur condimentum lacus in pulvinar. Aenean malesuada, nibh sed facilisis mattis, orci ante dapibus turpis, vitae aliquet sapien arcu at massa. Pellentesque pellentesque facilisis turpis commodo pulvinar. Mauris quam eros, tempus id sem vel, aliquam tristique neque. Curabitur ante neque, interdum vel egestas eu, egestas quis dolor. Fusce neque risus, auctor non bibendum vel, faucibus quis nibh.

Mauris accumsan euismod nisi eu efficitur. Vestibulum cursus nec felis ac tristique. Vestibulum ut commodo nibh. Integer fringilla egestas felis, a iaculis magna dapibus eu. Curabitur placerat quam quis massa varius mollis. Sed laoreet libero eget molestie placerat. Vestibulum et diam eu dui imperdiet ornare. Duis in commodo sapien. Nam ornare mi at odio ornare, sed dignissim ante lobortis. Cras vel placerat tellus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis in tortor eget mi iaculis cursus in eget massa.

Mauris cursus risus vitae sodales hendrerit. Praesent dictum interdum posuere. Nam lobortis ornare ex, in pharetra arcu eleifend pulvinar. Donec euismod, tortor nec luctus fringilla, purus dui rhoncus dui, eget feugiat felis urna id mi. Nulla luctus eros mi, sed volutpat quam hendrerit at. Sed dui lorem, aliquet nec massa at, gravida venenatis turpis. Vivamus rutrum, erat sagittis maximus venenatis, augue augue maximus nisl, non venenatis mauris libero eu tellus. Donec eu dolor dolor. Duis id feugiat augue. Sed non purus et sem mollis aliquam. Interdum et malesuada fames ac ante ipsum primis in faucibus."""
      }
    ];
    return _response;
  }
}
