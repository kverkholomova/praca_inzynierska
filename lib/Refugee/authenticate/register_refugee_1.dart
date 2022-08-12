import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/Refugee/authenticate/register_refugee.dart';
import 'package:wol_pro_1/shared/constants.dart';


import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../../screens/intro_screen/option.dart';

List<String> chosen_category = [];
String user_name_ref = '';
String phone_number_ref = '';
String pesel_ref = '';


class RegisterRef1 extends StatefulWidget {

  final Function toggleView;
  RegisterRef1({ required this.toggleView });

  @override
  _RegisterRef1State createState() => _RegisterRef1State();
}

class _RegisterRef1State extends State<RegisterRef1> {


  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state




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
      child: loading ? Loading() : Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          elevation: 0.0,
          title: Text('Sign up', style: TextStyle(fontSize: 16),),
          leading: IconButton(icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OptionChoose()),
              );
            },),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text('Sign In', style: TextStyle(color: Colors.white),),
              onPressed: () => widget.toggleView(),
            ),
          ],
        ),
        body: Container(
          color: Color.fromRGBO(234, 191, 213, 0.8),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Name'),
                      validator: (val) =>
                      val!.isEmpty
                          ? 'Enter your name'
                          : null,
                      onChanged: (val) {
                        setState(() => user_name_ref = val);
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Phone number'),
                      validator: (val) =>
                      val!.isEmpty
                          ? 'Enter your phone number'
                          : null,
                      onChanged: (val) {
                        setState(() => phone_number_ref = val);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Pesel'),
                      validator: (val) =>
                      val!.isEmpty
                          ? 'Enter your pesel'
                          : null,
                      onChanged: (val) {
                        setState(() => pesel_ref = val);
                      },
                    ),
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
                    child: IconButton(onPressed: (){
                      print("QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ");
                      // print(user_name);
                      // print(phone_number);
                      // print(pesel);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegisterRef()));
                    }, icon: Icon(Icons.arrow_right,color: Colors.white,size: 30,)),
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