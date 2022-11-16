// import 'package:flutter/material.dart';
// import 'package:wol_pro_1/screens/intro_screen/option.dart';
// import 'package:wol_pro_1/services/auth.dart';
// import 'package:wol_pro_1/shared/loading.dart';
//
// import '../../../shared/constants.dart';
//
// class SignInRef extends StatefulWidget {
//
//   final Function toggleView;
//   SignInRef({ required this.toggleView });
//
//   @override
//   _SignInRefState createState() => _SignInRefState();
// }
//
// class _SignInRefState extends State<SignInRef> {
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
//       // backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//         elevation: 0.0,
//         title: const Text('Sign in'),
//         actions: <Widget>[
//           ElevatedButton.icon(
//             icon: const Icon(Icons.person),
//             label: const Text('Register'),
//             onPressed: () => widget.toggleView(),
//           ),
//         ],
//       ),
//       body: Container(
//         color: Color.fromRGBO(234, 191, 213, 0.8),
//         padding: EdgeInsets.symmetric( horizontal: 20.0),
//         // padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: <Widget>[
//               const SizedBox(height: 20.0),
//               TextFormField(
//                 decoration: textInputDecoration.copyWith(hintText: 'Email'),
//                 validator: (val) => val!.isEmpty ? 'Enter an email' : null,
//                 onChanged: (val) {
//                   setState(() => email = val);
//                 },
//               ),
//               const SizedBox(height: 20.0),
//               TextFormField(
//                 obscureText: true,
//                 decoration: textInputDecoration.copyWith(hintText: 'Password'),
//                 validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
//                 onChanged: (val) {
//                   setState(() => password = val);
//                 },
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.only(top: 30),
//                 child: SizedBox(
//                   height: 55,width: 275,
//                   child: MaterialButton(
//                       color: Color.fromRGBO(49, 72, 103, 0.8),
//                       child: const Text(
//                         'Sign In',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () async {
//
//                         optionRefugee=true;
//                         if(_formKey.currentState!.validate()){
//                           setState(() => loading = true);
//                           dynamic result = await _auth.signInWithEmailAndPasswordRef(email, password);
//                           if(result == null) {
//                             setState(() {
//                               loading = false;
//                               error = 'Could not sign in with those credentials';
//                             });
//                           }
//                         }
//                       }
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12.0),
//               Text(
//                 error,
//                 style: const TextStyle(color: Colors.red, fontSize: 14.0),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }