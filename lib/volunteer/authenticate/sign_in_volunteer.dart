import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/shared/loading.dart';
import 'package:wol_pro_1/volunteer/authenticate/register_volunteer_1.dart';

import '../../shared/constants.dart';
import '../../cash/screen_with_applications.dart';

class SignInVol extends StatefulWidget {

  final Function toggleView;
  SignInVol({ required this.toggleView });

  @override
  _SignInVolState createState() => _SignInVolState();
}

class _SignInVolState extends State<SignInVol> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        elevation: 0.0,
        title: Text('Sign in', style: TextStyle(fontSize: 16),),
        actions: <Widget>[
          FlatButton.icon(
            icon: const Icon(Icons.person, color: Colors.white,),
            label: const Text('Register', style: TextStyle(color: Colors.white),),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(234, 191, 213, 0.8),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 75),
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
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 240),
                  child: Container(
                    height: 55,
                    width: 275,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: MaterialButton(
                        color: Color.fromRGBO(49, 72, 103, 0.8),
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {

                          if(_formKey.currentState!.validate()){
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithEmailAndPasswordVol(email, password);
                            if(result == null) {
                              setState(() {
                                loading = false;
                                error = 'Could not sign in with those credentials';
                              });
                            }
                          }
                        }
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
