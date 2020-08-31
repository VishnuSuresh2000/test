import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:beru/Schemas/BeruUser.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/Home/ShowCartButton.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';

class BeruProfile extends StatefulWidget {
  static const String route = '/profileView';
  @override
  _BeruProfileState createState() => _BeruProfileState();
}

class _BeruProfileState extends State<BeruProfile> {
  bool edit = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          actionsIconTheme: Theme.of(context)
              .appBarTheme
              .actionsIconTheme
              .copyWith(color: Theme.of(context).primaryColor),
          iconTheme: Theme.of(context)
              .appBarTheme
              .iconTheme
              .copyWith(color: Theme.of(context).primaryColor),
          title: "My Profile"
              .text
              .textStyle(Theme.of(context)
                  .appBarTheme
                  .textTheme
                  .headline6
                  .copyWith(color: Theme.of(context).primaryColor))
              .make(),
          centerTitle: true,
          actions: [ShowCartButton()]),
      body: swithContent(),
    );
  }

  swithContent() {
    var data = context.select<UserState, Tuple3<bool, BeruUser, Exception>>(
        (value) => Tuple3(value.hasErrorUserDetails, value.user, value.error));
    if (data?.item1 == null) {
      return beruLoadingBar();
    } else if (data.item1) {
      return BeruErrorPage(
        errMsg: data.item3.toString(),
      );
    } else {
      return showContent(data.item2);
    }
  }

  Column showContent(BeruUser user) {
    return Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          flex: 1,
          child: Container(
            color: Color(0xff2BC48A),
            child: Center(
              child: Card(
                color: Colors.transparent,
                shape: CircleBorder(),
                elevation: 0,
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),
        ),
        Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30)
                  .add(EdgeInsets.only(top: 20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                      child: showTextFormField("User Name", "${user.fullName}",
                          (value) => null, (value) {})),
                  Flexible(
                      child: showTextFormField("Email", "${user.email}",
                          (value) => null, (value) {})),
                  Flexible(
                      child: showTextFormField("Phone", "${user.phoneNumber}",
                          (value) => null, (value) {})),
                  Flexible(
                      child: showTextFormField("Gender", "${user.sex?'Male':'Female'}",
                          (value) => null, (value) {})),
                  Flexible(
                      child: showTextFormField(
                          "Address",
                          "${user.address.houseName} ,  ${user.address.locality} , ${user.address.district} ${user.address.pinCode}",
                          (value) => null,
                          (value) {})),
                ],
              ),
            )),
        Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                onPressed: () {},
                color: Color(0xff2BC48A),
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Update Profile",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget showTextFormField(String heading, String value,
      String Function(String) validtor, void Function(String) save) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 14),
      textAlign: TextAlign.start,
      validator: validtor,
      onSaved: save,
      readOnly: !edit,
      initialValue: value,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: heading,
          labelText: heading,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Color(0xff979797), fontSize: 15)),
    );
  }
}
