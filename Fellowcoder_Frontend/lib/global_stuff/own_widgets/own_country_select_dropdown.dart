import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:flutter/material.dart';

class Own_Country_Select_Dropdown extends StatefulWidget {
  String init_value;
  bool enabled;
  Function(String country) on_change;
  Own_Country_Select_Dropdown(
      {this.init_value = "Deutschland", this.on_change, this.enabled = true});
  @override
  _Own_Country_Select_DropdownState createState() =>
      _Own_Country_Select_DropdownState();
}

class _Own_Country_Select_DropdownState
    extends State<Own_Country_Select_Dropdown> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.init_value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.enabled
        ? DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            /*style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),*/
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              widget.on_change(newValue);
            },
            items: Country.values.map((Country value) {
              return DropdownMenuItem<String>(
                value: global_country_info[value].name,
                child: SizedBox(
                  width: 276,
                  child: Row(
                    children: [
                      Image.asset(
                        global_country_info[value].icon,
                        width: 40,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(global_country_info[value].name),
                      Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : SizedBox(
            width: 276,
            height: 50,
            child: Row(
              children: [
                Image.asset(
                  global_country_info.values
                      .firstWhere(
                          (element) => element.name == widget.init_value)
                      .icon,
                  width: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(widget.init_value),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          );
  }
}
