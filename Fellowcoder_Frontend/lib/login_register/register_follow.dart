import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/image_web_picker.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_coding_language_selection.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_country_select_dropdown.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_submittable_text_input.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/text_date_picker.dart';
import 'package:Fellowcoder_Frontend/profile/main_profile.dart';
import 'package:flutter/material.dart';

class Register_Follow extends StatefulWidget {
  static const String route = '/register_follow';
  @override
  _Register_FollowState createState() => _Register_FollowState();
}

class _Register_FollowState extends State<Register_Follow> {
  TextEditingController _name_controller = TextEditingController();
  TextEditingController _description_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name_controller.text = global_user_data.name;
    _description_controller.text = global_user_data.beschreibungstext;
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;

    return Container(
      width: calc_length_min(300, 0.6, _screen_size.width),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              global_language == Global_Language.ger
                  ? "Hier kannst du noch weitere Daten zu deinem Profil hinzufügen.\nDadurch können dich andere Nutzer besser finden.\nDu kannst deine Angaben auch später in deinem Profil bearbeiten und ergänzen."
                  : "Here you can add more data to your profile.\nThis will help other users to find you better.\nYou can also edit and add details later in your profile.",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: _on_mobile ? 14 : 20),
            ),
            Container(
              width: 300,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image_Web_Picker(
                    key: ValueKey(global_user_data.bildurl),
                    image: global_user_data.bildurl,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(10),
                    shadow: false,
                    old_image_path: global_user_data.bild_name,
                    upload_begins: () {},
                    upload_done: (name, link) async {
                      setState(() {
                        global_user_data.bild_name = name;
                        global_user_data.bildurl = link;
                      });
                      Backend_Com()
                          .change_userdata("bildurl", global_user_data.bildurl);
                      Backend_Com().change_userdata(
                          "bild_name", global_user_data.bild_name);
                    },
                    picture_deleted: (name) async {
                      setState(() {
                        global_user_data.bild_name = "";
                        global_user_data.bildurl = "";
                      });
                      Backend_Com()
                          .change_userdata("bildurl", global_user_data.bildurl);
                      Backend_Com().change_userdata(
                          "bild_name", global_user_data.bild_name);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Own_Submittable_Text_Input(
                    _name_controller,
                    enabled: true,
                    on_changed: (value) {},
                    submitted: (value) {
                      Backend_Com().change_userdata("name", value);
                      global_user_data.name = value;
                    },
                    aborted: () {},
                    label_text: global_language == Global_Language.ger
                        ? "Name"
                        : "Name",
                    max_lines: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Own_Country_Select_Dropdown(
                    enabled: true,
                    init_value: global_user_data.land,
                    on_change: (country) {
                      global_user_data.land = country;
                      Backend_Com()
                          .change_userdata("land", global_user_data.land);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text_Date_Picker(
                    enabled: true,
                    onValueChanged: (value) {
                      global_user_data.geburtsdatum = value;
                      Backend_Com().change_userdata(
                          "geburtsdatum", global_user_data.geburtsdatum);
                    },
                    label: global_language == Global_Language.ger
                        ? "Geburtsdatum"
                        : "Birthday",
                    date: global_user_data.geburtsdatum,
                    first_date: DateTime.now().subtract(Duration(days: 100000)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    global_language == Global_Language.ger
                        ? "Skills"
                        : "Skills",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 3,
                    color: global_color_1,
                  ),
                  Own_Coding_Language_Selection(
                    enabled: true,
                    coding_language_list: global_user_data.sprachen,
                    on_change: () {
                      Backend_Com().change_userdata(
                          "sprachen", global_user_data.sprachen);
                    },
                  ),
                  Container(
                    height: 3,
                    color: global_color_1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Own_Submittable_Text_Input(
                    _description_controller,
                    enabled: true,
                    on_changed: (value) {},
                    submitted: (value) {
                      Backend_Com().change_userdata("beschreibungstext", value);
                      global_user_data.beschreibungstext = value;
                    },
                    aborted: () {},
                    label_text: global_language == Global_Language.ger
                        ? "Beschreibung"
                        : "personal description",
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  RaisedButton(
                    color: global_color_1,
                    onPressed: () async {
                      Navigator.of(context).popAndPushNamed(
                          Main_Profile.route + "/" + global_user_data.id);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 50,
                      child: Text(
                          global_language == Global_Language.ger
                              ? "weiter zum Profil"
                              : "continue to Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
