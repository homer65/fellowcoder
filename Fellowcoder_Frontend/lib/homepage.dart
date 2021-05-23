import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
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

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    global_search_data = {
      "country": "Deutschland",
      "coding_languages": ["Python"],
      "search_text": "",
      "group_person_select": "Person",
      "group_goal_select": "Team",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: false,
              maxLines: null,
              controller: null,
              style: TextStyle(),
              onChanged: (value) {
                setState(() {
                  global_search_data["search_text"] = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Suchtext",
              ),
            ),
            Own_Group_Person_Select(
              init_gps: Group_Person_Select.person,
              on_change: (value) {
                setState(() {
                  global_search_data["group_person_select"] =
                      global_group_person_select_info[value].name;
                });
              },
            ),
            Own_Group_Goal_Select(
              greyed_out: global_search_data["group_person_select"] == "Person",
              init_ggs: Group_Goal_Select.team,
              on_change: (value) {
                global_search_data["group_goal_select"] =
                    global_group_goal_select_info[value].name;
              },
            ),
            Own_Country_Select_Dropdown(
              init_value: global_search_data["country"],
              on_change: (String country) {
                global_search_data["country"] = country;
              },
            ),
            Own_Coding_Language_Selection(
              coding_language_list: global_search_data["coding_languages"],
              on_change: () {},
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              onPressed: () async {
                global_results_list =
                    await Backend_Com().get_search_data(global_search_data);
                Navigator.of(context).pushNamed(Search_Result_Page.route);
              },
              color: global_color_highlight_2,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "Suchen",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
