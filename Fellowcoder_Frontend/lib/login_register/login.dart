import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_textinput_v1.dart';
import 'package:Fellowcoder_Frontend/homepage.dart';
import 'package:Fellowcoder_Frontend/login_register/register.dart';
import 'package:flutter/material.dart';
import 'package:cooky/cooky.dart' as cookie;

class Login extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _e_mail = "a.a@a.de"; // TODO: empty string "", value just for testing
  String _passwort = "123456"; // TODO: empty string "", value just for testing
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;

    return SizedBox(
      width: 310,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            global_language == Global_Language.ger ? "Login" : "Login",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Own_Textinput_V1(
                init_text: _e_mail,
                label: global_language == Global_Language.ger
                    ? "E-Mail"
                    : "E-Mail",
                on_changed: (value) {
                  _e_mail = value;
                },
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(Register.route);
                  },
                  child: Text(
                    global_language == Global_Language.ger
                        ? "noch kein Profil?"
                        : "no profile yet?",
                    style: TextStyle(fontSize: 12),
                  )),
              SizedBox(
                height: 10,
              ),
              Own_Textinput_V1(
                init_text: _passwort,
                label: global_language == Global_Language.ger
                    ? "Passwort"
                    : "Password",
                obscure: true,
                on_changed: (value) {
                  _passwort = value;
                },
              ),
              FlatButton(
                  onPressed: () {},
                  child: Text(
                    global_language == Global_Language.ger
                        ? "Passwort vergessen?"
                        : "Password forgotten?",
                    style: TextStyle(fontSize: 12),
                  ))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          ),
          _loading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(global_color_1),
                )
              : RaisedButton(
                  color: global_color_4,
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    try {
                      global_user_data =
                          DB_User(); // create user data so it isnt null and it doesnt trigger the load in the firebase_auth listener in main.dart
                      String _id_token =
                          await signInWithEmailPassword(_e_mail, _passwort);
                      global_user_data = await Backend_Com().get_user();
                      Navigator.of(context).popAndPushNamed(Homepage.route);
                    } on Exception catch (e) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          global_language == Global_Language.ger
                              ? "Eingaben überprüfen."
                              : "Check inputs.",
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(milliseconds: 1500),
                      ));
                    }
                    setState(() {
                      _loading = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 50,
                    child: Text(
                        global_language == Global_Language.ger
                            ? "Login"
                            : "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                )
        ],
      ),
    );
  }
}
