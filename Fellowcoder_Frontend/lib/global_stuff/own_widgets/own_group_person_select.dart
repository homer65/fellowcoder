import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
enum Group_Person_Select { group, person }

class Group_Person_Select_Info {
  String name;
  Group_Person_Select_Info({this.name});
}

final Map<Group_Person_Select, Group_Person_Select_Info>
    global_group_person_select_info = {
  Group_Person_Select.group: Group_Person_Select_Info(name: "Gruppe"),
  Group_Person_Select.person: Group_Person_Select_Info(name: "Person"),
};
// -----------------------------------------------------------------------------

class Own_Group_Person_Select extends StatefulWidget {
  Group_Person_Select init_gps;
  double width;
  double height;
  Function(Group_Person_Select) on_change;
  Own_Group_Person_Select(
      {this.init_gps = Group_Person_Select.person,
      this.on_change,
      this.width = 300,
      this.height = 50});
  @override
  _Own_Group_Person_SelectState createState() =>
      _Own_Group_Person_SelectState();
}

class _Own_Group_Person_SelectState extends State<Own_Group_Person_Select> {
  Group_Person_Select gps;
  @override
  void initState() {
    super.initState();
    gps = widget.init_gps;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: (widget.width - 10) / 2,
              height: widget.height,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return gps == Group_Person_Select.person
                            ? global_color_1.withOpacity(0.8)
                            : global_color_4.withOpacity(0.8);
                      },
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      gps = Group_Person_Select.person;
                    });
                    widget.on_change(gps);
                  },
                  child: Text(global_language == Global_Language.ger
                      ? "Person"
                      : "Person")),
            ),
            SizedBox(
              width: (widget.width - 10) / 2,
              height: widget.height,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return gps == Group_Person_Select.group
                            ? global_color_1.withOpacity(0.8)
                            : global_color_4.withOpacity(0.8);
                      },
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      gps = Group_Person_Select.group;
                    });
                    widget.on_change(gps);
                  },
                  child: Text(global_language == Global_Language.ger
                      ? "Gruppe"
                      : "Group")),
            ),
          ],
        )

        /*Stack(
        children: [
          DropdownButton<Group_Person_Select>(
            value: gps,
            icon: Icon(
              Icons.arrow_downward,
              color: Colors.black,
            ),
            iconSize: 20,
            elevation: 16,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            dropdownColor: Colors.white.withOpacity(1),
            /*underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),*/
            onChanged: (Group_Person_Select newValue) {
              widget.on_change(newValue);
              setState(() {
                gps = newValue;
              });
            },
            items: Group_Person_Select.values.map((Group_Person_Select value) {
              return DropdownMenuItem<Group_Person_Select>(
                value: value,
                child: SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        global_group_person_select_info[value].name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),*/
        );
  }
}
