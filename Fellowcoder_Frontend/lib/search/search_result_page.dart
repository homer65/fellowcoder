import 'dart:math';

import 'package:Fellowcoder_Frontend/global_stuff/DB_User.dart';
import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/basic_image.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_coding_language_selection.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_country_select_dropdown.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_group_goal_select.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/own_group_person_select.dart';
import 'package:Fellowcoder_Frontend/profile/main_profile.dart';
import 'package:flutter/material.dart';

class Search_Result_Page extends StatefulWidget {
  static const String route = '/search_result_page';

  @override
  _Search_Result_PageState createState() => _Search_Result_PageState();
}

class _Search_Result_PageState extends State<Search_Result_Page> {
  TextEditingController _search_text_controller = TextEditingController();
  bool _settings_expanded = false;

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
        "country": "All",
        "coding_languages": [],
        "search_text": "",
        "group_person_select": "Person",
        "group_goal_select": "Team",
      };
    }
    _search_text_controller.text = global_search_data["search_text"];

    initialise();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      initialise();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile =
        _screen_size.width < global_mobile_treshold ? true : false;

    double _width_1 = calc_length_max(800, 0.95, _screen_size.width);
    double _width_2 = calc_length_max(300, 0.90, _screen_size.width);

    return SizedBox(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Container(),
            floating: true,
            title: Text(''),
            backgroundColor: global_color_background_1,
            stretch: true,
            expandedHeight: 200 +
                (_settings_expanded
                    ? 160 +
                        ((global_search_data["coding_languages"].length + 1) /
                                    2)
                                .round() *
                            70
                    : 0),
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Column(
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
                          autofocus: false,
                          maxLines: 1,
                          controller: _search_text_controller,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
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
                                  color: Colors.grey.withOpacity(0.7)),
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
                              init_gps:
                                  global_search_data["group_person_select"] ==
                                          "Person"
                                      ? Group_Person_Select.person
                                      : Group_Person_Select.group,
                              on_change: (value) {
                                setState(() {
                                  global_search_data["group_person_select"] =
                                      global_group_person_select_info[value]
                                          .name;
                                });
                              },
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Own_Group_Goal_Select(
                              width: _width_2,
                              greyed_out:
                                  global_search_data["group_person_select"] ==
                                      global_group_person_select_info[
                                              Group_Person_Select.person]
                                          .name,
                              init_ggs: global_search_data[
                                          "group_goal_select"] ==
                                      global_group_goal_select_info[
                                              Group_Goal_Select.team]
                                          .name
                                  ? Group_Goal_Select.team
                                  : global_search_data["group_goal_select"] ==
                                          global_group_goal_select_info[
                                                  Group_Goal_Select.forum]
                                              .name
                                      ? Group_Goal_Select.forum
                                      : Group_Goal_Select.discussion,
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
                                on_change: () {
                                  setState(() {});
                                },
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
                      RaisedButton(
                        onPressed: () async {
                          global_results_list = await Backend_Com()
                              .get_search_data(global_search_data);
                          setState(() {});
                        },
                        color: global_color_1,
                        child: Container(
                          alignment: Alignment.center,
                          width: _width_2,
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            global_language == Global_Language.ger
                                ? "anwenden"
                                : "apply",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          /*SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Search_Result_Page_List_Element(
                    global_results_list[index]);
              },
              childCount:
                  global_results_list == null ? 0 : global_results_list.length,
            ),
          ),*/
          /*SliverGrid.count(
            crossAxisCount: max(1, (_screen_size.width / 300).toInt()),
            childAspectRatio: 0.9,
            children: [
              for (DB_User i in global_results_list)
                Search_Result_Page_List_Element(i)
            ],
          ),*/
          SliverList(
              delegate: SliverChildListDelegate([
            Center(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  for (DB_User i in global_results_list)
                    Search_Result_Page_List_Element(
                      i,
                      user_group: false,
                    )
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }
}

class Search_Result_Page_List_Element extends StatefulWidget {
  DB_User result_user;
  bool user_group; // true = group
  Search_Result_Page_List_Element(this.result_user, {this.user_group = false});
  @override
  _Search_Result_Page_List_ElementState createState() =>
      _Search_Result_Page_List_ElementState();
}

class _Search_Result_Page_List_ElementState
    extends State<Search_Result_Page_List_Element> {
  String _country_flag = "";
  @override
  void initState() {
    super.initState();
    try {
      _country_flag = global_country_info.values
          .firstWhere((element) => element.name == widget.result_user.land)
          .icon;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 300,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: global_color_background_1,
        border: Border.all(color: global_color_4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
            textStyle: TextStyle(color: Colors.black)),
        onPressed: () {
          Navigator.of(context).pushNamed(Main_Profile.route,
              arguments: {"userview": true, "data": widget.result_user});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Basic_Image(
                  widget.result_user.bildurl,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  width: 300,
                  height: 250,
                  border_radius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: global_color_4),
                    child: Icon(
                      widget.user_group ? Icons.group : Icons.person,
                      color: global_color_1,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      //color: global_color_4
                    ),
                    child: Image.asset(_country_flag),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.result_user.name == null
                      ? "-"
                      : widget.result_user.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Text(
                  widget.result_user.geburtsdatum == null
                      ? "-"
                      : (DateTime.now().year -
                              widget.result_user.geburtsdatum.year)
                          .toString(),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                    /*Own_Coding_Language_Selection(
                  coding_language_list: widget.result_user.sprachen,
                  enabled: false,
                ),*/
                    Center(
                  child: Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.start,
                    children: [
                      for (String i in widget.result_user.sprachen)
                        Coding_Language_Element(i)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Coding_Language_Element extends StatefulWidget {
  String coding_language;
  Coding_Language_Element(this.coding_language);
  @override
  _Coding_Language_ElementState createState() =>
      _Coding_Language_ElementState();
}

class _Coding_Language_ElementState extends State<Coding_Language_Element> {
  String _icon = "";
  String _name = "";

  @override
  void initState() {
    super.initState();
    _name = widget.coding_language;
    try {
      _icon = global_coding_language_info.values
          .firstWhere((element) => element.name == widget.coding_language)
          .icon;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 25,
      width: 80,
      child: Row(
        children: [
          Image.asset(_icon),
          SizedBox(
            width: 3,
          ),
          Text(
            _name,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
