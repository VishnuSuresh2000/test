import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:beru/Responsive/CustomRatio.dart';
import 'package:beru/Schemas/address.dart';
import 'package:beru/UI/CommonFunctions/BeruFormButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeruAdddressAdding extends StatefulWidget {
  @override
  _BeruAdddressAddingState createState() => _BeruAdddressAddingState();
}

class _BeruAdddressAddingState extends State<BeruAdddressAdding> {
  final GlobalKey<FormState> _form = GlobalKey();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Address _userAddress = Address();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Card(
          elevation: 10,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
          margin: EdgeInsets.symmetric(
              vertical: ResponsiveRatio.getHight(51, context),
              horizontal: ResponsiveRatio.getWigth(30, context)),
          child: Padding(
              padding: EdgeInsets.all(ResponsiveRatio.getHight(30, context)),
              child: SingleChildScrollView(
                  child: Center(
                      child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Add Home Address',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 23.0),
                    ),
                    spaceingWidget(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '  Address Details',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    spaceingWidget(),
                    TextFormField(
                      autofocus: true,
                      // controller: _controllerForFirstName,
                      style: style,
                      decoration:
                          textFormFieldDecoration(hintText: "House Name"),
                      validator:
                          textFormFieldStringValidator(field: "House Name"),
                      onSaved: (String value) {
                        _userAddress.houseName = value;
                      },
                    ),
                    spaceingWidget(),
                    TextFormField(
                      autofocus: true,
                      // controller: _controllerForFirstName,
                      style: style,
                      decoration: textFormFieldDecoration(hintText: "Locality"),
                      validator:
                          textFormFieldStringValidator(field: "Locality"),
                      onSaved: (String value) {
                        _userAddress.locality = value;
                      },
                    ),
                    // spaceingWidget(),
                    // TextFormField(
                    //   autofocus: true,
                    //   // controller: _controllerForFirstName,
                    //   style: style,
                    //   decoration: textFormFieldDecoration(hintText: "City"),
                    //   validator: textFormFieldStringValidator(field: "City"),
                    //   onSaved: (String value) {
                    //     _userAddress.city = value;
                    //   },
                    // ),
                    spaceingWidget(),
                    TextFormField(
                      autofocus: true,
                      // controller: _controllerForFirstName,
                      style: style,
                      decoration: textFormFieldDecoration(hintText: "District"),
                      validator:
                          textFormFieldStringValidator(field: "District"),
                      onSaved: (String value) {
                        _userAddress.district = value;
                      },
                    ),
                    spaceingWidget(),
                    TextFormField(
                      autofocus: true,
                      // controller: _controllerForFirstName,
                      style: style,
                      decoration: textFormFieldDecoration(hintText: "State"),
                      validator: textFormFieldStringValidator(field: "State"),
                      onSaved: (String value) {
                        _userAddress.state = value;
                      },
                    ),
                    spaceingWidget(),
                    TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Pincode Number";
                          }
                          if (value.length != 6) {
                            return "Pincode length is Wrong";
                          }

                          return null;
                        },
                        onSaved: (String value) {
                          _userAddress.pinCode = int.parse(value);
                        },
                        decoration:
                            textFormFieldDecoration(hintText: "Pin Code")),
                    spaceingWidget(),
                    TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.isNotEmpty && value.length != 10) {
                            return "Phone Number length is Wrong";
                          }

                          return null;
                        },
                        onSaved: (String value) {
                          if (value.isNotEmpty) {
                            _userAddress.alternateNumber = int.parse(value);
                          }
                        },
                        decoration:
                            textFormFieldDecoration(hintText: "Phone Number")),
                    spaceingWidget(),
                    beruFormButton(
                        context: context,
                        callBack: () {
                          if (_form.currentState.validate()) {
                            _form.currentState.save();
                            Provider.of<UserState>(context, listen: false)
                                .addAddressToUser(_userAddress, context);
                          }
                        },
                        content: "SAVE & CONTINUE")
                  ],
                ),
              ))))),
    );
  }

  AspectRatio spaceingWidget() => AspectRatio(aspectRatio: 11);

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
