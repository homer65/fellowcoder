import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_coding_language_selection.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_country_select_dropdown.dart';
import 'package:flutter/material.dart';

class Search_Result_Page extends StatefulWidget {
  static const String route = '/search_result_page';

  @override
  _Search_Result_PageState createState() => _Search_Result_PageState();
}

class _Search_Result_PageState extends State<Search_Result_Page> {
  List<DB_User> _results_list;
  @override
  void initState() {
    super.initState();
    _results_list = [
      DB_User(name: "Testnutzer1"),
      DB_User(name: "Testnutzer2"),
      DB_User(name: "Testnutzer3"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer"),
      DB_User(name: "Testnutzer")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Container(),
            floating: true,
            title: Text(''),
            backgroundColor: Colors.transparent,
            stretch: true,
            expandedHeight: 142 +
                ((global_search_data["coding_languages"].length + 1) / 2)
                        .round() *
                    70,
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Own_Country_Select_Dropdown(
                      on_change: (String country) {
                        global_search_data["country"] = country;
                      },
                    ),
                    Own_Coding_Language_Selection(
                      on_change: () {
                        setState(() {});
                      },
                      coding_language_list:
                          global_search_data["coding_languages"],
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
                    RaisedButton(
                      onPressed: () {},
                      child: Text("anwenden"),
                      color: Colors.orangeAccent,
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Search_Result_Page_List_Element(_results_list[index]);
              },
              childCount: _results_list.length,
            ),
          ),
        ],
      ),
    );
  }
}

class Search_Result_Page_List_Element extends StatefulWidget {
  DB_User result_user;
  Search_Result_Page_List_Element(this.result_user);
  @override
  _Search_Result_Page_List_ElementState createState() =>
      _Search_Result_Page_List_ElementState();
}

class _Search_Result_Page_List_ElementState
    extends State<Search_Result_Page_List_Element> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 100,
      color: Colors.greenAccent,
      child: Text(widget.result_user.name),
    );
  }
}
