import 'package:flutter/material.dart';
import 'package:wol_pro_1/models/user.dart';
import 'package:wol_pro_1/shared/constants.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> role_list=['1','2'];

  late String currentName;
  late String currentRole;

  @override
  Widget build(BuildContext context) {



    return StreamBuilder<UserData>(
      stream: null,
      builder: (context, snapshot) {
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                "Update your settings"
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration,
                validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                onChanged: (val) => setState(() => currentName = val),
              ),
              SizedBox(height: 10.0),
              //dropdown
              DropdownButtonFormField(
                value: '1',
                items: role_list.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text('$role role'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => currentRole = val.toString());
                },
              ),
              //slider
              MaterialButton(
                  color: Colors.pink[400],
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    print(currentName);
                    print(currentRole);

                  }
              ),
            ],
          ),
        );
      }
    );
  }
}
