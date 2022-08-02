import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/screens/wrapper.dart';
import '../shared/loading.dart';


var optionRefugee=true;

class OptionChoose extends StatefulWidget {
  const OptionChoose({Key? key}) : super(key: key);


  @override
  State<OptionChoose> createState() => _OptionChooseState();
}

class _OptionChooseState extends State<OptionChoose> {

  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
      print(value);
    });}

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      body: Container(
        color: const Color.fromRGBO(234, 191, 213, 0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 250,horizontal: 20),
          child: Column(
            children: const [
              Center(
                child: StartButton(buttonName: 'Volunteer', optionRef: false,),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: StartButton(buttonName: 'Refugee', optionRef: true,)
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

class StartButton extends StatelessWidget {
  final String buttonName;
  final bool optionRef;
  const StartButton({
    Key? key, required this.buttonName, required this.optionRef
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20)
      ),
      child: MaterialButton(
      color: const Color.fromRGBO(137, 102, 120, 0.8),
      child: Text(buttonName),
      onPressed: () async{

        optionRefugee=optionRef;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Wrapper()));
      },
      ),
    );
  }
}
