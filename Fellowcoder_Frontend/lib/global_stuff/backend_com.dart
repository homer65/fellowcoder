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
    /*String url = _be_url + "/register.py";
    Map<String, dynamic> data = null;
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    print(_response);
    return _response;*/
    return true;
  }

  Future<DB_User> get_user() async {
    /*String url = _be_url + "/login.py";
    Map<String, dynamic> data = null;
    var _response = (await Backend_Com().postdata(url, jsonEncode(data)));
    print(_response);
    return DB_User.fromJson(jsonDecode(_response));*/
    return DB_User();
  }

  //TODO: userdaten einzeln ändern
}
