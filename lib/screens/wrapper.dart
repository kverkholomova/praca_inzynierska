import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wol_pro_1/Refugee/SettingRefugee.dart';
import 'package:wol_pro_1/screens/authenticate/authenticate.dart';
import 'package:wol_pro_1/screens/option.dart';
import 'package:wol_pro_1/cash/register_form.dart';
import 'package:wol_pro_1/volunteer/home/settings_home_vol.dart';

import '../Refugee/home/home_ref.dart';
import '../models/user.dart';
import '../cash/screen_with_applications.dart';

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
      return SettingsHomeVol();
    }
    else{
      return OptionChoose();
    }
    //return either Home or Return Widget

  }
}
