import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wol_pro_1/Refugee/SettingRefugee.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/categories_choose.dart';
import 'package:wol_pro_1/widgets/authenticate.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';

import 'package:wol_pro_1/volunteer/home/settings_home_vol.dart';
import '../models/user.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<Users?>(context);
    if (user==null){
      return Authenticate();
    } else if(optionRefugee){
      return SettingsHomeRef();
    }else if(!optionRefugee){
      // return SettingsHomeVol();
      return ChooseCategory();

    }
    else{
      return OptionChoose();
    }
    //return either Home or Return Widget

  }
}
