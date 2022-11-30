import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../../screens/menu/volunteer/home_page/home_vol.dart';
import '../../screens/menu/volunteer/main_screen.dart';
import '../../screens/menu/volunteer/my_applications/settings_of_application.dart';


String? last_message= '';
final ScrollController _scrollControllerVOL = ScrollController();
class Messages extends StatefulWidget {
  //
  String? name;
  Messages({ required this.name});
  @override
  _MessagesState createState() => _MessagesState(name: name);
}
bool loading = true;

double myMessageLeft(String name_receiver){
  if (name_receiver == currentNameVol){
    return 50;
  }
  else{
    return 3;
  }
}

double myMessageRight(String name_receiver){
  if (name_receiver == currentNameVol){
    return 3;
  }
  else{
    return 50;
  }
}
class _MessagesState extends State<Messages> {

  String? name;
  _MessagesState({ required this.name});

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottom = PersistentTabController(initialIndex: 0);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: background,
            title: Text(
              ("Messages"),
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: blueColor,
              ),
              onPressed: () {
                setState(() {
                  controllerTabBottom = PersistentTabController(initialIndex: 0);
                });
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainScreen()));
              },
            ),
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          // floatingActionButton: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back_ios_new_rounded,
          //     size: 30,
          //     color: blueColor,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       controllerTabBottom = PersistentTabController(initialIndex: 0);
          //     });
          //     Navigator.of(context, rootNavigator: true).pushReplacement(
          //         MaterialPageRoute(builder: (context) => MainScreen()));
          //   },
          // ),
          backgroundColor: background,
          body: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("USERS_COLLECTION")
                    .doc(IdOfChatroom)
                    .collection("CHATROOMS_COLLECTION")
                    .orderBy('time')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs");
                  print(FirebaseAuth.instance.currentUser?.uid);
                  if (!snapshot.hasData){
                    return Loading();
                  }
                  if (snapshot.hasError) {
                    return Text("Something is wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      controller: _scrollControllerVOL,
                      // physics: ScrollPhysics(),
                      shrinkWrap: true,
                      // primary: true,
                      itemBuilder: (_, index) {
                        QueryDocumentSnapshot qs = snapshot.data!.docs[index];
                        Timestamp t = qs['time'];
                        DateTime d = t.toDate();

                        print(d.toString());
                        final dataKey = GlobalKey();
                        return Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8, left: myMessageLeft(snapshot.data?.docs[index]["name"]), right: myMessageRight(snapshot.data?.docs[index]["name"])),
                          child: Column(
                            // crossAxisAlignment: name == qs['name']
                            //     ? CrossAxisAlignment.end
                            //     : CrossAxisAlignment.start,
                            children: [
                              Container(
                          decoration: new BoxDecoration(
                              color: snapshot.data?.docs[index]["name"] == currentNameVol ? Colors.white:blueColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                            ),

                                child: ListTile(
                                  key: dataKey,

                                  title: Text(
                                    qs['name'],
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 190,
                                        child: Text(
                                          qs['message'],
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        d.hour.toString() + ":" + d.minute.toString(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedChatroom extends StatefulWidget {
  const SelectedChatroom({Key? key}) : super(key: key);

  @override
  State<SelectedChatroom> createState() => _SelectedChatroomState();
}
// String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
class _SelectedChatroomState extends State<SelectedChatroom> {

  // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;

  writeMessages(){
    FirebaseFirestore.instance.collection("USERS_COLLECTION").doc(IdOfChatroom).collection("CHATROOMS_COLLECTION").doc().set(
        {
          'message': message_v.text.trim(),
          'time': DateTime.now(),
          'name': currentNameVol,
          'id_message': "null"

        }
    );

  }

  final TextEditingController message_v = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottom = PersistentTabController(initialIndex: 0);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        resizeToAvoidBottomInset: true,
        // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        // floatingActionButton: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back_ios_new_rounded,
        //     size: 30,
        //     color: blueColor,
        //   ),
        //   onPressed: () {
        //     setState(() {
        //       controllerTabBottom = PersistentTabController(initialIndex: 0);
        //     });
        //     Navigator.of(context, rootNavigator: true).pushReplacement(
        //         MaterialPageRoute(builder: (context) => MainScreen()));
        //   },
        // ),
        body: SingleChildScrollView(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.91,
                child: Messages(
                  name: currentNameVol,
                ),
              ),
              Padding(
                padding: EdgeInsets.only( right: 5),
                child: Container(
                  color: background,
                  height: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: padding,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: TextFormField(
                                controller: message_v,
                                decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Message',
                                enabled: true,
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                  new BorderSide(color: blueColor),
                                  borderRadius: new BorderRadius.circular(24),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  new BorderSide(color: blueColor),
                                  borderRadius: new BorderRadius.circular(24),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  new BorderSide(color: blueColor),
                                  borderRadius: new BorderRadius.circular(24),
                                ),
                              ),
                                validator: (value) {

                                },
                                onSaved: (value) {
                                  message_v.text = value!;
                                },
                              ),
                            ),
                          ),
                          CircleAvatar(
                              radius: 25,
                              backgroundColor: blueColor,
                            child: IconButton(
                              onPressed: () async {
                                // messages(name: current_name_Vol,);
                                if (message_v.text.isNotEmpty) {
                                  writeMessages();
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  SchedulerBinding.instance?.addPostFrameCallback((_) {
                                    _scrollControllerVOL.animateTo(
                                        _scrollControllerVOL.positions.last.maxScrollExtent,
                                        // _scrollControllerVOL.position.maxScrollExtent,
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.easeIn);


                                  });
                                  // FirebaseFirestore.instance.collection("USERS_COLLECTION").doc(IdOfChatroom).collection("CHATROOMS_COLLECTION").doc().update(
                                  //     {"id_message": FirebaseFirestore.instance.collection("USERS_COLLECTION").doc(IdOfChatroom).collection("CHATROOMS_COLLECTION").doc().id});
                                  // print("UUUUUUUUUUUUU______________HHHHHHHHHHHHHHHHHHHH");
                                  // print(last_message);
                                  message_v.clear();
                                }
                              },
                              icon: Icon(Icons.send_sharp, color: Colors.white,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class ChatPage extends StatefulWidget {
//   // String name;
//   // ChatPage({required this.name});
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   // String name;
//   // _ChatPageState({required this.name});
//
//   final fs = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   final TextEditingController message = new TextEditingController();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//             "Chat"
//         ),
//         actions: [
//           // MaterialButton(
//           //   onPressed: () {
//           //     _auth.signOut().whenComplete(() {
//           //       Navigator.pushReplacement(
//           //         context,
//           //         MaterialPageRoute(
//           //           builder: (context) => OptionChoose(),
//           //         ),
//           //       );
//           //     });
//           //   },
//           //   child: Text(
//           //     "signOut",
//           //   ),
//           // ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.79,
//               child: messages(
//                 name: "name",
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: message,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.purple[100],
//                       hintText: 'message',
//                       enabled: true,
//                       contentPadding: const EdgeInsets.only(
//                           left: 14.0, bottom: 8.0, top: 8.0),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: new BorderSide(color: Colors.purple),
//                         borderRadius: new BorderRadius.circular(10),
//                       ),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: new BorderSide(color: Colors.purple),
//                         borderRadius: new BorderRadius.circular(10),
//                       ),
//                     ),
//                     validator: (value) {
//
//                     },
//                     onSaved: (value) {
//                       message.text = value!;
//                     },
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () async {
//                     messages(name: current_name_Vol,);
//                     loading = false;
//                     await Future.delayed(const Duration(milliseconds: 300));
//                     SchedulerBinding.instance?.addPostFrameCallback((_) {
//                       _scrollControllerVOL.animateTo(
//                           _scrollControllerVOL.position.maxScrollExtent,
//                           duration: Duration(milliseconds: 500),
//                           curve: Curves.fastOutSlowIn);
//                     });
//                     if (message.text.isNotEmpty) {
//                       fs.collection('Messages').doc().set({
//                         'message': message.text.trim(),
//                         'time': DateTime.now(),
//                         'name': "name",
//                       });
//                       message.clear();
//                     }
//                   },
//                   icon: Icon(Icons.send_sharp),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }