import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_page_language_switch.dart';
import 'package:Fellowcoder_Frontend/homepage.dart';
import 'package:Fellowcoder_Frontend/login_register/login.dart';
import 'package:Fellowcoder_Frontend/login_register/register.dart';
import 'package:Fellowcoder_Frontend/profile/chat_view.dart';
import 'package:Fellowcoder_Frontend/profile/main_profile.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  double _main_font_size = 14;
  double _main_icon_size = 20;

  @override
  void initState() {
    super.initState();
    global_rebuild_controller.stream.listen((data) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: global_color_1.withOpacity(0.7),
          border: Border(bottom: BorderSide(color: Colors.black, width: 1.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                Navigator.of(context).pushNamed(Homepage.route);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.home,
                    //color: global_color_4,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Fellowcoder.org",
                    style: TextStyle(/*color: global_color_4*/),
                  ),
                ],
              )),
          ButtonTheme(
            minWidth: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Own_Page_Language_Switch(),
                global_usertype == Usertype.user
                    ? FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.of(context).pushNamed(Chat_View.route);
                        },
                        child: Icon(
                          Icons.chat,
                          size: _on_mobile
                              ? _main_icon_size * 0.8
                              : _main_icon_size,
                        ) /*Text(
                      "Chats",
                      style: TextStyle(
                          fontSize: _on_mobile
                              ? _main_font_size * 0.8
                              : _main_font_size),
                    )*/
                        )
                    : Container(),
                global_usertype == Usertype.user
                    ? FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              Main_Profile.route + "/" + global_user_data.id);
                        },
                        child: Icon(
                          Icons.person,
                          size: _on_mobile
                              ? _main_icon_size * 0.8
                              : _main_icon_size,
                        )
                        /*Text(
                      "Profil",
                      style: TextStyle(
                          fontSize: _on_mobile
                              ? _main_font_size * 0.8
                              : _main_font_size),
                    )*/
                        )
                    : Container(),
                global_usertype == Usertype.visitor
                    ? FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.of(context).pushNamed(Register.route);
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                              fontSize: _on_mobile
                                  ? _main_font_size * 0.8
                                  : _main_font_size),
                        ))
                    : Container(),
                global_usertype == Usertype.visitor
                    ? FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.of(context).pushNamed(Login.route);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: _on_mobile
                                  ? _main_font_size * 0.8
                                  : _main_font_size),
                        ))
                    : FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          logout();
                          Navigator.of(context).pushNamed(Homepage.route);
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontSize: _on_mobile
                                  ? _main_font_size * 0.8
                                  : _main_font_size),
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
