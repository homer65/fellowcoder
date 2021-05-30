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
  double _main_font_size = 14;
  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;
    return Container(
      alignment: Alignment.center,
      height: 25,
      width: _screen_size.width,
      decoration: BoxDecoration(
          color: global_color_1.withOpacity(0.7),
          border: Border(top: BorderSide(color: Colors.black, width: 1.0))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ButtonTheme(
          minWidth: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              /*FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(About_Us.route);
                  },
                  child: Text(
                    global_language == Global_Language.ger
                        ? "über uns"
                        : "About us",
                    style: TextStyle(
                        fontSize: _on_mobile
                            ? _main_font_size * 0.75
                            : _main_font_size),
                  )),
              Container(
                width: 1,
                height: 20,
                color: Colors.black,
              ),*/
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Datenschutz.route);
                  },
                  child: Text(
                    global_language == Global_Language.ger
                        ? "Datenschutz"
                        : "Privacy policy",
                    style: TextStyle(
                        fontSize: _on_mobile
                            ? _main_font_size * 0.75
                            : _main_font_size),
                  )),
              Container(
                width: 1,
                height: 20,
                color: Colors.black,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Impressum.route);
                  },
                  child: Text(
                    global_language == Global_Language.ger
                        ? "Impressum"
                        : "Legal notice",
                    style: TextStyle(
                        fontSize: _on_mobile
                            ? _main_font_size * 0.75
                            : _main_font_size),
                  )),
              Container(
                width: 1,
                height: 20,
                color: Colors.black,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Nutzungsbedingungen.route);
                  },
                  child: Text(
                    global_language == Global_Language.ger
                        ? "Nutzungsbedingungen"
                        : "Terms of use",
                    style: TextStyle(
                        fontSize: _on_mobile
                            ? _main_font_size * 0.75
                            : _main_font_size),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
