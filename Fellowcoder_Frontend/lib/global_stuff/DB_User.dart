import 'dart:convert';

import 'package:intl/intl.dart';

class DB_User {
  String id;
  bool verified;
  String bildurl;
  DateTime registriert;
  DateTime lastlogin;
  DateTime geburtsdatum;
  String land;
  String name;
  String vorname;
  List<String> sprachen;
  String beschreibungstext;

  DB_User({
    this.id,
    this.verified,
    this.bildurl,
    this.registriert,
    this.lastlogin,
    this.geburtsdatum,
    this.land,
    this.name,
    this.vorname,
    this.sprachen,
    this.beschreibungstext,
  });

  DB_User.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    verified = json['Verified'];
    if (json['registriert'] != null) {
      registriert =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['registriert']);
    }
    if (json['lastlogin'] != null) {
      lastlogin = DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['lastlogin']);
    }
    if (json['geburtsdatum'] != null) {
      geburtsdatum =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['geburtsdatum']);
    }
    bildurl = json['bildurl'];
    land = json['land'];
    name = json['name'];
    vorname = json['vorname'];
    beschreibungstext = json['beschreibungstext'];
    sprachen = [];
    if (json['sprachen'] != null && json['sprachen'].length != 0) {
      List<dynamic> list = json['sprachen'];
      list.forEach((element) {
        sprachen.add(element);
      });
    }
  }
}
