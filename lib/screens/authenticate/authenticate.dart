import 'package:flutter/material.dart';

import 'package:wol_pro_1/volunteer/authenticate/register_volunteer.dart';
import 'package:wol_pro_1/volunteer/authenticate/register_volunteer_1.dart';

import 'package:wol_pro_1/screens/register_login/volunteer/sign_in_volunteer.dart';

import '../../Refugee/authenticate/register_refugee.dart';
import '../../Refugee/authenticate/register_refugee_1.dart';
import '../../Refugee/authenticate/sign_in_refugee.dart';
import '../intro_screen/option.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {


  bool showSignInRef = true;
  void toggleView(){
    //print(showSignIn.toString());
    setState(() => showSignInRef = !showSignInRef);
  }


  @override
  Widget build(BuildContext context) {
    if (showSignInRef) {
      if(optionRefugee){
        return SignInRef(toggleView:  toggleView);
      }
      else if(!optionRefugee){
        return SignInVol(toggleView:  toggleView);
      }

      return OptionChoose();
    }

    else {
      if(optionRefugee){
        return RegisterRef1(toggleView:  toggleView);
      }
      else if(!optionRefugee){
        return RegisterVol1(toggleView:  toggleView);
      }
    return OptionChoose();
    }
  }
}