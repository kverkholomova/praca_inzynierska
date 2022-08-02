import 'package:flutter/material.dart';
import 'package:wol_pro_1/chat_3/models/chatUsersModel.dart';
import 'package:wol_pro_1/chat_3/widgets/conversationList.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center()
      ),
    );
  }
}