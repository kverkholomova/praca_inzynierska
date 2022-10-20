import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:wol_pro_1/Refugee/authenticate/register_refugee_1.dart';
import 'package:wol_pro_1/Refugee/home/home_ref.dart';
import 'package:wol_pro_1/shared/constants.dart';

import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../../screens/intro_screen/option.dart';


//
// String firstCategory='';
// String secondCategory='';
// String thirdCategory='';

class RegisterRef extends StatefulWidget {



  @override
  _RegisterRefState createState() => _RegisterRefState();
}

class _RegisterRefState extends State<RegisterRef> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  // void arguments(){
  //   if(chosen_category.length==1) {
  //     firstCategory = chosen_category[0];
  //   }
  //   if(chosen_category.length==2) {
  //     firstCategory = chosen_category[0];
  //     secondCategory = chosen_category[1];
  //   }
  //   if(chosen_category.length==3) {
  //     firstCategory = chosen_category[0];
  //     secondCategory = chosen_category[1];
  //     thirdCategory = chosen_category[2];
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OptionChoose()),
        );
        return true;
      },
      child: loading ? Loading() :Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          elevation: 0.0,
          title: Text('Sign up',style: TextStyle(fontSize: 16),),
          leading: IconButton(icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OptionChoose()),
              );
            },),
          actions: <Widget>[
            // TextButton.icon(
            //   icon: Icon(Icons.person,color: Colors.white,),
            //   label: Text('Sign In',style: TextStyle(color: Colors.white),),
            //   onPressed: () => widget.toggleView(),
            // ),
          ],
        ),
        body: Container(
          color: Color.fromRGBO(234, 191, 213, 0.8),
          padding: EdgeInsets.symmetric( horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                  ),
                ),
                // Padding(


                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Container(
                    height: 55,
                    width: 275,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: MaterialButton(
                        color: Color.fromRGBO(49, 72, 103, 0.8),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          // FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update(
                          //     {"user_name": user_name});
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomeRef()));

                          if(_formKey.currentState!.validate()){
                            setState(() => loading = true);
                            dynamic result = await _auth.registerWithEmailAndPasswordRef(email, password, user_name_ref, phone_number_ref);
                            if(result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please supply a valid data';
                              });
                            }
                          }
                        }
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:wol_pro_1/screens/option.dart';
// import 'package:wol_pro_1/shared/constants.dart';
//
// import '../../../services/auth.dart';
// import '../../../shared/loading.dart';
//
//
//
// class RegisterRef extends StatefulWidget {
//
//   // final Function toggleView;
//   // RegisterRef({ required this.toggleView });
//
//   @override
//   _RegisterRefState createState() => _RegisterRefState();
// }
//
// class _RegisterRefState extends State<RegisterRef> {
//
//   final AuthService _auth = AuthService();
//   final _formKey = GlobalKey<FormState>();
//   String error = '';
//   bool loading = false;
//
//   // text field state
//   String email = '';
//   String password = '';
//
//
//   @override
//   Widget build(BuildContext context) {
//     return loading ? Loading() : Scaffold(
//       resizeToAvoidBottomInset: false,
//
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//         elevation: 0.0,
//         title: Text('Sign up',style: TextStyle(fontSize: 16),),
//         leading: IconButton(icon: const Icon(Icons.arrow_back),
//           onPressed: (){
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => OptionChoose()),
//             );
//           },),
//         actions: <Widget>[
//           // FlatButton.icon(
//           //   icon: Icon(Icons.person,color: Colors.white,),
//           //   label: Text('Sign In',style: TextStyle(color: Colors.white),),
//           //   onPressed: () => widget.toggleView(),
//           // ),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 20.0),
//               TextFormField(
//                 decoration: textInputDecoration.copyWith(hintText: 'Email'),
//                 validator: (val) => val!.isEmpty ? 'Enter an email' : null,
//                 onChanged: (val) {
//                   setState(() => email = val);
//                 },
//               ),
//               SizedBox(height: 20.0),
//               TextFormField(
//                 decoration: textInputDecoration.copyWith(hintText: 'Password'),
//                 obscureText: true,
//                 validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
//                 onChanged: (val) {
//                   setState(() => password = val);
//                 },
//               ),
//               SizedBox(height: 20.0),
//
//               RaisedButton(
//                   color: Colors.pink[400],
//                   child: Text(
//                     'Register',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () async {
//
//                     option_refugee=true;
//                     if(_formKey.currentState!.validate()){
//                       setState(() => loading = true);
//                       dynamic result = await _auth.registerWithEmailAndPasswordRef(email, password);
//                       if(result == null) {
//                         setState(() {
//                           loading = false;
//                           error = 'Please supply a valid email';
//                         });
//                       }
//                     }
//                   }
//               ),
//               SizedBox(height: 12.0),
//               Text(
//                 error,
//                 style: TextStyle(color: Colors.red, fontSize: 14.0),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }