import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_textinput_v1.dart';
import 'package:Fellowcoder_Frontend/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cooky/cooky.dart' as cookie;

class Register extends StatefulWidget {
  static const String route = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _e_mail = "";
  String _passwort_0 = "";
  String _passwort_1 = "";
  bool _loading = false;

  bool _check_input() {
    if (_passwort_0.length < 6) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "Das Passwort ist zu kurz.",
          textAlign: TextAlign.center,
        ),
        duration: Duration(milliseconds: 1500),
      ));
      return false;
    }
    if (_passwort_0 != _passwort_1) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "Die Passwörter sind nicht identisch.",
          textAlign: TextAlign.center,
        ),
        duration: Duration(milliseconds: 1500),
      ));
      return false;
    }
    return true;
  }

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
            "Registrieren",
            style: TextStyle(fontSize: 30),
          ),
          Own_Textinput_V1(
            label: "E-Mail",
            on_changed: (value) {
              _e_mail = value;
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Own_Textinput_V1(
                label: "Passwort",
                obscure: true,
                on_changed: (value) {
                  _passwort_0 = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Own_Textinput_V1(
                label: "Passwort wiederholen",
                obscure: true,
                on_changed: (value) {
                  _passwort_1 = value;
                },
              ),
            ],
          ),
          _loading
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                )
              : RaisedButton(
                  color: global_color_highlight_1,
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    if (_check_input()) {
                      try {
                        global_user_data =
                            DB_User(); // create user data so it isnt null and it doesnt trigger the load in the firebase_auth listener in main.dart
                        String _id_token = await registerWithEmailPassword(
                            _e_mail, _passwort_0);
                        if ((await Backend_Com().create_user()).toString() ==
                            '{return: ok}') {
                          global_user_data = await Backend_Com().get_user();
                          Navigator.of(context).popAndPushNamed(Homepage.route);
                        } else {
                          global_user_data = null;
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Nutzer konnte nicht erstellt werden. Bitte erneut versuchen.",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(milliseconds: 1500),
                          ));
                        }
                      } on Exception catch (e) {
                        global_user_data = null;
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            e.toString(),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(milliseconds: 1500),
                        ));
                      }
                    }
                    setState(() {
                      _loading = false;
                    });
                  },
                  child: Text("Registrierung abschließen",
                      style: TextStyle(color: Colors.white)),
                )
        ],
      ),
    );
  }
}
