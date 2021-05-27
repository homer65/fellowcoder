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

enum Profile_Change_Data { email, password }
Map<String, dynamic> click_change_weekday_data;

class Main_Profile extends StatefulWidget {
  static const String route = '/main_profile';
  bool userview;
  DB_User data;
  Main_Profile({this.userview = false, this.data});
  @override
  _Main_ProfileState createState() => _Main_ProfileState();
}

class _Main_ProfileState extends State<Main_Profile> {
  DB_User _user_data;
  TextEditingController _name_controller = TextEditingController();
  TextEditingController _description_controller = TextEditingController();
  bool _loading = true;

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
    if (widget.userview) {
      _user_data = widget.data;
    } else {
      print(global_user_data.name);
      if (global_user_data.name == null) {
        _loading = true;
        return;
      } else {
        _user_data = global_user_data;
      }
    }
    _name_controller.text = _user_data.name;
    _description_controller.text = _user_data.beschreibungstext;
    _loading = false;
  }

  @override
  void initState() {
    super.initState();
    global_rebuild_controller.stream.listen((data) {
      initialise();
      setState(() {});
    });
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;

    return _loading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: _on_mobile ? 10 : 10,
                ),
                widget.userview
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
                                      label: "E-Mail",
                                      enabled: false,
                                    )),
                                IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _change_data(
                                          Profile_Change_Data.email, context);
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
                                      label: "Passwort",
                                      enabled: false,
                                      obscure: true,
                                    )),
                                IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _change_data(Profile_Change_Data.password,
                                          context);
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: _on_mobile ? 30 : 60,
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      widget.userview
                          ? Basic_Image(
                              _user_data.bildurl,
                              width: 200,
                              height: 200,
                            )
                          : Image_Web_Picker(
                              key: ValueKey(_user_data.bildurl),
                              image: _user_data.bildurl,
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
                      widget.userview
                          ? RaisedButton(
                              onPressed: () async {
                                await Backend_Com()
                                    .chateintrag_erstellen(_user_data.id);
                                global_user_data.chats.add({
                                  "chat_id":
                                      global_user_data.id + _user_data.id,
                                  "partner_name": _user_data.name,
                                  "partner_id": _user_data.id
                                });
                                Navigator.of(context)
                                    .pushNamed(Chat_View.route);
                              },
                              child: Text("Chat"),
                              color: global_color_1,
                            )
                          : Container(),
                      Own_Submittable_Text_Input(
                        _name_controller,
                        enabled: !widget.userview,
                        on_changed: (value) {},
                        submitted: (value) {
                          Backend_Com().change_userdata("name", value);
                          _user_data.name = value;
                        },
                        aborted: () {},
                        label_text: "Name",
                        max_lines: 1,
                      ),
                      Own_Country_Select_Dropdown(
                        enabled: !widget.userview,
                        init_value: _user_data.land,
                        on_change: (country) {
                          _user_data.land = country;
                          Backend_Com()
                              .change_userdata("land", _user_data.land);
                        },
                      ),
                      Text_Date_Picker(
                        enabled: !widget.userview,
                        onValueChanged: (value) {
                          _user_data.geburtsdatum = value;
                          Backend_Com().change_userdata(
                              "geburtsdatum", _user_data.geburtsdatum);
                        },
                        label: "Geburtsdatum",
                        date: _user_data.geburtsdatum == null
                            ? DateTime.now()
                            : _user_data.geburtsdatum,
                        first_date:
                            DateTime.now().subtract(Duration(days: 100000)),
                      ),
                      Own_Coding_Language_Selection(
                        enabled: !widget.userview,
                        coding_language_list: _user_data.sprachen,
                        on_change: () {
                          Backend_Com()
                              .change_userdata("sprachen", _user_data.sprachen);
                        },
                      ),
                      Own_Submittable_Text_Input(
                        _description_controller,
                        enabled: !widget.userview,
                        on_changed: (value) {},
                        submitted: (value) {
                          Backend_Com()
                              .change_userdata("beschreibungstext", value);
                          _user_data.beschreibungstext = value;
                        },
                        aborted: () {},
                        label_text: "Beschreibung",
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
                label: "neue E-Mail",
                enabled: true,
                on_changed: (value) {
                  _new_email = value;
                },
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                color: Colors.greenAccent,
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
                child: Text("Ändern"),
              ),
              RaisedButton(
                color: Colors.orangeAccent,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Abbrechen"),
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
          "Das Passwort ist zu kurz.",
          textAlign: TextAlign.center,
        ),
        duration: Duration(milliseconds: 1500),
      ));
      return false;
    }
    if (_passwort_0 != _passwort_1) {
      Scaffold.of(widget.context).showSnackBar(SnackBar(
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
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 250,
              child: Own_Textinput_V1(
                obscure: true,
                label: "neues Passwort",
                enabled: true,
                on_changed: (value) {
                  _passwort_0 = value;
                },
              )),
          SizedBox(
              width: 250,
              child: Own_Textinput_V1(
                obscure: true,
                label: "Passwort bestätigen",
                enabled: true,
                on_changed: (value) {
                  _passwort_1 = value;
                },
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                color: Colors.greenAccent,
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
                child: Text("Ändern"),
              ),
              RaisedButton(
                color: Colors.orangeAccent,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Abbrechen"),
              )
            ],
          )
        ],
      ),
    );
  }
}
