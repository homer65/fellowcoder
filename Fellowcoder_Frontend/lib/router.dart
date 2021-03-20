import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/homepage.dart';
import 'package:Fellowcoder_Frontend/login_register/login.dart';
import 'package:Fellowcoder_Frontend/login_register/register.dart';
import 'package:Fellowcoder_Frontend/main.dart';
import 'package:Fellowcoder_Frontend/profile/chat_view.dart';
import 'package:Fellowcoder_Frontend/profile/main_profile.dart';
import 'package:flutter/material.dart';
import 'package:cooky/cooky.dart' as cookie;

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Main_Profile.route:
      if (cookie.get("id_token") == null ||
          cookie.get("id_token") ==
              "" /*global_usertype == Usertype.visitor && settings.arguments == null*/) {
        return _default_PageRoute(
            RouteSettings(name: Register.route, arguments: settings.arguments));
      }
      return _default_PageRoute(settings);
    case Chat_View.route:
      if (cookie.get("id_token") == null ||
          cookie.get("id_token") ==
              "" /*global_usertype == Usertype.visitor*/) {
        return _default_PageRoute(
            RouteSettings(name: Register.route, arguments: settings.arguments));
      }
      return _default_PageRoute(settings);
    default:
      return _default_PageRoute(settings);
  }
}

PageRoute _default_PageRoute(RouteSettings settings) {
  return PageRouteBuilder(
      pageBuilder: (_, a1, a2) {
        global_active_route = settings.name;
        return Main(
          arguments: settings.arguments,
        );
      },
      settings: RouteSettings(name: settings.name));
}
