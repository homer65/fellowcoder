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
Color global_color_highlight_1 = Color.fromRGBO(100, 100, 100, 0.75);
Color global_color_background_1 = Color.fromRGBO(250, 250, 250, 1);
//Color variables END-----------------------------------------------------------------------

//Country variables START-----------------------------------------------------------------------
enum Country { ger, swe, esp }

class Country_Info {
  String name;
  String icon;
  Country_Info({this.icon, this.name});
}

final Map<Country, Country_Info> global_country_info = {
  Country.ger:
      Country_Info(name: "Deutschland", icon: "assets/countries/ger.png"),
  Country.swe: Country_Info(name: "Schweden", icon: "assets/countries/swe.png"),
  Country.esp: Country_Info(name: "Spanien", icon: "assets/countries/esp.png"),
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
