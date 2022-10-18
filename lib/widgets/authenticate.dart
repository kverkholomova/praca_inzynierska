import 'package:flutter/material.dart';
import '../Refugee/authenticate/register_refugee_1.dart';
import '../Refugee/authenticate/sign_in_refugee.dart';
import '../screens/authenticate/register_login/volunteer/sign_in_volunteer.dart';
import '../screens/intro_screen/option.dart';

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
        return RegisterRef1(toggleView:  toggleView);
      }
      else if(!optionRefugee){
        return SignInVol(toggleView:  toggleView);
      }
    return const OptionChoose();
    }
  }
}