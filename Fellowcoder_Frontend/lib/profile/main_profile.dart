import 'dart:async';

import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/basic_image.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/image_web_picker.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_coding_language_selection.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_country_select_dropdown.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_submittable_text_input.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_textinput_v1.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/text_date_picker.dart';
import 'package:Fellowcoder_Frontend/profile/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:cooky/cooky.dart' as cookie;

enum Profile_Change_Data { email, password }
Map<String, dynamic> click_change_weekday_data;

class Main_Profile extends StatefulWidget {
  static const String route = '/main_profile';
  DB_User data;
  String user_id;
  Main_Profile({this.data, this.user_id = ""});
  @override
  _Main_ProfileState createState() => _Main_ProfileState();
}

class _Main_ProfileState extends State<Main_Profile> {
  DB_User _user_data;
  bool _userview;
  TextEditingController _name_controller = TextEditingController();
  TextEditingController _description_controller = TextEditingController();
  bool _loading = true;
  StreamSubscription _subscription;
  String _age = "-";
  String _description = "-";

  Future<void> _change_data(
      Profile_Change_Data pcd, BuildContext n_context) async {
    Widget _content() {
      switch (pcd) {
        case Profile_Change_Data.email:
          return Main_Profile_Change_Email(
            context: n_context,
          );
        case Profile_Change_Data.password:
          return Main_Profile_Change_Password(
            context: n_context,
          );
        default:
          return Container();
      }
    }

    return showGeneralDialog<void>(
        pageBuilder: (context, anim1, anim2) {
          return Stack(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.black)),
                  width: 300,
                  height: 300,
                  child: _content(),
                ),
              )
            ],
          );
        },
        context: context,
        barrierDismissible: true, // true = user can tab barrier to close
        barrierLabel: "barrierLabel",
        barrierColor: Colors.grey.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 250),
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
            scale: anim1.value,
            child: child,
          );
        }).then((value) {
      Scaffold.of(n_context).removeCurrentSnackBar();
      setState(() {});
    });
  }

  void initialise() async {
    if (cookie.get("id_token") == null || cookie.get("id_token") == "") {
      _userview = true;
    } else {
      if (global_user_data == null) {
        _loading = true;
        return;
      } else {
        _userview = !(widget.user_id == global_user_data.id);
      }
    }
    if (_userview) {
      if (widget.data == null) {
        _loading = true;
        widget.data = await Backend_Com().get_user_userview(widget.user_id);
        _user_data = widget.data;
      } else {
        _user_data = widget.data;
      }
    } else {
      //print(global_user_data.name);
      if (global_user_data == null) {
        _loading = true;
        return;
      }
      if (global_user_data.name == null) {
        _loading = true;
        return;
      } else {
        _user_data = global_user_data;
      }
    }
    _name_controller.text = _user_data.name;
    _description_controller.text = _user_data.beschreibungstext;
    if (_user_data.geburtsdatum != null) {
      _age = (DateTime.now().year - _user_data.geburtsdatum.year).toString();
    }
    if (_user_data.beschreibungstext != null &&
        _user_data.beschreibungstext != "") {
      _description = _user_data.beschreibungstext;
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _subscription = global_rebuild_controller.stream.listen((data) {
      initialise();
      setState(() {});
    });
    _loading = true;
    initialise();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;

    return _loading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(global_color_1),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: global_color_1.withOpacity(0.3),
                  child: Column(
                    children: [
                      SizedBox(
                        height: _on_mobile ? 10 : 10,
                      ),
                      _userview
                          ? Container()
                          : SizedBox(
                              width: _screen_size.width,
                              child: Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          width: 250,
                                          child: Own_Textinput_V1(
                                            init_text:
                                                auth_firebase.currentUser.email,
                                            label: global_language ==
                                                    Global_Language.ger
                                                ? "E-Mail"
                                                : "E-Mail",
                                            enabled: false,
                                          )),
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            _change_data(
                                                Profile_Change_Data.email,
                                                context);
                                          })
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          width: 250,
                                          child: Own_Textinput_V1(
                                            init_text: "xxxxxxxxx",
                                            label: global_language ==
                                                    Global_Language.ger
                                                ? "Passwort"
                                                : "Password",
                                            enabled: false,
                                            obscure: true,
                                          )),
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            _change_data(
                                                Profile_Change_Data.password,
                                                context);
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      _userview
                          ? SizedBox()
                          : SizedBox(
                              height: _on_mobile ? 30 : 60,
                            ),
                      _userview
                          ? Basic_Image(
                              _user_data.bildurl,
                              width: 200,
                              height: 200,
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.all(10),
                              shadow: true,
                            )
                          : Image_Web_Picker(
                              key: ValueKey(_user_data.bildurl),
                              image: _user_data.bildurl,
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.all(10),
                              shadow: true,
                              old_image_path: _user_data.bild_name,
                              upload_begins: () {},
                              upload_done: (name, link) async {
                                setState(() {
                                  _user_data.bild_name = name;
                                  _user_data.bildurl = link;
                                });
                                Backend_Com().change_userdata(
                                    "bildurl", _user_data.bildurl);
                                Backend_Com().change_userdata(
                                    "bild_name", _user_data.bild_name);
                              },
                              picture_deleted: (name) async {
                                setState(() {
                                  _user_data.bild_name = "";
                                  _user_data.bildurl = "";
                                });
                                Backend_Com().change_userdata(
                                    "bildurl", _user_data.bildurl);
                                Backend_Com().change_userdata(
                                    "bild_name", _user_data.bild_name);
                              },
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      _userview
                          ? RaisedButton(
                              onPressed: () async {
                                if (global_usertype == Usertype.user) {
                                  await Backend_Com().chateintrag_erstellen(
                                      _user_data.id, _user_data.bildurl);
                                  global_user_data.chats.add({
                                    "chat_id":
                                        global_user_data.id + _user_data.id,
                                    "partner_name": _user_data.name,
                                    "partner_id": _user_data.id,
                                    "partner_picture": _user_data.bildurl,
                                    "last_message_time": null
                                  });
                                }
                                Navigator.of(context)
                                    .pushNamed(Chat_View.route);
                              },
                              child: Text(global_language == Global_Language.ger
                                  ? "Chat"
                                  : "Chat"),
                              color: global_color_1,
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      _userview
                          ? Text(_user_data.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ))
                          : Own_Submittable_Text_Input(
                              _name_controller,
                              enabled: !_userview,
                              on_changed: (value) {},
                              submitted: (value) {
                                Backend_Com().change_userdata("name", value);
                                _user_data.name = value;
                              },
                              aborted: () {},
                              label_text: global_language == Global_Language.ger
                                  ? "Name"
                                  : "Name",
                              max_lines: 1,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Own_Country_Select_Dropdown(
                        enabled: !_userview,
                        init_value: _user_data.land,
                        on_change: (country) {
                          _user_data.land = country;
                          Backend_Com()
                              .change_userdata("land", _user_data.land);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _userview
                          ? Text(
                              global_language == Global_Language.ger
                                  ? "Alter: "
                                  : "Age: " + _age,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ))
                          : Text_Date_Picker(
                              enabled: !_userview,
                              onValueChanged: (value) {
                                _user_data.geburtsdatum = value;
                                Backend_Com().change_userdata(
                                    "geburtsdatum", _user_data.geburtsdatum);
                              },
                              label: global_language == Global_Language.ger
                                  ? "Geburtsdatum"
                                  : "Birthday",
                              date: _user_data.geburtsdatum,
                              first_date: DateTime.now()
                                  .subtract(Duration(days: 100000)),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        global_language == Global_Language.ger
                            ? "Skills"
                            : "Skills",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 3,
                        color: global_color_1,
                      ),
                      Own_Coding_Language_Selection(
                        enabled: !_userview,
                        coding_language_list: _user_data.sprachen,
                        on_change: () {
                          Backend_Com()
                              .change_userdata("sprachen", _user_data.sprachen);
                        },
                      ),
                      Container(
                        height: 3,
                        color: global_color_1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _userview
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                    global_language == Global_Language.ger
                                        ? "Beschreibung:"
                                        : "personal description:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(_description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ],
                            )
                          : Own_Submittable_Text_Input(
                              _description_controller,
                              enabled: !_userview,
                              on_changed: (value) {},
                              submitted: (value) {
                                Backend_Com().change_userdata(
                                    "beschreibungstext", value);
                                _user_data.beschreibungstext = value;
                              },
                              aborted: () {},
                              label_text: global_language == Global_Language.ger
                                  ? "Beschreibung"
                                  : "personal description",
                            ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class Main_Profile_Change_Email extends StatefulWidget {
  BuildContext context;
  Main_Profile_Change_Email({this.context});
  @override
  _Main_Profile_Change_EmailState createState() =>
      _Main_Profile_Change_EmailState();
}

class _Main_Profile_Change_EmailState extends State<Main_Profile_Change_Email> {
  String _new_email = auth_firebase.currentUser.email;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 250,
              child: Own_Textinput_V1(
                init_text: auth_firebase.currentUser.email,
                label: global_language == Global_Language.ger
                    ? "neue E-Mail"
                    : "new E-Mail",
                enabled: true,
                on_changed: (value) {
                  _new_email = value;
                },
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                color: global_color_1,
                onPressed: () async {
                  try {
                    await auth_firebase.currentUser.updateEmail(_new_email);
                    Navigator.of(context).pop();
                  } catch (e) {
                    Scaffold.of(widget.context).showSnackBar(SnackBar(
                      content: Text(
                        e.toString(),
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(milliseconds: 1500),
                    ));
                  }
                },
                child: Text(global_language == Global_Language.ger
                    ? "Ändern"
                    : "Change"),
              ),
              RaisedButton(
                color: global_color_4,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(global_language == Global_Language.ger
                    ? "Abbrechen"
                    : "Cancel"),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Main_Profile_Change_Password extends StatefulWidget {
  BuildContext context;
  Main_Profile_Change_Password({this.context});
  @override
  _Main_Profile_Change_PasswordState createState() =>
      _Main_Profile_Change_PasswordState();
}

class _Main_Profile_Change_PasswordState
    extends State<Main_Profile_Change_Password> {
  String _passwort_0 = "";
  String _passwort_1 = "";

  bool _check_input() {
    Scaffold.of(widget.context).removeCurrentSnackBar();
    if (_passwort_0.length < 6) {
      Scaffold.of(widget.context).showSnackBar(SnackBar(
        content: Text(
          global_language == Global_Language.ger
              ? "Das Passwort ist zu kurz."
              : "The password is too short.",
          textAlign: TextAlign.center,
        ),
        duration: Duration(milliseconds: 1500),
      ));
      return false;
    }
    if (_passwort_0 != _passwort_1) {
      Scaffold.of(widget.context).showSnackBar(SnackBar(
        content: Text(
          global_language == Global_Language.ger
              ? "Die Passwörter sind nicht identisch."
              : "The passwords are not identical.",
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
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 250,
              child: Own_Textinput_V1(
                obscure: true,
                label: global_language == Global_Language.ger
                    ? "neues Passwort"
                    : "new password",
                enabled: true,
                on_changed: (value) {
                  _passwort_0 = value;
                },
              )),
          SizedBox(
              width: 250,
              child: Own_Textinput_V1(
                obscure: true,
                label: global_language == Global_Language.ger
                    ? "Passwort bestätigen"
                    : "repeat password",
                enabled: true,
                on_changed: (value) {
                  _passwort_1 = value;
                },
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                color: global_color_1,
                onPressed: () async {
                  try {
                    if (_check_input()) {
                      await auth_firebase.currentUser
                          .updatePassword(_passwort_0);
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    Scaffold.of(widget.context).removeCurrentSnackBar();
                    Scaffold.of(widget.context).showSnackBar(SnackBar(
                      content: Text(
                        e.toString(),
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(milliseconds: 1500),
                    ));
                  }
                },
                child: Text(global_language == Global_Language.ger
                    ? "Ändern"
                    : "Change"),
              ),
              RaisedButton(
                color: global_color_4,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(global_language == Global_Language.ger
                    ? "Abbrechen"
                    : "Cancel"),
              )
            ],
          )
        ],
      ),
    );
  }
}
