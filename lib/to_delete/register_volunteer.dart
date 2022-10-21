// import 'package:flutter/material.dart';
// import 'package:wol_pro_1/shared/constants.dart';
// import 'package:wol_pro_1/volunteer/home/settings_home_vol.dart';
//
// import '../../../services/auth.dart';
// import '../../../shared/loading.dart';
// import '../../intro_screen/option.dart';
//
// class RegisterVol extends StatefulWidget {
//
//   @override
//   _RegisterVolState createState() => _RegisterVolState();
// }
//
// class _RegisterVolState extends State<RegisterVol> {
//
//   final AuthService _auth_vol = AuthService();
//   final _formKey = GlobalKey<FormState>();
//   String error = '';
//   bool loading = false;
//
//   // text field state
//   String email = '';
//   String password = '';
//
//   // void arguments(){
//   //   if(chosen_category.length==1) {
//   //     firstCategory = chosen_category[0];
//   //   }
//   //   if(chosen_category.length==2) {
//   //     firstCategory = chosen_category[0];
//   //     secondCategory = chosen_category[1];
//   //   }
//   //   if(chosen_category.length==3) {
//   //     firstCategory = chosen_category[0];
//   //     secondCategory = chosen_category[1];
//   //     thirdCategory = chosen_category[2];
//   //   }
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return loading ? Loading() : WillPopScope(
//       onWillPop: () async {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OptionChoose()),
//         );
//         return true;
//       },
//       child: loading ? Loading() :Scaffold(
//         resizeToAvoidBottomInset: false,
//
//         appBar: AppBar(
//           backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//           elevation: 0.0,
//           title: Text('Sign up',style: TextStyle(fontSize: 16),),
//           leading: IconButton(icon: const Icon(Icons.arrow_back),
//           onPressed: (){
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => OptionChoose()),
//             );
//           },),
//           actions: <Widget>[
//             // TextButton.icon(
//             //   icon: Icon(Icons.person,color: Colors.white,),
//             //   label: Text('Sign In',style: TextStyle(color: Colors.white),),
//             //   onPressed: () => widget.toggleView(),
//             // ),
//           ],
//         ),
//         body: Container(
//           color: Color.fromRGBO(234, 191, 213, 0.8),
//           padding: EdgeInsets.symmetric( horizontal: 20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: <Widget>[
//
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: SizedBox(
//                     height: 55,
//                     child: TextFormField(
//                       decoration: textInputDecoration.copyWith(hintText: 'Email'),
//                       validator: (val) => val!.isEmpty ? 'Enter an email' : null,
//                       onChanged: (val) {
//                         setState(() => email = val);
//                       },
//                     ),
//                   ),
//                 ),
//
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: SizedBox(
//                     height: 55,
//                     child: TextFormField(
//                       decoration: textInputDecoration.copyWith(hintText: 'Password'),
//                       obscureText: true,
//                       validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
//                       onChanged: (val) {
//                         setState(() => password = val);
//                       },
//                     ),
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(15.0),
//                 //   child: Text("Choose categories which are the best suitable for you", style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
//                 // ),
//                 // Row(
//                 //   children: [
//                 //     Padding(
//                 //       padding: const EdgeInsets.all(3.0),
//                 //       child: AnimatedButton(
//                 //         selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
//                 //         height: 30,
//                 //         width: 100,
//                 //         text: 'Transfer',
//                 //
//                 //         textStyle: TextStyle(color: Colors.black,fontSize: 18),
//                 //         isReverse: true,
//                 //         selectedTextColor: Colors.white,
//                 //         transitionType: TransitionType.LEFT_TO_RIGHT,
//                 //         backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
//                 //         borderColor: Colors.white,
//                 //         borderRadius: 50,
//                 //         borderWidth: 1,
//                 //
//                 //         onPress: () {
//                 //           if(!chosen_category.contains('Transfer')){
//                 //             chosen_category.add('Transfer');
//                 //             print(chosen_category);
//                 //
//                 //           } else if(chosen_category.contains("Transfer")){
//                 //             chosen_category.remove('Transfer');
//                 //             print("Empty: $chosen_category");
//                 //           }
//                 //
//                 //           //volunteer_preferencies.add('Transfer');
//                 //         },
//                 //       ),
//                 //     ),
//                 //     Padding(
//                 //       padding: const EdgeInsets.all(3.0),
//                 //       child: AnimatedButton(
//                 //         selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
//                 //         height: 30,
//                 //         width: 150,
//                 //         text: 'Accomodation',
//                 //
//                 //         textStyle: TextStyle(color: Colors.black,fontSize: 18),
//                 //         isReverse: true,
//                 //         selectedTextColor: Colors.white,
//                 //         transitionType: TransitionType.LEFT_TO_RIGHT,
//                 //         backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
//                 //         borderColor: Colors.white,
//                 //         borderRadius: 50,
//                 //         borderWidth: 1, onPress: () {
//                 //         if(!chosen_category.contains('Accomodation')){
//                 //           chosen_category.add('Accomodation');
//                 //           print(chosen_category);
//                 //
//                 //         } else if(chosen_category.contains('Accomodation')){
//                 //           chosen_category.remove('Accomodation');
//                 //           print("Empty: $chosen_category");
//                 //         }
//                 //
//                 //         //volunteer_preferencies.add('Transfer');
//                 //       },
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(3.0),
//                 //   child: AnimatedButton(
//                 //     selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
//                 //     height: 30,
//                 //     width: 240,
//                 //     text: 'Assistance with animals',
//                 //
//                 //     textStyle: TextStyle(color: Colors.black,fontSize: 18),
//                 //     isReverse: true,
//                 //     selectedTextColor: Colors.white,
//                 //     transitionType: TransitionType.LEFT_TO_RIGHT,
//                 //     backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
//                 //     borderColor: Colors.white,
//                 //     borderRadius: 50,
//                 //     borderWidth: 1, onPress: () {
//                 //     if(!chosen_category.contains('Assistance with animals')){
//                 //       chosen_category.add('Assistance with animals');
//                 //       print(chosen_category);
//                 //
//                 //     } else if(chosen_category.contains('Assistance with animals')){
//                 //       chosen_category.remove('Assistance with animals');
//                 //       print("Empty: $chosen_category");
//                 //     }
//                 //
//                 //     //volunteer_preferencies.add('Transfer');
//                 //   },
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 200),
//                 //   child: Container(
//                 //     height: 55,
//                 //     width: 275,
//                 //     decoration: BoxDecoration(
//                 //         borderRadius: BorderRadius.circular(20)
//                 //     ),
//                 //     child: MaterialButton(
//                 //       color: Color.fromRGBO(94, 167, 187, 0.8),
//                 //       child: Text(
//                 //         'Finish',
//                 //         style: TextStyle(color: Colors.white),
//                 //       ),
//                 //       onPressed: (){
//                 //         Navigator.push(context,
//                 //             MaterialPageRoute(builder: (context) => Categories()));
//                 //
//                 //
//                 //       },
//                 //       // onPressed: () {
//                 //       //   Navigator.push(context,
//                 //       //       MaterialPageRoute(builder: (context) => Categories()));
//                 //       // }
//                 //     ),
//                 //   ),
//                 // ),
//
//
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: Container(
//                     height: 55,
//                     width: 275,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20)
//                     ),
//                     child: MaterialButton(
//                         color: Color.fromRGBO(49, 72, 103, 0.8),
//                         child: Text(
//                           'Register',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onPressed: () async {
//
//
//                           if(_formKey.currentState!.validate()){
//                             setState(() => loading = true);
//                             dynamic result = await _auth_vol.registerWithEmailAndPasswordVol(email, password);
//                             if(result == null) {
//                               setState(() {
//                                 loading = false;
//                                 error = 'Please supply a valid data';
//                               });
//                             }
//                           }
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) => SettingsHomeVol()));
//                         }
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12.0),
//                 Text(
//                   error,
//                   style: TextStyle(color: Colors.red, fontSize: 14.0),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }