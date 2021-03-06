import 'dart:async';

import 'package:Fellowcoder_Frontend/global_stuff/backend_com.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_functions.dart';
import 'package:Fellowcoder_Frontend/global_stuff/global_variables.dart';
import 'package:Fellowcoder_Frontend/global_stuff/own_widgets/basic_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat_View extends StatefulWidget {
  static const String route = '/chat_view';
  @override
  _Chat_ViewState createState() => _Chat_ViewState();
}

class _Chat_ViewState extends State<Chat_View> {
  String _active_chat;
  String _partner_id;
  PageController _pc = PageController();
  bool _loading = true;
  StreamSubscription _global_stream_sub;

  @override
  void initState() {
    super.initState();
    _global_stream_sub = global_rebuild_controller.stream.listen((data) {
      if (global_user_data.name != null) {
        if (global_user_data.chats.length > 0) {
          _active_chat = global_user_data.chats[0]["chat_id"];
        }
        _loading = false;
        setState(() {});
      }
    });
    if (global_user_data != null) {
      if (global_user_data.name != null) {
        _loading = false;
        if (global_user_data.chats.length > 0) {
          _active_chat = global_user_data.chats[0]["chat_id"];
        }
      }
    }
  }

  @override
  void dispose() {
    _global_stream_sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;

    if (global_user_data.chats.length > 0) {
      _partner_id = global_user_data.chats.firstWhere(
          (element) => element["chat_id"] == _active_chat)["partner_id"];
    } else {
      _partner_id = "";
    }
    return _loading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          )
        : _on_mobile
            ? PageView(
                controller: _pc,
                children: [
                  Chat_View_Select(
                    active_chat: _active_chat,
                    selected_chat: (selected_chat) {
                      setState(() {
                        _active_chat = selected_chat;
                      });
                      _pc.animateToPage(1,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    },
                  ),
                  Chat_View_Messages(
                      _active_chat,
                      global_user_data.chats.firstWhere((element) =>
                          element["chat_id"] == _active_chat)["partner_id"],
                      ValueKey(_active_chat))
                ],
              )
            : Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Chat_View_Select(
                        active_chat: _active_chat,
                        selected_chat: (selected_chat) {
                          setState(() {
                            _active_chat = selected_chat;
                          });
                        },
                      )),
                  Expanded(
                      flex: 4,
                      child: Chat_View_Messages(
                          _active_chat, _partner_id, ValueKey(_active_chat))),
                ],
              );
  }
}

class Chat_View_Select extends StatefulWidget {
  Function(String selected_chat) selected_chat;
  String active_chat;
  Chat_View_Select({this.selected_chat, this.active_chat});
  @override
  _Chat_View_SelectState createState() => _Chat_View_SelectState();
}

class _Chat_View_SelectState extends State<Chat_View_Select> {
  StreamSubscription _docstreamsub;
  Stream documentStream;
  bool _delete_visible = false;
  String _delete_chat = "";
  @override
  void initState() {
    super.initState();
    //print(global_user_data.chats);
    documentStream = FirebaseFirestore.instance
        .collection('benutzer')
        .doc(global_user_data.id)
        .snapshots();
    _docstreamsub = documentStream.listen((documentSnapshot) {
      DocumentSnapshot ds = documentSnapshot;
      /*print(global_user_data.chats);
      print("-A---");
      print(ds.data()["chats"]);
      print("-A-A-A-");*/
      if (global_user_data != null && ds.data()["chats"] != null) {
        global_user_data.chats = [];
        ds.data()["chats"].forEach((value) {
          global_user_data.chats.add(value);
        });
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _docstreamsub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    bool _on_mobile = _screen_size.width < global_mobile_treshold;
    return Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: global_color_1.withOpacity(0.2),
          border: Border(
            right: BorderSide(width: _on_mobile ? 0 : 1.0, color: Colors.black),
          ),
        ),
        child: widget.active_chat == null
            ? Text(
                global_language == Global_Language.ger
                    ? "noch keine Chats"
                    : "no chats yet",
                textAlign: TextAlign.center,
              )
            : ListView(
                children: [
                  for (Map<String, dynamic> element in global_user_data.chats)
                    Stack(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(color: Colors.black))),
                          onPressed: () {
                            widget.selected_chat(element["chat_id"]);
                          },
                          onLongPress: () {
                            setState(() {
                              _delete_chat = element["chat_id"];
                              _delete_visible = true;
                            });
                          },
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              color: element["chat_id"] == widget.active_chat
                                  ? global_color_4
                                  : global_color_1.withOpacity(0.7),
                              /*border: Border(
                                top: BorderSide(
                                  width: 1.0,
                                  color: Colors.black,
                                ),
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: Colors.black,
                                ),
                              ),*/
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Basic_Image(
                                      element["partner_picture"],
                                      padding: EdgeInsets.all(5),
                                      width: 60,
                                      height: 60,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(element["partner_name"],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    element["last_message_time"] == null
                                        ? "-"
                                        : DateFormat('dd.MM.yyyy HH:mm').format(
                                            string_to_date(
                                                element["last_message_time"])),
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _delete_visible && element["chat_id"] == _delete_chat
                            ? Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  color: Colors.redAccent.withOpacity(1),
                                ),
                                margin: EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          var _response = await Backend_Com()
                                              .chateintrag_loeschen(
                                                  element["chat_id"],
                                                  element["partner_id"]);
                                          setState(() {
                                            global_user_data.chats.removeWhere(
                                                (el) =>
                                                    el["chat_id"] ==
                                                    element["chat_id"]);
                                            _delete_chat = "";
                                            _delete_visible = false;
                                          });
                                        },
                                        icon: Row(
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.black),
                                          ],
                                        )),
                                    Text(
                                      global_language == Global_Language.ger
                                          ? "Chat für alle löschen"
                                          : "delete chat for all",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Expanded(child: SizedBox()),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _delete_chat = "";
                                            _delete_visible = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.black,
                                        )),
                                    Text(
                                      global_language == Global_Language.ger
                                          ? "abbrechen"
                                          : "cancel",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )
                ],
              ));
  }
}

