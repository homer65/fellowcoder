import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:flutter/material.dart';

enum Group_Goal_Select { team, forum, discussion }

class Group_Goal_Select_Info {
  String name;
  Group_Goal_Select_Info({this.name});
}

final Map<Group_Goal_Select, Group_Goal_Select_Info>
    global_group_goal_select_info = {
  Group_Goal_Select.team: Group_Goal_Select_Info(name: "Team"),
  Group_Goal_Select.forum: Group_Goal_Select_Info(name: "Forum"),
  Group_Goal_Select.discussion: Group_Goal_Select_Info(name: "Diskussion"),
};

class Own_Group_Goal_Select extends StatefulWidget {
  bool greyed_out;
  Group_Goal_Select init_ggs;
  Function(Group_Goal_Select) on_change;
  Own_Group_Goal_Select(
      {this.init_ggs = Group_Goal_Select.team,
      this.on_change,
      this.greyed_out = false});
  @override
  _Own_Group_Goal_SelectState createState() => _Own_Group_Goal_SelectState();
}

class _Own_Group_Goal_SelectState extends State<Own_Group_Goal_Select> {
  Group_Goal_Select ggs;
  @override
  void initState() {
    super.initState();
    ggs = widget.init_ggs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: 140,
      height: 50,
      child: Stack(
        children: [
          DropdownButton<Group_Goal_Select>(
            value: ggs,
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
            onChanged: (Group_Goal_Select newValue) {
              widget.on_change(newValue);
              setState(() {
                ggs = newValue;
              });
            },
            items: Group_Goal_Select.values.map((Group_Goal_Select value) {
              return DropdownMenuItem<Group_Goal_Select>(
                value: value,
                child: SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        global_group_goal_select_info[value].name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          widget.greyed_out
              ? Container(
                  width: 140,
                  height: 50,
                  color: Colors.grey.withOpacity(0.5),
                )
              : Container(),
        ],
      ),
    );
  }
}
