import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:wol_pro_1/shared/constants.dart';
import 'package:wol_pro_1/volunteer/authenticate/register_volunteer.dart';

import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../../screens/intro_screen/option.dart';

List<String> chosen_category = [];
String user_name = '';
String phone_number = '';
String pesel = '';
// List standart = ["Transfer"];


//
// List categories_volunteer = FirebaseAuth.instance.currentUser.uid.
// (chosen_category != null)?chosen_category:standart;
//
// String firstCategory='';
// String secondCategory='';
// String thirdCategory='';

class RegisterVol1 extends StatefulWidget {



  final Function toggleView;
  RegisterVol1({ required this.toggleView });

  @override
  _RegisterVol1State createState() => _RegisterVol1State();
}

class _RegisterVol1State extends State<RegisterVol1> {


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
                        setState(() => user_name = val);
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
                        setState(() => phone_number = val);
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
                        setState(() => pesel = val);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Choose categories which are the best suitable for you",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: AnimatedButton(
                        selectedBackgroundColor: Color.fromRGBO(
                            69, 148, 179, 0.8),
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
                          if (!chosen_category.contains('Transfer')) {
                            chosen_category.add('Transfer');
                            print(chosen_category);
                          } else if (chosen_category.contains("Transfer")) {
                            chosen_category.remove('Transfer');
                            print("Empty: $chosen_category");
                          }

                          //volunteer_preferencies.add('Transfer');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: AnimatedButton(
                        selectedBackgroundColor: Color.fromRGBO(
                            69, 148, 179, 0.8),
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
                          if (!chosen_category.contains('Accomodation')) {
                            chosen_category.add('Accomodation');
                            print(chosen_category);
                          } else if (chosen_category.contains('Accomodation')) {
                            chosen_category.remove('Accomodation');
                            print("Empty: $chosen_category");
                          }

                          //volunteer_preferencies.add('Transfer');
                        },
                      ),
                    ),
                  ],
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
                      if (!chosen_category.contains(
                          'Assistance with animals')) {
                        chosen_category.add('Assistance with animals');
                        print(chosen_category);
                      } else
                      if (chosen_category.contains('Assistance with animals')) {
                        chosen_category.remove('Assistance with animals');
                        print("Empty: $chosen_category");
                      }

                      //volunteer_preferencies.add('Transfer');
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
                    child: IconButton(onPressed: (){
                      print("QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ");
                      print(user_name);
                      print(phone_number);
                      print(pesel);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegisterVol()));
                    }, icon: Icon(Icons.arrow_right,color: Colors.white,size: 30,)),
                  ),
                ),

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