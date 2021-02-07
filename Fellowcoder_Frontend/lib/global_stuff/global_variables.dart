import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:firebase_auth/firebase_auth.dart';

double global_mobile_treshold = 700;

String global_active_route = "/";

enum Usertype { visitor, user }
Usertype global_usertype = Usertype.visitor;

DB_User global_user_data;
Map<String, dynamic> global_search_data;
List<DB_User> global_results_list;

// Firebase Storage Bucket Link
final String firebase_bucket_link = "gs://fellowcoder-org-dev.appspot.com";

//Authentication START--------------------------------------------------------------------------
final FirebaseAuth auth_firebase = FirebaseAuth.instance;
//Authentication END--------------------------------------------------------------------------

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
