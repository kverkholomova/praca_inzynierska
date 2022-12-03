import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/screens/menu/refugee/create_application/create_application.dart';


class SetVol extends StatefulWidget {
  const SetVol({Key? key}) : super(key: key);

  @override
  State<SetVol> createState() => _SetVolState();
}

class _SetVolState extends State<SetVol> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),

          onPressed: () async {
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => OptionChoose()));

          },
        ),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
