import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:flutter/material.dart';

class Chat_View extends StatefulWidget {
  static const String route = '/chat_view';
  @override
  _Chat_ViewState createState() => _Chat_ViewState();
}

class _Chat_ViewState extends State<Chat_View> {
  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;
    return _on_mobile
        ? PageView(
            children: [Chat_View_Select(), Chat_View_Messages()],
          )
        : Row(
            children: [
              Expanded(flex: 1, child: Chat_View_Select()),
              Expanded(flex: 4, child: Chat_View_Messages()),
            ],
          );
  }
}

class Chat_View_Select extends StatefulWidget {
  @override
  _Chat_View_SelectState createState() => _Chat_View_SelectState();
}

class _Chat_View_SelectState extends State<Chat_View_Select> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
    );
  }
}

class Chat_View_Messages extends StatefulWidget {
  @override
  _Chat_View_MessagesState createState() => _Chat_View_MessagesState();
}

class _Chat_View_MessagesState extends State<Chat_View_Messages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
    );
  }
}
