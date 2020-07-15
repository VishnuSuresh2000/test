import 'package:beru/BLOC/userProvider.dart';
import 'package:beru/REST_Api/ServerApi.dart';
import 'package:beru/Schemas/user.dart';
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeruSignUp extends StatefulWidget {
  @override
  _BeruSignUpState createState() => _BeruSignUpState();
}

class _BeruSignUpState extends State<BeruSignUp> {
  User devUser = User.fromMap({
    'firstName': "vishnu",
    'lastName': "suresh",
    'phoneNumber': 7902609618,
    'sex': true,
    'email': 'achu00vishnu@gmail.com',
    'address': {
      'houseName': "Kochupurayil",
      'locality': "Kattachira p o",
      'pinCode': 686572,
      'city': "ettumanoor",
      'district': "kottayam",
      'state': "kerala",
    },
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () async {
          try {
            var res = await ServerApi.serverCreateUser(devUser);
            print(res);
            Provider.of<UserState>(context, listen: false).siginUpServer = true;
          } catch (e) {
            print(e);
            errorAlert(context, e.toString());
          }
        },
        child: Text(
          "SignUp with defalute Variables for App",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
