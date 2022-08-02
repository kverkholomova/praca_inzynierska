import 'package:flutter/material.dart';
import 'package:wol_pro_1/chat_3/chatPage.dart';
import 'package:wol_pro_1/chat_3/widgets/conversationList.dart';

import 'models/chatUsersModel.dart';

class HomePage_3 extends StatelessWidget{

  List<ChatUsers> chatUsers = [
    ChatUsers(name: "Jane Russel", messageText: "That's Great", imageURL: "images/userImage1.jpeg", time: "Now"),
    ChatUsers(name: "Johny Depp", messageText: "That's Great", imageURL: "images/userImage1.jpeg", time: "Now"),
    ChatUsers(name: "Jo Pain", messageText: "That's Great", imageURL: "images/userImage1.jpeg", time: "Now"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversations",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add,color: Colors.pink,size: 20,),
                          SizedBox(width: 2,),
                          Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),

            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3)?true:false,

                );
              },
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //
    //   body: ChatPage(),
    //   // bottomNavigationBar: BottomNavigationBar(
    //   //   selectedItemColor: Colors.red,
    //   //   unselectedItemColor: Colors.grey.shade600,
    //   //   selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
    //   //   unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
    //   //   type: BottomNavigationBarType.fixed,
    //   //   items: const [
    //   //     BottomNavigationBarItem(
    //   //       icon: Icon(Icons.message),
    //   //       // title: Text("Chats"),
    //   //     ),
    //   //     BottomNavigationBarItem(
    //   //       icon: Icon(Icons.group_work),
    //   //       // title: Text("Channels"),
    //   //     ),
    //   //     // BottomNavigationBarItem(
    //   //     //   icon: Icon(Icons.account_box),
    //   //     //   // title: Text("Profile"),
    //   //     // ),
    //   //   ],
    //   // ),
    // );
  }
}