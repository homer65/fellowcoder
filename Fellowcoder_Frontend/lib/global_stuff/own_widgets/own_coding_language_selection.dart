import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:flutter/material.dart';

class Own_Coding_Language_Selection extends StatefulWidget {
  List<dynamic> coding_language_list;
  Function() on_change;
  bool enabled;
  Own_Coding_Language_Selection(
      {this.coding_language_list = const [],
      this.on_change,
      this.enabled = true});
  @override
  _Own_Coding_Language_SelectionState createState() =>
      _Own_Coding_Language_SelectionState();
}

class _Own_Coding_Language_SelectionState
    extends State<Own_Coding_Language_Selection> {
  double _element_width = 140;
  double _element_height = 50;

  void _update() {
    setState(() {});
    widget.on_change();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      children: [
        for (int i = 0; i < widget.coding_language_list.length; i++)
          Own_Coding_Language_Selection_Element(
            coding_language_list: widget.coding_language_list,
            index: i,
            width: _element_width,
            height: _element_height,
            update: _update,
            enabled: widget.enabled,
          ),
        widget.enabled
            ? Own_Coding_Language_Selection_Add(
                coding_language_list: widget.coding_language_list,
                width: _element_width,
                height: _element_height,
                update: _update,
              )
            : Container()
      ],
    );
  }
}

class Own_Coding_Language_Selection_Add extends StatefulWidget {
  List<dynamic> coding_language_list;
  double width;
  double height;
  Function() update;
  Own_Coding_Language_Selection_Add(
      {this.coding_language_list, this.width, this.height, this.update});
  @override
  _Own_Coding_Language_Selection_AddState createState() =>
      _Own_Coding_Language_Selection_AddState();
}

class _Own_Coding_Language_Selection_AddState
    extends State<Own_Coding_Language_Selection_Add> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: global_color_highlight_1,
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
            setState(() {
              widget.coding_language_list.add(
                  global_coding_language_info[Coding_Language.python].name);
            });
            widget.update();
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}

class Own_Coding_Language_Selection_Element extends StatefulWidget {
  List<dynamic> coding_language_list;
  int index;
  double width;
  double height;
  Function() update;
  bool enabled;
  Own_Coding_Language_Selection_Element(
      {this.coding_language_list,
      this.index,
      this.width,
      this.height,
      this.update,
      this.enabled});
  @override
  _Own_Coding_Language_Selection_ElementState createState() =>
      _Own_Coding_Language_Selection_ElementState();
}

class _Own_Coding_Language_Selection_ElementState
    extends State<Own_Coding_Language_Selection_Element> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: global_color_highlight_1,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          widget.enabled
              ? DropdownButton<String>(
                  value: widget.coding_language_list[widget.index],
                  icon: Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                  ),
                  iconSize: 20,
                  elevation: 16,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  dropdownColor: global_color_highlight_1.withOpacity(1),
                  /*underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),*/
                  onChanged: (String newValue) {
                    setState(() {
                      widget.coding_language_list[widget.index] = newValue;
                    });
                    widget.update();
                  },
                  items: Coding_Language.values.map((Coding_Language value) {
                    return DropdownMenuItem<String>(
                      value: global_coding_language_info[value].name,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          Image.asset(
                            global_coding_language_info[value].icon,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(global_coding_language_info[value].name),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : SizedBox(
                  //height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Image.asset(
                        global_coding_language_info.values
                            .firstWhere((element) =>
                                element.name ==
                                widget.coding_language_list[widget.index])
                            .icon,
                        width: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.coding_language_list[widget.index],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
          widget.enabled
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.coding_language_list.removeAt(widget.index);
                    });
                    widget.update();
                  })
              : Container(),
        ],
      ),
    );
  }
}
