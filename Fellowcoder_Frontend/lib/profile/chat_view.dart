import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/basic_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chat_View extends StatefulWidget {
  static const String route = '/chat_view';
  @override
  _Chat_ViewState createState() => _Chat_ViewState();
}

class _Chat_ViewState extends State<Chat_View> {
  String _active_chat;
  PageController _pc = PageController();

  @override
  void initState() {
    super.initState();
    _active_chat = global_user_data.chats[0]["chat_id"];
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;
    return _on_mobile
        ? PageView(
            controller: _pc,
            children: [
              Chat_View_Select(
                selected_chat: (selected_chat) {
                  setState(() {
                    _active_chat = selected_chat;
                  });
                  _pc.animateToPage(1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                },
              ),
              Chat_View_Messages(_active_chat)
            ],
          )
        : Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Chat_View_Select(
                    selected_chat: (selected_chat) {
                      setState(() {
                        _active_chat = selected_chat;
                      });
                    },
                  )),
              Expanded(flex: 4, child: Chat_View_Messages(_active_chat)),
            ],
          );
  }
}

class Chat_View_Select extends StatefulWidget {
  Function(String selected_chat) selected_chat;
  Chat_View_Select({this.selected_chat});
  @override
  _Chat_View_SelectState createState() => _Chat_View_SelectState();
}

class _Chat_View_SelectState extends State<Chat_View_Select> {
  @override
  void initState() {
    super.initState();
    //print(global_user_data.chats);
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;
    return Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          border: Border(
            right: BorderSide(width: _on_mobile ? 0 : 1.0, color: Colors.black),
          ),
        ),
        child: ListView(
          children: [
            for (Map<String, dynamic> element in global_user_data.chats)
              Container(
                height: 60,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                    bottom: BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Basic_Image(
                        "assets/images/image_default.jpeg",
                        padding: EdgeInsets.all(5),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(element["partner_name"]),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(
                        "letzte Zeit / Datum",
                        style: TextStyle(fontSize: 10),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  onPressed: () {
                    widget.selected_chat(element["chat_id"]);
                  },
                ),
              )
          ],
        ));
  }
}

class Chat_View_Messages extends StatefulWidget {
  String selected_chat;
  Chat_View_Messages(this.selected_chat);
  @override
  _Chat_View_MessagesState createState() => _Chat_View_MessagesState();
}

class _Chat_View_MessagesState extends State<Chat_View_Messages> {
  List<Map<String, dynamic>> _chat;

  @override
  void initState() {
    super.initState();
    _get_chat();
  }

  void _get_chat() async {
    _chat = [];
    _chat = await Backend_Com().get_complete_chat(widget.selected_chat);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.orangeAccent.withOpacity(0.005),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (Map<String, dynamic> e in _chat)
                    Chat_View_Messages_Element(e)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 2,
                      decoration: InputDecoration(hintText: "Nachricht"),
                    ),
                  )),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: 70,
                    height: 70,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Icon(
                        Icons.send,
                        //color: Colors.white,
                      ),
                      color: Colors.orangeAccent,
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class Chat_View_Messages_Element extends StatefulWidget {
  Map<String, dynamic> message;
  Chat_View_Messages_Element(this.message);
  @override
  _Chat_View_Messages_ElementState createState() =>
      _Chat_View_Messages_ElementState();
}

class _Chat_View_Messages_ElementState
    extends State<Chat_View_Messages_Element> {
  bool _own_message;

  @override
  void initState() {
    super.initState();
    _own_message = widget.message["user_id"] == "ich";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _own_message
            ? Expanded(
                child: SizedBox(),
              )
            : Container(),
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          width: 290,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.orangeAccent.withOpacity(0.4),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(widget.message["text"])),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('dd.MM.yyyy HH:mm')
                      .format(string_to_date(widget.message["time"])),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        _own_message
            ? Container()
            : Expanded(
                child: SizedBox(),
              ),
      ],
    );
  }
}
