import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:Fellowcoder_Frontend/frame/frame_pages/about_us.dart';
import 'package:Fellowcoder_Frontend/frame/frame_pages/datenschutz.dart';
import 'package:Fellowcoder_Frontend/frame/frame_pages/impressum.dart';
import 'package:Fellowcoder_Frontend/frame/frame_pages/nutzungsbedingungen.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;
    return Container(
      height: 20,
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(About_Us.route);
              },
              child: Text("About Us")),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Datenschutz.route);
              },
              child: Text("Datenschutz")),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Impressum.route);
              },
              child: Text("Impressum")),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Nutzungsbedingungen.route);
              },
              child: Text("Nutzungsbedingungen")),
        ],
      ),
    );
  }
}