class Chat_View_Messages extends StatefulWidget {
  String selected_chat;
  String partner_id;
  Key key;
  Chat_View_Messages(this.selected_chat, this.partner_id, this.key);
  @override
  _Chat_View_MessagesState createState() => _Chat_View_MessagesState();
}

class _Chat_View_MessagesState extends State<Chat_View_Messages> {
  List<Map<String, dynamic>> _chat;
  TextEditingController _message_controller = TextEditingController();
  ScrollController _scroll_controller = ScrollController();
  StreamSubscription _docstreamsub;

  @override
  void initState() {
    super.initState();
    _get_chat();
    Stream documentStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.selected_chat)
        .snapshots();
    _docstreamsub = documentStream.listen((documentSnapshot) {
      DocumentSnapshot ds = documentSnapshot;
      _chat = [];
      ds.data()["messages"].forEach((value) {
        _chat.add(value);
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    _docstreamsub.cancel();
    super.dispose();
  }

  void _get_chat() async {
    _chat = [];
    if (widget.selected_chat != null) {
      _chat = await Backend_Com().chateintrag_daten_lesen(widget.selected_chat);
    }
    setState(() {});
  }

  void _scroll_down() {
    _scroll_controller.animateTo(
      _scroll_controller.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return global_user_data.chats.length > 0
        ? Container(
            child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scroll_controller,
                  children: [
                    for (Map<String, dynamic> e in _chat)
                      Chat_View_Messages_Element(e)
                  ],
                ),
              ),
              Container(
                height: 80,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: global_color_4.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _message_controller,
                        maxLines: 2,
                        decoration: InputDecoration(
                            hintText: global_language == Global_Language.ger
                                ? "Nachricht"
                                : "Message"),
                      ),
                    )),
                    Container(
                      //padding: EdgeInsets.all(5),
                      width: 80,
                      height: 80,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child:
                            Icon(Icons.send, color: Colors.black //Colors.white,
                                ),
                        color: global_color_4,
                        onPressed: () async {
                          if (_message_controller.text != "" &&
                              _message_controller.text != null) {
                            await Backend_Com().chatnachricht_hinzufuegen(
                                widget.selected_chat,
                                widget.partner_id,
                                _message_controller.text);
                            /*Map<String, String> _temp = {
                            "time": DateTime.now().toString(),
                            "user_id": global_user_data.id,
                            "text": _message_controller.text
                          };
                          _chat.add(_temp);*/
                            _message_controller.text = "";
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _scroll_down());
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ))
        : Center(
            child: Text(
              global_language == Global_Language.ger
                  ? "Such nach Programmieren mit gleichen Interessen und schreibe sie an um zusammen coole Projekte umzusetzen."
                  : "Look for programmers with similar interests and contact them to implement cool projects together.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
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
    _own_message = widget.message["user_id"] == global_user_data.id;
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
            color: _own_message
                ? global_color_4.withOpacity(0.9)
                : global_color_1.withOpacity(0.4),
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
