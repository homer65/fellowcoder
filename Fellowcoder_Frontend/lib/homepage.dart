import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_coding_language_selection.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_country_select_dropdown.dart';
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
      "country": "error",
      "coding_languages": [],
      "search_text": "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Own_Country_Select_Dropdown(
            on_change: (Country country) {
              global_search_data["country"] = global_country_info[country].name;
            },
          ),
          Own_Coding_Language_Selection(
            coding_language_list: global_search_data["coding_languages"],
            on_change: () {},
          ),
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
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Search_Result_Page.route);
            },
            child: Text("Suchen"),
            color: Colors.orangeAccent,
          )
        ],
      ),
    );
  }
}
