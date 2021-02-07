import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:flutter/material.dart';

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
        color: Colors.blueAccent,
        child: ListView(
          children: [
            for (Map<String, dynamic> element in global_user_data.chats)
              Container(
                height: 100,
                margin: EdgeInsets.all(5),
                color: Colors.redAccent,
                child: FlatButton(
                  child: Text(element["partner_name"]),
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
    _chat = await Backend_Com().get_complete_chat(widget.selected_chat);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.greenAccent,
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
              color: Colors.blueGrey,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 2,
                    ),
                  )),
                  FlatButton(
                    child: Text("Send"),
                    onPressed: () {},
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 100,
      width: 300,
      color: Colors.amberAccent,
      child: Text(widget.message.toString()),
    );
  }
}
