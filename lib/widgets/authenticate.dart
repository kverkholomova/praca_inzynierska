import 'package:flutter/material.dart';

import 'package:wol_pro_1/screens/register_login/volunteer/register_volunteer_1.dart';
import 'package:wol_pro_1/screens/register_login/refugee/sign_in_refugee.dart';
import '../screens/intro_screen/option.dart';
import '../screens/register_login/volunteer/sign_in_volunteer.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignInRef = true;
  void toggleView(){
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

      return const OptionChoose();
    }

    else {
      if(optionRefugee){
        return SignInRef(toggleView:  toggleView);
      }
      else if(!optionRefugee){
        return RegisterVol1(toggleView:  toggleView);
      }
    return const OptionChoose();
    }
  }
}