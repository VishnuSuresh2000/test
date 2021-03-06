import 'dart:ui';
import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:beru/UI/CommonFunctions/BeruFormButton.dart';
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeruSignUp extends StatefulWidget {
  @override
  _BeruSignUpState createState() => _BeruSignUpState();
}

class _BeruSignUpState extends State<BeruSignUp> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _controllerForLastName;
  TextEditingController _controllerForFirstName;
  TextEditingController _controllerForEmail;
  TextEditingController _controllerPhoneNumber;
  @override
  void initState() {
    _controllerForLastName = TextEditingController();
    _controllerForFirstName = TextEditingController();
    _controllerForEmail = TextEditingController();
    _controllerPhoneNumber = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserState _userState = Provider.of<UserState>(context);
    _controllerForLastName.text = _userState.user.lastName;
    _controllerForFirstName.text = _userState.user.firstName;
    _controllerForEmail.text = _userState.user.email;
    _controllerPhoneNumber.text = _userState.user.phoneNumber?.toString();
    print(
        "from build method ${_userState.user.firstName} ${_userState.user.lastName}");

    return  Center(
        child: Container(
          height: context.isMobile
              ? context.percentHeight * 100
              : context.percentHeight * 90,
          width: context.isMobile ? context.percentWidth * 100 : 380,
          child: Card(
            elevation: 10,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Register To Beru',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23.0),
                      ),
                      spaceingWidget(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Personal Details',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      spaceingWidget(),
                      TextFormField(
                        autofocus: true,
                        controller: _controllerForFirstName,
                        style: style,
                        decoration:
                            textFormFieldDecoration(hintText: "First Name"),
                        validator:
                            textFormFieldStringValidator(field: "First Name"),
                        onSaved: (String value) {
                          _userState.user.firstName = value;
                        },
                      ),
                      spaceingWidget(),
                      TextFormField(
                        autofocus: true,
                        controller: _controllerForLastName,
                        style: style,
                        decoration:
                            textFormFieldDecoration(hintText: "Last Name"),
                        validator:
                            textFormFieldStringValidator(field: "Last Name"),
                        onSaved: (String value) {
                          _userState.user.lastName = value;
                        },
                      ),
                      spaceingWidget(),
                      selectSex(_userState),
                      spaceingWidget(),
                      Text(
                          "${_userState.user.sex == null ? 'Select Gender' : _userState.user.sex ? 'Male' : 'Female'}"),
                      spaceingWidget(),
                      TextFormField(
                        controller: _controllerForEmail,
                        style: style,
                        autofocus: true,
                        decoration: textFormFieldDecoration(hintText: "Email"),
                        validator: (value) {
                          if (value.isNotEmpty &&
                              !value.contains(new RegExp(
                                  r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$'))) {
                            return "Please Enter Email on the formate\nEg: example@email.com";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _userState.user.email = value;
                        },
                      ),
                      spaceingWidget(),
                      TextFormField(
                          controller: _controllerPhoneNumber,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please Enter Phone Number";
                            }
                            if (value.length != 10) {
                              return "Phone Number length is Wrong";
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _userState.user.phoneNumber = int.parse(value);
                          },
                          decoration: textFormFieldDecoration(
                              hintText: "Phone Number")),
                      spaceingWidget(),
                      beruFormButton(
                          context: context,
                          callBack: () {
                            if (_userState.user.sex == null) {
                              errorAlert(context, "Please Select Gender");
                            } else if (_userState.user.sex != null) {
                              if (_form.currentState.validate()) {
                                _form.currentState.save();
                                _userState.registerToServer(context);
                              }
                            }
                          },
                          content: "SAVE & CONTINUE")
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

    );
  }

  AspectRatio spaceingWidget() => AspectRatio(aspectRatio: 15);

  Row selectSex(UserState _userState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buttonGetSexOfUser(
            sex: "male",
            callBack: () {
              _userState.user.sex = true;
              setState(() {});
            },
            select: _userState.user.sex == null
                ? false
                : _userState.user.sex == true),
        buttonGetSexOfUser(
            sex: "female",
            callBack: () {
              _userState.user.sex = false;
              setState(() {});
            },
            select: _userState.user.sex == null
                ? false
                : _userState.user.sex == false),
      ],
    );
  }

  buttonGetSexOfUser({String sex, Function callBack, bool select}) {
    return OutlineButton(
      shape: CircleBorder(),
      borderSide: BorderSide(color: Colors.transparent),
      onPressed: callBack,
      child: Container(
        height: 78,
        width: 78,
        child: Stack(
          children: [
            Opacity(
              opacity: select ? 0.4 : 1,
              child: Image.asset(
                "assets/images/sex/$sex.png",
                fit: BoxFit.cover,
                height: 78,
              ),
            ),
            if (select)
              Center(
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.green,
                ),
              )
          ],
        ),
      ),
    );
  }

  Function textFormFieldStringValidator({String field}) {
    return (String value) {
      if (value.isEmpty) {
        return "Please Enter $field";
      }
      return null;
    };
  }

  InputDecoration textFormFieldDecoration({String hintText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
          gapPadding: 2.0,
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.green)),
    );
  }
}
