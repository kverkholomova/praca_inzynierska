import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wol_pro_1/Refugee/SettingRefugee.dart';
import 'package:wol_pro_1/to_delete/register_refugee.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
import 'package:wol_pro_1/screens/menu/volunteer/main_screen.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/categories_choose.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/register_volunteer_1.dart';
import 'package:wol_pro_1/widgets/authenticate.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';

import '../models/user.dart';


class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  String id = "wrapper";
  @override
  Widget build(BuildContext context) {

    final user=Provider.of<Users?>(context);
    if (user==null){
      return Authenticate();
    } else if(optionRefugee){
      return MainScreenRefugee();
    }else if(!optionRefugee){
      // return SettingsHomeVol();
      return registrationVol?ChooseCategory():MainScreen();

    }
    else{
      return OptionChoose();
    }
    //return either Home or Return Widget

  }
}
