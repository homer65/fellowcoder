import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
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
  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;
    return Container(
      height: 50,
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Homepage.route);
              },
              child: Text("Startseite")),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Chat_View.route);
                  },
                  child: Text("Chats")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Main_Profile.route);
                  },
                  child: Text("Profil")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Register.route);
                  },
                  child: Text("Register")),
              global_usertype == Usertype.visitor
                  ? FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Login.route);
                      },
                      child: Text("Login"))
                  : FlatButton(
                      onPressed: () {
                        logout();
                        Navigator.of(context).pushNamed(Homepage.route);
                      },
                      child: Text("Abmelden")),
            ],
          ),
        ],
      ),
    );
  }
}
