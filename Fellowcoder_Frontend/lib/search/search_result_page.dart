import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/basic_image.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_coding_language_selection.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_country_select_dropdown.dart';
import 'package:Fellowcoder_Frontend/profile/main_profile.dart';
import 'package:flutter/material.dart';

class Search_Result_Page extends StatefulWidget {
  static const String route = '/search_result_page';

  @override
  _Search_Result_PageState createState() => _Search_Result_PageState();
}

class _Search_Result_PageState extends State<Search_Result_Page> {
  void initialise() async {
    if (global_results_list == null) {
      global_results_list = [];
      global_results_list =
          await Backend_Com().get_search_data(global_search_data);
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (global_search_data == null) {
      global_search_data = {
        "country": "Deutschland",
        "coding_languages": [],
        "search_text": "",
      };
    }
    initialise();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      initialise();
    });*/
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
            backgroundColor: global_color_background_1,
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
                      onPressed: () async {
                        global_results_list = await Backend_Com()
                            .get_search_data(global_search_data);
                        setState(() {});
                      },
                      child: Text(
                        "anwenden",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: global_color_highlight_1,
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Search_Result_Page_List_Element(
                    global_results_list[index]);
              },
              childCount:
                  global_results_list == null ? 0 : global_results_list.length,
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      //height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: global_color_background_1,
        border: Border.all(color: global_color_highlight_1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Main_Profile.route,
              arguments: {"userview": true, "data": widget.result_user});
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Basic_Image(
                    widget.result_user.bildurl,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    width: 80,
                    height: 80,
                    border_radius: BorderRadius.circular(40),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(widget.result_user.name == null
                      ? "NULL"
                      : widget.result_user.name),
                ],
              ),
              Own_Coding_Language_Selection(
                coding_language_list: widget.result_user.sprachen,
                enabled: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
