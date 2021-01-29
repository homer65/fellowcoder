import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:flutter/material.dart';

class Own_Country_Select_Dropdown extends StatefulWidget {
  Country init_value;
  Function(Country country) on_change;
  Own_Country_Select_Dropdown({this.init_value = Country.ger, this.on_change});
  @override
  _Own_Country_Select_DropdownState createState() =>
      _Own_Country_Select_DropdownState();
}

class _Own_Country_Select_DropdownState
    extends State<Own_Country_Select_Dropdown> {
  Country dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.init_value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Country>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      /*style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),*/
      onChanged: (Country newValue) {
        setState(() {
          dropdownValue = newValue;
        });
        widget.on_change(newValue);
      },
      items: Country.values.map((Country value) {
        return DropdownMenuItem<Country>(
          value: value,
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
    );
  }
}
