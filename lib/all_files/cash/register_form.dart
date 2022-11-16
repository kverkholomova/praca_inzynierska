// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animated_button/flutter_animated_button.dart';
//
// import 'package:wol_pro_1/screens/option.dart';
//
// import '../shared/create_application.dart';
// import '../volunteer/applications/screen_with_applications.dart';
// import '../volunteer/authenticate/register_volunteer_1.dart';
//
//
//
//
// String firstCategory='';
// String secondCategory='';
// String thirdCategory='';
//
//
//
// class VolunteerRegisterForm extends StatefulWidget {
//   const VolunteerRegisterForm({Key? key}) : super(key: key);
//
//   @override
//   State<VolunteerRegisterForm> createState() => _VolunteerRegisterFormState();
// }
//
// class _VolunteerRegisterFormState extends State<VolunteerRegisterForm> {
//
//   var ID;
//   void arguments(){
//     if(chosen_category.length==1) {
//       firstCategory = chosen_category[0];
//     }
//     if(chosen_category.length==2) {
//       firstCategory = chosen_category[0];
//       secondCategory = chosen_category[1];
//     }
//     if(chosen_category.length==3) {
//       firstCategory = chosen_category[0];
//       secondCategory = chosen_category[1];
//       thirdCategory = chosen_category[2];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OptionChoose()),
//         );
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back,color: Colors.white,),
//             onPressed: () async {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => OptionChoose()));
//
//             },
//           ),
//         ),
//         body: Container(
//           color: Color.fromRGBO(234, 191, 213, 0.8),
//           height: double.infinity,
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Text("Choose categories which are the best suitable for you", style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(3.0),
//                     child: AnimatedButton(
//                       selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
//                       height: 40,
//                       width: 120,
//                       text: 'Transfer',
//
//                       textStyle: TextStyle(color: Colors.black,fontSize: 18),
//                       isReverse: true,
//                       selectedTextColor: Colors.white,
//                       transitionType: TransitionType.LEFT_TO_RIGHT,
//                       backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
//                       borderColor: Colors.white,
//                       borderRadius: 50,
//                       borderWidth: 1,
//
//                       onPress: () {
//                       if(!chosen_category.contains('Transfer')){
//                         chosen_category.add('Transfer');
//                         print(chosen_category);
//
//                       } else if(chosen_category.contains("Transfer")){
//                         chosen_category.remove('Transfer');
//                         print("Empty: $chosen_category");
//                       }
//
//                       //volunteer_preferencies.add('Transfer');
//                     },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(3.0),
//                     child: AnimatedButton(
//                       selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
//                       height: 40,
//                       width: 160,
//                       text: 'Accomodation',
//
//                       textStyle: TextStyle(color: Colors.black,fontSize: 18),
//                       isReverse: true,
//                       selectedTextColor: Colors.white,
//                       transitionType: TransitionType.LEFT_TO_RIGHT,
//                       backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
//                       borderColor: Colors.white,
//                       borderRadius: 50,
//                       borderWidth: 1, onPress: () {
//                       if(!chosen_category.contains('Accomodation')){
//                         chosen_category.add('Accomodation');
//                         print(chosen_category);
//
//                       } else if(chosen_category.contains('Accomodation')){
//                         chosen_category.remove('Accomodation');
//                         print("Empty: $chosen_category");
//                       }
//
//                       //volunteer_preferencies.add('Transfer');
//                     },
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(3.0),
//                 child: AnimatedButton(
//                   selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
//                   height: 40,
//                   width: 240,
//                   text: 'Assistance with animals',
//
//                   textStyle: TextStyle(color: Colors.black,fontSize: 18),
//                   isReverse: true,
//                   selectedTextColor: Colors.white,
//                   transitionType: TransitionType.LEFT_TO_RIGHT,
//                   backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
//                   borderColor: Colors.white,
//                   borderRadius: 50,
//                   borderWidth: 1, onPress: () {
//                   if(!chosen_category.contains('Assistance with animals')){
//                     chosen_category.add('Assistance with animals');
//                     print(chosen_category);
//
//                   } else if(chosen_category.contains('Assistance with animals')){
//                     chosen_category.remove('Assistance with animals');
//                     print("Empty: $chosen_category");
//                   }
//
//                   //volunteer_preferencies.add('Transfer');
//                 },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 300),
//                 child: Container(
//                   height: 55,
//                   width: 275,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20)
//                   ),
//                   child: MaterialButton(
//                       color: Color.fromRGBO(94, 167, 187, 0.8),
//                       child: Text(
//                         'Finish',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: (){
//                         Navigator.push(context,
//                                   MaterialPageRoute(builder: (context) => Categories()));
//
//
//                       },
//                       // onPressed: () {
//                       //   Navigator.push(context,
//                       //       MaterialPageRoute(builder: (context) => Categories()));
//                       // }
//                   ),
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
