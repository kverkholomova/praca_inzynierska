// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';
//
// void main() async {
//   const STREAM_KEY = String.fromEnvironment('api');
//   const USER_TOKEN = String.fromEnvironment('token');
//
//   final client = StreamChatClient(
//     STREAM_KEY,
//     logLevel: Level.OFF,
//   );
//
//   await client.connectUser(
//     User(
//       id: 'neevash',
//       extraData: {
//         'image':
//         'https://local.getstream.io:9000/random_png/?id=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZGVsaWNhdGUtZmlyZS02In0.Yfdnsfkt48g1xv3I77mBjlVISnLwMyVUFobBynTf6Jc&amp;name=delicate-fire-6',
//       },
//     ),
//     USER_TOKEN,
//   );
//
//   final channel = client.channel('messaging', id: 'sample-app-channel-1');
//   channel.watch();
//
//   runApp(MyApp(client: client));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key, required this.client}) : super(key: key);
//   final StreamChatClient client;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       builder: (context, widget) {
//         return StreamChat(
//           child: widget!,
//           client: client,
//         );
//       },
//       home: ChannelListPage(),
//     );
//   }
// }
//
// class ChannelListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stream Playground'),
//       ),
//       body: ChannelsBloc(
//         child: ChannelListView(
//           filter: Filter.in_('members', [StreamChat.of(context).user!.id]),
//           sort: [SortOption('last_message_at')],
//           pagination: PaginationParams(
//             limit: 30,
//           ),
//           channelWidget: Builder(builder: (context) => ChannelPage()),
//         ),
//       ),
//     );
//   }
// }
//
// class ChannelPage extends StatefulWidget {
//   const ChannelPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _ChannelPageState createState() => _ChannelPageState();
// }
//
// class _ChannelPageState extends State<ChannelPage> {
//   Location? location;
//   StreamSubscription<LocationData>? locationSubscription;
//   GlobalKey<MessageInputState> _messageInputKey = GlobalKey();
//   late Channel _channel;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _channel = StreamChannel.of(context).channel;
//   }
//
//   Future<bool> setupLocation() async {
//     if (location == null) {
//       location = Location();
//     }
//     var _serviceEnabled = await location!.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location!.requestService();
//       if (!_serviceEnabled) {
//         return false;
//       }
//     }
//
//     var _permissionGranted = await location!.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location!.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   Future<void> onLocationRequestPressed() async {
//     final canSendLocation = await setupLocation();
//     if (canSendLocation != true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               "We can't access your location at this time. Did you allow location access?"),
//         ),
//       );
//     }
//
//     final locationData = await location!.getLocation();
//     _messageInputKey.currentState?.addAttachment(
//       Attachment(
//         type: 'location',
//         uploadState: UploadState.success(),
//         extraData: {
//           'lat': locationData.latitude,
//           'long': locationData.longitude,
//         },
//       ),
//     );
//     return;
//   }
//
//   Future<void> startLocationTracking(
//       String messageId,
//       String attachmentId,
//       ) async {
//     final canSendLocation = await setupLocation();
//     if (canSendLocation != true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               "We can't access your location at this time. Did you allow location access?"),
//         ),
//       );
//     }
//
//     locationSubscription = location!.onLocationChanged.listen(
//           (LocationData event) {
//         _channel.sendEvent(
//           Event(
//             type: 'location_update',
//             extraData: {
//               'lat': event.latitude,
//               'long': event.longitude,
//             },
//           ),
//         );
//       },
//     );
//
//     return;
//   }
//
//   void cancelLocationSubscription() => locationSubscription?.cancel();
//
//   Widget _buildLocationMessage(
//       BuildContext context,
//       Message details,
//       List<Attachment> _,
//       ) {
//     final username = details.user!.name;
//     final lat = details.attachments.first.extraData['lat'] as double;
//     final long = details.attachments.first.extraData['long'] as double;
//     return InkWell(
//       onTap: () {
//         startLocationTracking(details.id, details.attachments.first.id);
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => GoogleMapsView(
//               onBack: cancelLocationSubscription,
//               message: details,
//               channelName: username,
//               channel: _channel,
//             ),
//           ),
//         );
//       },
//       child: wrapAttachmentWidget(
//         context,
//         MapImageThumbnail(
//           lat: lat,
//           long: long,
//         ),
//         RoundedRectangleBorder(),
//         true,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ChannelHeader(),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: MessageListView(
//               customAttachmentBuilders: {'location': _buildLocationMessage},
//             ),
//           ),
//           MessageInput(
//             key: _messageInputKey,
//             attachmentThumbnailBuilders: {
//               'location': (context, attachment) => MapImageThumbnail(
//                 lat: attachment.extraData['lat'] as double,
//                 long: attachment.extraData['long'] as double,
//               )
//             },
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.location_history),
//                 onPressed: onLocationRequestPressed,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MapImageThumbnail extends StatelessWidget {
//   const MapImageThumbnail({
//     Key? key,
//     required this.lat,
//     required this.long,
//   }) : super(key: key);
//
//   final double lat;
//   final double long;
//
//   String get _constructUrl => Uri(
//     scheme: 'https',
//     host: 'maps.googleapis.com',
//     port: 443,
//     path: '/maps/api/staticmap',
//     queryParameters: {
//       'center': '$lat,$long',
//       'zoom': '18',
//       'size': '700x500',
//       'maptype': 'roadmap',
//       'key': 'MAP_KEY',
//       'markers': 'color:red|$lat,$long'
//     },
//   ).toString();
//
//   @override
//   Widget build(BuildContext context) {
//     return Image.network(
//       _constructUrl,
//       height: 300.0,
//       width: 600.0,
//       fit: BoxFit.fill,
//     );
//   }
// }
//
// class GoogleMapsView extends StatefulWidget {
//   const GoogleMapsView({
//     Key? key,
//     required this.channelName,
//     required this.message,
//     required this.channel,
//     required this.onBack,
//   }) : super(key: key);
//   final String channelName;
//   final Message message;
//   final Channel channel;
//   final VoidCallback onBack;
//
//   @override
//   _GoogleMapsViewState createState() => _GoogleMapsViewState();
// }
//
// class _GoogleMapsViewState extends State<GoogleMapsView> {
//   late StreamSubscription _messageSubscription;
//   late double lat;
//   late double long;
//
//   GoogleMapController? mapController;
//
//   Attachment get _messageAttachment => widget.message.attachments.first;
//
//   @override
//   void initState() {
//     super.initState();
//     lat = _messageAttachment.extraData['lat'] as double;
//     long = _messageAttachment.extraData['long'] as double;
//     _messageSubscription =
//         widget.channel.on('location_update').listen(_updateHandler);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _messageSubscription.cancel();
//   }
//
//   void _updateHandler(Event event) {
//     double _newLat = event.extraData['lat'] as double;
//     double _newLong = event.extraData['long'] as double;
//
//     setState(() {
//       lat = _newLat;
//       long = _newLong;
//     });
//
//     mapController?.animateCamera(
//       CameraUpdate.newLatLng(
//         LatLng(
//           _newLat,
//           _newLong,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _pos = LatLng(lat, long);
//     return WillPopScope(
//       onWillPop: () async {
//         widget.onBack();
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             widget.channelName,
//             style: TextStyle(
//               color: Colors.black,
//             ),
//           ),
//           backgroundColor: Colors.white,
//         ),
//         body: AnimatedCrossFade(
//           duration: kThemeAnimationDuration,
//           crossFadeState: mapController != null
//               ? CrossFadeState.showFirst
//               : CrossFadeState.showSecond,
//           firstChild: ConstrainedBox(
//             constraints: BoxConstraints.loose(MediaQuery.of(context).size),
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _pos,
//                 zoom: 18,
//               ),
//               onMapCreated: (_controller) =>
//                   setState(() => mapController = _controller),
//               markers: {
//                 Marker(
//                   markerId: MarkerId("user-location-marker-id"),
//                   position: _pos,
//                 )
//               },
//             ),
//           ),
//           secondChild: Container(
//             child: Center(
//               child: Icon(
//                 Icons.location_history,
//                 color: Colors.red.withOpacity(0.76),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:wol_pro_1/app.dart';
// import 'package:wol_pro_1/constants.dart';
// import 'package:wol_pro_1/screens/menu/volunteer/my_applications/settings_of_application.dart';
//
// import '../home_page/home_vol.dart';
// import '../main_screen.dart';
// import 'pageWithChatsVol.dart';
//
//
// bool firstChat = true;
// String color = "blue";
//
// class MessagesVolFirst extends StatefulWidget {
//   //
//   String? name;
//
//   MessagesVolFirst({required this.name});
//
//   @override
//   _MessagesVolFirstState createState() => _MessagesVolFirstState(name: name);
// }
//
// bool loading = true;
//
// double myMessageLeftVol(String name_receiver) {
//   if (name_receiver == currentNameVol) {
//     return 40;
//   } else {
//     return 5;
//   }
// }
//
// double myMessageRightVol(String name_receiver) {
//   if (name_receiver == currentNameVol) {
//     return 5;
//   } else {
//     return 40;
//   }
// }
//
// class _MessagesVolFirstState extends State<MessagesVolFirst> {
//   String? name;
//
//   _MessagesVolFirstState({required this.name});
//
//   //
//   // Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
//   //     .collection('Messages')
//   //     // .where("id_of_adressee", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//   //     .orderBy('time')
//   //     .snapshots();
//   @override
//   Widget build(BuildContext context) {
//     // return isLoading() ? Loading() :StreamBuilder(
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
//
//
//           controllerTabBottomVol = PersistentTabController(initialIndex: 0);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreen()));
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 size: 30,
//                 color: blueColor,
//               ),
//               onPressed: () {
//                 setState(() {
//
//                   scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
//
//                   controllerTabBottomVol = PersistentTabController(initialIndex: 0);
//                 });
//                 Navigator.of(context, rootNavigator: true).pushReplacement(
//                     MaterialPageRoute(builder: (context) => MainScreen()));
//               },
//             ),
//             title: Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 ("Messages"),
//                 style: GoogleFonts.raleway(
//                   fontSize: 18,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//
//           ),
//           // resizeToAvoidBottomInset: false,
//
//           backgroundColor: background,
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.75,
//                   child: StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection("USERS_COLLECTION")
//                         .doc(IdOfChatroomVol)
//                         .collection("CHATROOMS_COLLECTION")
//                         .orderBy('time')
//                         .snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       print(
//                           "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs");
//                       print(FirebaseAuth.instance.currentUser?.uid);
//
//                       if (snapshot.hasError) {
//                         return Text("Something is wrong");
//                       }
//                       if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 0),
//                         child: ListView.builder(
//                           controller: scrollControllerVol,
//                           itemCount: snapshot.data!.docs.length,
//                           // physics: NeverScrollableScrollPhysics(),
//
//                           // physics: ScrollPhysics(),
//                           shrinkWrap: true,
//                           // primary: true,
//                           itemBuilder: (_, index) {
//                             QueryDocumentSnapshot qs =
//                             snapshot.data!.docs[index];
//                             Timestamp t = qs['time'];
//                             DateTime d = t.toDate();
//                             print(d.toString());
//                             final dataKey = GlobalKey();
//                             return Padding(
//                               padding: EdgeInsets.only(
//                                   top: 8,
//                                   bottom: 8,
//                                   left: myMessageLeftVol(
//                                       snapshot.data?.docs[index]["name"]),
//                                   right: myMessageRightVol(snapshot
//                                       .data?.docs[index]["name"])),
//                               child: Column(
//                                 // crossAxisAlignment: name == qs['name']
//                                 //     ? CrossAxisAlignment.end
//                                 //     : CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     decoration: new BoxDecoration(
//                                         color: snapshot.data?.docs[index]
//                                         ["name"] ==
//                                             currentNameVol
//                                             ? Colors.white
//                                             : blueColor.withOpacity(0.2),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10))),
//                                     // width: 300,
//
//                                     child: ListTile(
//                                       key: dataKey,
//                                       // shape: RoundedRectangleBorder(
//                                       //   side: BorderSide(
//                                       //     color: snapshot.data?.docs[index]["name"] == current_name_Vol ? Colors.blue:Colors.purple,
//                                       //   ),
//                                       //   borderRadius: BorderRadius.circular(10),
//                                       // ),
//                                       title: Text(
//                                         qs['name'],
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       subtitle: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment
//                                             .spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: 200,
//                                             child: Text(
//                                               qs['message'],
//                                               softWrap: true,
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             d.hour.toString() +
//                                                 ":" +
//                                                 d.minute.toString(),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SelectedChatroomVolFirst extends StatefulWidget {
//   const SelectedChatroomVolFirst({Key? key}) : super(key: key);
//
//   @override
//   State<SelectedChatroomVolFirst> createState() => _SelectedChatroomVolFirstState();
// }
//
// // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
// class _SelectedChatroomVolFirstState extends State<SelectedChatroomVolFirst> {
//   // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
//
//   writeMessages() {
//     FirebaseFirestore.instance
//         .collection("USERS_COLLECTION")
//         .doc(IdOfChatroomVol)
//         .collection("CHATROOMS_COLLECTION")
//         .doc()
//         .set({
//       'message': message.text.trim(),
//       'time': DateTime.now(),
//       'name': currentNameVol,
//       'id_message': "null"
//     });
//   }
//   late StreamSubscription<User?> user;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     user = FirebaseAuth.instance.authStateChanges().listen((user) async {
//         DocumentSnapshot variable = await FirebaseFirestore.instance.
//           collection("USERS_COLLECTION")
//           .doc(IdOfChatroomVol)
//           .collection("CHATROOMS_COLLECTION")
//           .doc().
//         get();
//
//         print("OOOOOOOOOOOOOOHHHHHHHHHELP");
//         print(variable);
//
//     });
//   }
//   final TextEditingController message = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     print("HHHHHHHHHJJJJJJJJJJJJJKKKKKKKKKKKKSSSSSSSSSSSK");
//     print(firstMessage);
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           controllerTabBottomVol = PersistentTabController(initialIndex: 0);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreen()));
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: background,
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               //     firstMessage?
//               // Container(
//               //       height: MediaQuery.of(context).size.height * 0.91,)
//               //     :
//               SizedBox(
//
//                 height: MediaQuery.of(context).size.height * 0.9,
//                 child:
//
//                 MessagesVolFirst(
//                   name: currentName,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 0),
//                 child: SizedBox(
//                   // color: background,
//                   height: MediaQuery.of(context).size.height * 0.1,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: padding,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 5),
//                               child: TextFormField(
//                                 controller: message,
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   hintText: 'Message',
//                                   enabled: true,
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 14.0, bottom: 8.0, top: 8.0),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide:
//                                     new BorderSide(color: blueColor),
//                                     borderRadius: new BorderRadius.circular(15),
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                     new BorderSide(color: blueColor),
//                                     borderRadius: new BorderRadius.circular(15),
//                                   ),
//                                 ),
//                                 validator: (value) {},
//                                 onSaved: (value) {
//                                   message.text = value!;
//                                 },
//                               ),
//                             ),
//                           ),
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundColor: blueColor,
//                             child: IconButton(
//                               onPressed: () async {
//                                 // /messages_Vol(name: current_name_Vol,);
//                                 setState(() {
//                                   firstMessage = false;
//                                   // Navigator.of(context, rootNavigator: true).pushReplacement(
//                                   //     MaterialPageRoute(builder: (context) => new MessagesVol(name: currentName)));
//                                 });
//                                 if (message.text.isNotEmpty) {
//
//                                   writeMessages();
//
//                                   await Future.delayed(
//                                       Duration(milliseconds: 500), (){
//                                     SchedulerBinding.instance
//                                         ?.addPostFrameCallback((_) {
//                                       print("AAAAAAAAAAA__________________works");
//                                       scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
//                                       // duration: Duration(milliseconds: 400),
//                                       // curve: Curves.fastOutSlowIn);
//                                     });
//                                     message.clear();
//                                   });
//
//                                 }
//                               },
//                               icon: Icon(
//                                 Icons.send_sharp,
//                                 color: background,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:wol_pro_1/to_delete/pageWithChats.dart';
// import 'package:wol_pro_1/app.dart';
// import 'package:wol_pro_1/constants.dart';
// import 'package:wol_pro_1/screens/menu/volunteer/messages/messagesVol.dart';
// import 'package:wol_pro_1/screens/menu/volunteer/my_applications/settings_of_application.dart';
//
// import '../home_page/home_vol.dart';
// import '../main_screen.dart';
// import 'pageWithChatsVol.dart';
//
// ScrollController _scrollControllerVol_ = ScrollController();
//
// String color = "blue";
//
// class MessagesVolFirst extends StatefulWidget {
//   //
//   String? name;
//
//   MessagesVolFirst({required this.name});
//
//   @override
//   _MessagesVolFirstState createState() => _MessagesVolFirstState(name: name);
// }
//
// bool loading = true;
//
// double myMessageLeftVol(String name_receiver) {
//   if (name_receiver == currentNameVol) {
//     return 40;
//   } else {
//     return 5;
//   }
// }
//
// double myMessageRightVol(String name_receiver) {
//   if (name_receiver == currentNameVol) {
//     return 5;
//   } else {
//     return 40;
//   }
// }
//
// class _MessagesVolFirstState extends State<MessagesVolFirst> {
//   String? name;
//
//   _MessagesVolFirstState({required this.name});
//
//   //
//   // Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
//   //     .collection('Messages')
//   //     // .where("id_of_adressee", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//   //     .orderBy('time')
//   //     .snapshots();
//   @override
//   Widget build(BuildContext context) {
//     // return isLoading() ? Loading() :StreamBuilder(
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           controllerTabBottomVol = PersistentTabController(initialIndex: 0);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreen()));
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//           floatingActionButton: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               size: 30,
//               color: blueColor,
//             ),
//             onPressed: () {
//               setState(() {
//                 controllerTabBottomVol = PersistentTabController(initialIndex: 0);
//               });
//               Navigator.of(context, rootNavigator: true).pushReplacement(
//                   MaterialPageRoute(builder: (context) => MainScreen()));
//             },
//           ),
//           backgroundColor: background,
//           body: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.02),
//                 child: Align(
//                   alignment: Alignment.topCenter,
//                   child: Text(
//                     ("Messages"),
//                     style: GoogleFonts.raleway(
//                       fontSize: 18,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               firstMessage
//                   ? Container()
//                   : Padding(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.05),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.75,
//                   child: StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection("USERS_COLLECTION")
//                         .doc(IdOfChatroomVol)
//                         .collection("CHATROOMS_COLLECTION")
//                         .orderBy('time')
//                         .snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       print(
//                           "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs");
//                       print(FirebaseAuth.instance.currentUser?.uid);
//
//                       if (snapshot.hasError) {
//                         return Text("Something is wrong");
//                       }
//                       if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 0),
//                         child: ListView.builder(
//                           controller: _scrollControllerVol_,
//                           itemCount: snapshot.data!.docs.length,
//                           // physics: NeverScrollableScrollPhysics(),
//
//                           // physics: ScrollPhysics(),
//                           shrinkWrap: true,
//                           // primary: true,
//                           itemBuilder: (_, index) {
//                             QueryDocumentSnapshot qs =
//                             snapshot.data!.docs[index];
//                             Timestamp t = qs['time'];
//                             DateTime d = t.toDate();
//                             print(d.toString());
//                             final dataKey = GlobalKey();
//                             return Padding(
//                               padding: EdgeInsets.only(
//                                   top: 8,
//                                   bottom: 8,
//                                   left: myMessageLeftVol(
//                                       snapshot.data?.docs[index]["name"]),
//                                   right: myMessageRightVol(snapshot
//                                       .data?.docs[index]["name"])),
//                               child: Column(
//                                 // crossAxisAlignment: name == qs['name']
//                                 //     ? CrossAxisAlignment.end
//                                 //     : CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     decoration: new BoxDecoration(
//                                         color: snapshot.data?.docs[index]
//                                         ["name"] ==
//                                             currentNameVol
//                                             ? Colors.white
//                                             : blueColor,
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10))),
//                                     // width: 300,
//
//                                     child: ListTile(
//                                       key: dataKey,
//                                       // shape: RoundedRectangleBorder(
//                                       //   side: BorderSide(
//                                       //     color: snapshot.data?.docs[index]["name"] == current_name_Vol ? Colors.blue:Colors.purple,
//                                       //   ),
//                                       //   borderRadius: BorderRadius.circular(10),
//                                       // ),
//                                       title: Text(
//                                         qs['name'],
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       subtitle: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment
//                                             .spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: 200,
//                                             child: Text(
//                                               qs['message'],
//                                               softWrap: true,
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             d.hour.toString() +
//                                                 ":" +
//                                                 d.minute.toString(),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SelectedChatroomVolFirst extends StatefulWidget {
//   const SelectedChatroomVolFirst({Key? key}) : super(key: key);
//
//   @override
//   State<SelectedChatroomVolFirst> createState() => _SelectedChatroomVolFirstState();
// }
//
// // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
// class _SelectedChatroomVolFirstState extends State<SelectedChatroomVolFirst> {
//   // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
//
//   writeMessages() {
//     FirebaseFirestore.instance
//         .collection("USERS_COLLECTION")
//         .doc(IdOfChatroomVol)
//         .collection("CHATROOMS_COLLECTION")
//         .doc()
//         .set({
//       'message': message.text.trim(),
//       'time': DateTime.now(),
//       'name': currentNameVol,
//       'id_message': "null"
//     });
//   }
//
//   final TextEditingController message = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     print("HHHHHHHHHJJJJJJJJJJJJJKKKKKKKKKKKKSSSSSSSSSSSK");
//     print(firstMessage);
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           controllerTabBottomVol = PersistentTabController(initialIndex: 0);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreen()));
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: background,
//         resizeToAvoidBottomInset: true,
//         floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//         floatingActionButton: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 30,
//             color: blueColor,
//           ),
//           onPressed: () {
//             setState(() {
//               controllerTabBottomVol = PersistentTabController(initialIndex: 0);
//             });
//             Navigator.of(context, rootNavigator: true).pushReplacement(
//                 MaterialPageRoute(builder: (context) => MainScreen()));
//           },
//         ),
//         // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//         // floatingActionButton: IconButton(
//         //   icon: Icon(
//         //     Icons.arrow_back_ios_new_rounded,
//         //     size: 30,
//         //     color: blueColor,
//         //   ),
//         //   onPressed: () {
//         //     setState(() {
//         //       controllerTabBottom = PersistentTabController(initialIndex: 1);
//         //     });
//         //     Navigator.of(context, rootNavigator: true).pushReplacement(
//         //         MaterialPageRoute(builder: (context) => MainScreen()));
//         //
//         //   },
//         // ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             // crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               //     firstMessage?
//               Container(
//                     height: MediaQuery.of(context).size.height * 0.91,),
//               //     :
//               // Container(
//               //   height: MediaQuery.of(context).size.height * 0.91,
//               //   child: MessagesVolFirst(
//               //     name: currentName,
//               //   ),
//               // ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 0),
//                 child: Container(
//                   color: background,
//                   height: 60,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: padding,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 5),
//                               child: TextFormField(
//                                 controller: message,
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   hintText: 'Message',
//                                   enabled: true,
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 14.0, bottom: 8.0, top: 8.0),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide:
//                                     new BorderSide(color: blueColor),
//                                     borderRadius: new BorderRadius.circular(15),
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                     new BorderSide(color: blueColor),
//                                     borderRadius: new BorderRadius.circular(15),
//                                   ),
//                                 ),
//                                 validator: (value) {},
//                                 onSaved: (value) {
//                                   message.text = value!;
//                                 },
//                               ),
//                             ),
//                           ),
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundColor: blueColor,
//                             child: IconButton(
//                               onPressed: () async {
//                                 // /messages_Vol(name: current_name_Vol,);
//                                 // setState(() {
//                                 //   // firstMessage = false;
//                                 //   // Navigator.of(context, rootNavigator: true).pushReplacement(
//                                 //   //     MaterialPageRoute(builder: (context) => new MessagesVol(name: currentName)));
//                                 // });
//                                 if (message.text.isNotEmpty) {
//
//
//                                   //
//                                   // print("Fiiiiiirst meeeeeesssaaaaggge");
//                                   // await Future.delayed(
//                                   //     Duration(milliseconds: 500), (){
//                                   //   SchedulerBinding.instance
//                                   //       ?.addPostFrameCallback((_) {
//                                   //     print("AAAAAAAAAAA__________________works");
//                                   //     _scrollControllerVol_.jumpTo(
//                                   //         _scrollControllerVol_
//                                   //             .positions.last.maxScrollExtent);
//                                   //
//                                   //     // duration: Duration(milliseconds: 400),
//                                   //     // curve: Curves.fastOutSlowIn);
//                                   //   });
//                                   //
//                                   //   message.clear();
//                                     setState(() {
//                                       writeMessages();
//
//                                     });
//                                     Future.delayed(
//                                             Duration(milliseconds: 500), (){
//                                     Navigator.of(context, rootNavigator: true).pushReplacement(
//                                         MaterialPageRoute(builder: (context) => new SelectedChatroomVol()));
//     });
//                                   // });
//
//                                 }
//                               },
//                               icon: Icon(
//                                 Icons.send_sharp,
//                                 color: background,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }