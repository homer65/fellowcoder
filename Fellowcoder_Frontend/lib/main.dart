import 'package:Fellowcoder_Frontend/frame/footer.dart';
import 'package:Fellowcoder_Frontend/frame/frame_pages/about_us.dart';
import 'package:Fellowcoder_Frontend/frame/frame_pages/datenschutz.dart';
import 'package:Fellowcoder_Frontend/frame/frame_pages/impressum.dart';
import 'package:Fellowcoder_Frontend/frame/frame_pages/nutzungsbedingungen.dart';
import 'package:Fellowcoder_Frontend/frame/header.dart';
import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/homepage.dart';
import 'package:Fellowcoder_Frontend/login_register/login.dart';
import 'package:Fellowcoder_Frontend/login_register/register.dart';
import 'package:Fellowcoder_Frontend/profile/main_profile.dart';
import 'package:Fellowcoder_Frontend/router.dart';
import 'package:Fellowcoder_Frontend/search/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:cooky/cooky.dart' as cookie;
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fellowcoder.org',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Homepage.route,
      onGenerateRoute: generateRoute,
    );
  }
}

class Main extends StatefulWidget {
  static const String route = '/';
  var arguments;
  Main({this.arguments});
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  void initialise() async {
    auth_firebase.authStateChanges().listen((User user) async {
      if (user == null) {
        //print('User is currently signed out!');
        setState(() {
          global_usertype = Usertype.visitor;
        });
      } else {
        //print('User is signed in!');
        if (global_user_data == null) {
          global_user_data = await Backend_Com().get_user();
        }
        setState(() {
          global_usertype = Usertype.user;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;

    return Scaffold(
      //drawer: Main_Drawer(),
      body: Column(
        children: [
          Header(),
          Expanded(key: UniqueKey(), child: get_main_widget()),
          Footer(),
        ],
      ),
    );
  }
}

Widget get_main_widget() {
  switch (global_active_route) {
    case Homepage.route:
      return Homepage();
    case Search_Result_Page.route:
      return Search_Result_Page();
    case Register.route:
      return Register();
    case Login.route:
      return Login();
    case Main_Profile.route:
      return Main_Profile();
    case About_Us.route:
      return About_Us();
    case Impressum.route:
      return Impressum();
    case Nutzungsbedingungen.route:
      return Nutzungsbedingungen();
    case Datenschutz.route:
      return Datenschutz();
    default:
      return Homepage();
  }
}
