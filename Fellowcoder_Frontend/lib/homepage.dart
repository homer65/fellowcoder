import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_coding_language_selection.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_country_select_dropdown.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_group_goal_select.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_group_person_select.dart';
import 'package:Fellowcoder_Frontend/search/search_result_page.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  static const String route = '/homepage';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  AnimationController _search_button_animationcontroller;
  bool _settings_expanded = true;

  @override
  void initState() {
    _search_button_animationcontroller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true, max: 1, min: 0.0);
    super.initState();
    global_search_data = {
      "country": "All",
      "coding_languages": [], // if no coding language is selected then find all
      "search_text": "",
      "group_person_select": "Person",
      "group_goal_select": "Team",
    };
  }

  @override
  void dispose() {
    _search_button_animationcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile =
        _screen_size.width < global_mobile_treshold ? true : false;

    double _width_1 = calc_length_max(800, 0.95, _screen_size.width);
    double _width_2 = calc_length_max(300, 0.90, _screen_size.width);

    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: global_color_1,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              width: _width_1,
              child: TextFormField(
                cursorColor: global_color_1,
                autofocus: true,
                maxLines: 1,
                controller: null,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                onChanged: (value) {
                  setState(() {
                    global_search_data["search_text"] = value;
                  });
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    hintText: global_language == Global_Language.ger
                        ? "Gib einen bestimmten Namen ein oder lass es frei um alle zu finden"
                        : "Insert a certain name or leave blank to find all",
                    alignLabelWithHint: false),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _settings_expanded = !_settings_expanded;
                });
              },
              style: ButtonStyle(),
              child: SizedBox(
                width: _width_2,
                child: Text(
                    global_language == Global_Language.ger
                        ? "weitere Einstellungen:"
                        : "further settings:",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: _settings_expanded ? null : 4,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: global_color_4,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Own_Group_Person_Select(
                    width: _width_2,
                    init_gps: Group_Person_Select.person,
                    on_change: (value) {
                      setState(() {
                        global_search_data["group_person_select"] =
                            global_group_person_select_info[value].name;
                      });
                    },
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Own_Group_Goal_Select(
                    width: _width_2,
                    greyed_out:
                        global_search_data["group_person_select"] == "Person",
                    init_ggs: Group_Goal_Select.team,
                    on_change: (value) {
                      global_search_data["group_goal_select"] =
                          global_group_goal_select_info[value].name;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Own_Country_Select_Dropdown(
                    width: _width_2,
                    init_value: global_search_data["country"],
                    on_change: (String country) {
                      global_search_data["country"] = country;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: _width_2 + 12,
                    child: Own_Coding_Language_Selection(
                      coding_language_list:
                          global_search_data["coding_languages"],
                      on_change: () {},
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            AnimatedBuilder(
              animation: _search_button_animationcontroller,
              builder: (_, __) {
                return RaisedButton(
                  onPressed: () async {
                    global_results_list =
                        await Backend_Com().get_search_data(global_search_data);
                    Navigator.of(context).pushNamed(Search_Result_Page.route);
                  },
                  color: global_color_1.withGreen(220 +
                      (_search_button_animationcontroller.value * 10).toInt()),
                  child: Container(
                    alignment: Alignment.center,
                    width: _width_2,
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      global_language == Global_Language.ger
                          ? "Suchen"
                          : "Search",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
