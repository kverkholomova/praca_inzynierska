import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:wol_pro_1/volunteer/home/settings_home_vol.dart';
import 'package:wol_pro_1/volunteer/your_app_vol.dart';
import '../../service/local_push_notifications.dart';

import 'new_screen_with_applications.dart';


String current_name_Vol = '';
List<String> chosen_category_settings = [];
String? token_vol;
final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class SettingsVol extends StatefulWidget {
  const SettingsVol({Key? key}) : super(key: key);

  @override
  State<SettingsVol> createState() => _SettingsVolState();
}


class _SettingsVolState extends State<SettingsVol> {

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("------???---------RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    print(token);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
    print(
        "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    print(token);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {});
    storeNotificationToken();
    FirebaseMessaging.instance.subscribeToTopic('subscription');
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        elevation: 0.0,
        title: Text('Users Info',style: TextStyle(fontSize: 16),),

      ),
      body: Container(
        color: Color.fromRGBO(234, 191, 213, 0.8),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id_vol', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),

          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            return ListView.builder(
                itemCount: streamSnapshot.data?.docs.length,
                itemBuilder: (ctx, index) {
                  // categories_user = streamSnapshot.data?.docs[index]['category'];
                  token_vol = streamSnapshot.data?.docs[index]['token'];
                  current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          streamSnapshot.data?.docs[index]['user_name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black,),textAlign: TextAlign.center,
                        ),

                      ),

                      Text(
                        streamSnapshot.data?.docs[index]['phone_number'],
                        style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Choose categories which are the best suitable for you",
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AnimatedButton(
                                  selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                                  height: 30,
                                  width: 100,
                                  text: 'Transfer',

                                  textStyle: TextStyle(color: Colors.black, fontSize: 18),
                                  isReverse: true,
                                  selectedTextColor: Colors.white,
                                  transitionType: TransitionType.LEFT_TO_RIGHT,
                                  backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                                  borderColor: Colors.white,
                                  borderRadius: 50,
                                  borderWidth: 1,

                                  onPress: () {
                                    print("KKKKKKKKKKKKKKKKKKKKKKK_______________KKKKKKKKKKKKKKK");
                                    print(chosen_category_settings);
                                    if (!chosen_category_settings.contains('Transfer')) {
                                      chosen_category_settings.add('Transfer');
                                      print(chosen_category_settings);
                                    } else if (chosen_category_settings.contains("Transfer")) {
                                      chosen_category_settings.remove('Transfer');
                                      print("Empty: $chosen_category_settings");
                                    }

                                    //volunteer_preferencies.add('Transfer');
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AnimatedButton(
                                  selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                                  height: 30,
                                  width: 150,
                                  text: 'Accomodation',

                                  textStyle: TextStyle(color: Colors.black, fontSize: 18),
                                  isReverse: true,
                                  selectedTextColor: Colors.white,
                                  transitionType: TransitionType.LEFT_TO_RIGHT,
                                  backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                                  borderColor: Colors.white,
                                  borderRadius: 50,
                                  borderWidth: 1,
                                  onPress: () {
                                    print("KKKKKKKKKKKKKKKKKKKKKKK_______________KKKKKKKKKKKKKKK");
                                    print(chosen_category_settings);
                                    if (!chosen_category_settings.contains('Accomodation')) {
                                      chosen_category_settings.add('Accomodation');
                                      print(chosen_category_settings);
                                    } else if (chosen_category_settings.contains('Accomodation')) {
                                      chosen_category_settings.remove('Accomodation');
                                      print("Empty: $chosen_category_settings");
                                    }

                                    //volunteer_preferencies.add('Transfer');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AnimatedButton(
                          selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                          height: 30,
                          width: 240,
                          text: 'Assistance with animals',

                          textStyle: TextStyle(color: Colors.black, fontSize: 18),
                          isReverse: true,
                          selectedTextColor: Colors.white,
                          transitionType: TransitionType.LEFT_TO_RIGHT,
                          backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                          borderColor: Colors.white,
                          borderRadius: 50,
                          borderWidth: 1,
                          onPress: () {
                            print("KKKKKKKKKKKKKKKKKKKKKKK_______________KKKKKKKKKKKKKKK");
                            print(chosen_category_settings);
                            if (!chosen_category_settings.contains(
                                'Assistance with animals')) {
                              chosen_category_settings.add('Assistance with animals');
                              print(chosen_category_settings);
                            } else
                            if (chosen_category_settings.contains('Assistance with animals')) {
                              chosen_category_settings.remove('Assistance with animals');
                              print("Empty: $chosen_category_settings");
                            }

                            //volunteer_preferencies.add('Transfer');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AnimatedButton(
                                  selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                                  height: 30,
                                  width: 100,
                                  text: 'Clothes',

                                  textStyle: TextStyle(color: Colors.black, fontSize: 18),
                                  isReverse: true,
                                  selectedTextColor: Colors.white,
                                  transitionType: TransitionType.LEFT_TO_RIGHT,
                                  backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                                  borderColor: Colors.white,
                                  borderRadius: 50,
                                  borderWidth: 1,

                                  onPress: () {
                                    print("KKKKKKKKKKKKKKKKKKKKKKK_______________KKKKKKKKKKKKKKK");
                                    print(chosen_category_settings);
                                    if (!chosen_category_settings.contains('Clothes')) {
                                      chosen_category_settings.add('Clothes');
                                      print(chosen_category_settings);
                                    } else if (chosen_category_settings.contains("Clothes")) {
                                      chosen_category_settings.remove('Clothes');
                                      print("Empty: $chosen_category_settings");
                                    }

                                    //volunteer_preferencies.add('Transfer');
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AnimatedButton(
                                  selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                                  height: 30,
                                  width: 150,
                                  text: 'Free lawyer',

                                  textStyle: TextStyle(color: Colors.black, fontSize: 18),
                                  isReverse: true,
                                  selectedTextColor: Colors.white,
                                  transitionType: TransitionType.LEFT_TO_RIGHT,
                                  backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                                  borderColor: Colors.white,
                                  borderRadius: 50,
                                  borderWidth: 1,
                                  onPress: () {
                                    print("KKKKKKKKKKKKKKKKKKKKKKK_______________KKKKKKKKKKKKKKK");
                                    print(chosen_category_settings);
                                    if (!chosen_category_settings.contains('Free lawyer')) {
                                      chosen_category_settings.add('Free lawyer');
                                      print(chosen_category_settings);
                                    } else if (chosen_category_settings.contains('Free lawyer')) {
                                      chosen_category_settings.remove('Free lawyer');
                                      print("Empty: $chosen_category_settings");
                                    }

                                    //volunteer_preferencies.add('Transfer');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AnimatedButton(
                          selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                          height: 30,
                          width: 240,
                          text: 'Assistance with children',

                          textStyle: TextStyle(color: Colors.black, fontSize: 18),
                          isReverse: true,
                          selectedTextColor: Colors.white,
                          transitionType: TransitionType.LEFT_TO_RIGHT,
                          backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                          borderColor: Colors.white,
                          borderRadius: 50,
                          borderWidth: 1,
                          onPress: () {
                            print("KKKKKKKKKKKKKKKKKKKKKKK_______________KKKKKKKKKKKKKKK");
                            print(chosen_category_settings);
                            if (!chosen_category_settings.contains(
                                'Assistance with children')) {
                              chosen_category_settings.add('Assistance with children');
                              print(chosen_category_settings);
                            } else
                            if (chosen_category_settings.contains('Assistance with children')) {
                              chosen_category_settings.remove('Assistance with children');
                              print("Empty: $chosen_category_settings");
                            }

                            //volunteer_preferencies.add('Transfer');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AnimatedButton(
                          selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                          height: 30,
                          width: 240,
                          text: 'Medical assistance',

                          textStyle: TextStyle(color: Colors.black, fontSize: 18),
                          isReverse: true,
                          selectedTextColor: Colors.white,
                          transitionType: TransitionType.LEFT_TO_RIGHT,
                          backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                          borderColor: Colors.white,
                          borderRadius: 50,
                          borderWidth: 1,
                          onPress: () {
                            print("KKKKKKKKKKKKKKKKKKKKKKK_______________KKKKKKKKKKKKKKK");
                            print(chosen_category_settings);
                            if (!chosen_category_settings.contains(
                                'Medical assistance')) {
                              chosen_category_settings.add('Medical assistance');
                              print(chosen_category_settings);
                            } else
                            if (chosen_category_settings.contains('Medical assistance')) {
                              chosen_category_settings.remove('Medical assistance');
                              print("Empty: $chosen_category_settings");
                            }

                            //volunteer_preferencies.add('Transfer');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AnimatedButton(
                          selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                          height: 30,
                          width: 240,
                          text: 'Other',

                          textStyle: TextStyle(color: Colors.black, fontSize: 18),
                          isReverse: true,
                          selectedTextColor: Colors.white,
                          transitionType: TransitionType.LEFT_TO_RIGHT,
                          backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                          borderColor: Colors.white,
                          borderRadius: 50,
                          borderWidth: 1,
                          onPress: () {
                            print("KKKKKKKKKKKKKKKKKKKKKKK_______________KKKKKKKKKKKKKKK");
                            print(chosen_category_settings);
                            if (!chosen_category_settings.contains(
                                'Other')) {
                              chosen_category_settings.add('Other');
                              print(chosen_category_settings);
                            } else
                            if (chosen_category_settings.contains('Other')) {
                              chosen_category_settings.remove('Other');
                              print("Empty: $chosen_category_settings");
                            }

                            //volunteer_preferencies.add('Transfer');
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: MaterialButton(
                              color: const Color.fromRGBO(137, 102, 120, 0.8),
                              child: const Text('Done'),
                              onPressed: () {

                                FirebaseFirestore.instance.collection("users")
                                .doc(FirebaseAuth.instance.currentUser?.uid).update(
                                    {"category": chosen_category_settings});
                                // print(categories_user);
                                // categories_user = streamSnapshot.data?.docs[index]['category'];
                                // print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO__________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
                                // print(categories_user);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Categories()));

                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Confirm changes'),
                                  content: const Text('Are you sure that you want to change your settings?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsHomeVol()));
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // categories_user= [];
                                        categories_user_Register = chosen_category_settings;
                                        print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO__________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
                                        // print(categories_user);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => YourCategories()));
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),);

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
      ),

    );
  }
}