import 'dart:async';

import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double global_mobile_treshold = 700;
String global_active_route = "/";

enum Usertype { visitor, user }
Usertype global_usertype = Usertype.visitor;

DB_User global_user_data;
Map<String, dynamic> global_search_data;
List<DB_User> global_results_list;

StreamController<bool> global_rebuild_controller =
    StreamController<bool>.broadcast();

// Firebase Storage Bucket Link
final String firebase_bucket_link =
    "gs://fellowcoder-org-dev.appspot.com"; // "gs://fellowcoder-org-dev.appspot.com" // "gs://fellowcoder-org.appspot.com"

//Authentication START--------------------------------------------------------------------------
final FirebaseAuth auth_firebase = FirebaseAuth.instance;
//Authentication END--------------------------------------------------------------------------

//Color variables START-----------------------------------------------------------------------
Color global_color_background_1 = Color.fromRGBO(250, 250, 250, 1);
Color global_color_1 = Color.fromRGBO(220, 220, 100, 1);
Color global_color_2 = Color.fromRGBO(192, 242, 97, 1);
Color global_color_3 = Color.fromRGBO(204, 204, 204, 1);
Color global_color_4 = Color.fromRGBO(138, 138, 138, 1);
Color global_color_5 = Color.fromRGBO(0, 0, 0, 1);
//Color variables END-----------------------------------------------------------------------

//Language variables START-----------------------------------------------------------------------
enum Global_Language { ger, eng }
Global_Language global_language = Global_Language.eng;

StreamController<Global_Language> global_language_streamController =
    StreamController.broadcast();

class Language_Info {
  String name;
  String icon;
  Language_Info({this.icon, this.name});
}

final Map<Global_Language, Language_Info> global_language_info = {
  Global_Language.ger:
      Language_Info(name: "German", icon: "assets/countries/ger_100.png"),
  Global_Language.eng:
      Language_Info(name: "English", icon: "assets/countries/uk_100.png"),
};
//Language variables END-----------------------------------------------------------------------

//Theme Mode variables START-----------------------------------------------------------------------
enum Global_Theme_Mode { light, dark }
Global_Theme_Mode global_theme_mode = Global_Theme_Mode.light;

StreamController<Global_Theme_Mode> global_theme_mode_streamController =
    StreamController.broadcast();

class Theme_Mode_Info {
  String name;
  IconData icon;
  Theme_Mode_Info({this.icon, this.name});
}

final Map<Global_Theme_Mode, Theme_Mode_Info> global_theme_mode_info = {
  Global_Theme_Mode.light: Theme_Mode_Info(name: "light", icon: Icons.wb_sunny),
  Global_Theme_Mode.dark:
      Theme_Mode_Info(name: "dark", icon: Icons.wb_sunny_outlined),
};
//Theme Mode variables END-----------------------------------------------------------------------

//Country variables START-----------------------------------------------------------------------
enum Country { all, ger, swe, esp }

class Country_Info {
  String name;
  String icon;
  Country_Info({this.icon, this.name});
}

final Map<Country, Country_Info> global_country_info = {
  Country.all: Country_Info(name: "All", icon: "assets/countries/all.png"),
  Country.ger: Country_Info(name: "Germany", icon: "assets/countries/ger.png"),
  Country.swe: Country_Info(name: "Sweden", icon: "assets/countries/swe.png"),
  Country.esp: Country_Info(name: "Spain", icon: "assets/countries/esp.png"),
};
//Country variables END-----------------------------------------------------------------------

//Coding language variables START-----------------------------------------------------------------------
enum Coding_Language { python, csharp, java }

class Coding_Language_Info {
  String name;
  String icon;
  Coding_Language_Info({this.icon, this.name});
}

final Map<Coding_Language, Coding_Language_Info> global_coding_language_info = {
  Coding_Language.python: Coding_Language_Info(
      name: "Python", icon: "assets/coding_languages/python.png"),
  Coding_Language.csharp:
      Coding_Language_Info(name: "C#", icon: "assets/coding_languages/c#.png"),
  Coding_Language.java: Coding_Language_Info(
      name: "Java", icon: "assets/coding_languages/java.png"),
};

//Coding language variables END-----------------------------------------------------------------------
