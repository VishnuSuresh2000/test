import 'dart:ui';

import 'package:beru/UI/CommonFunctions/BeruFormButton.dart';
import 'package:beru/UI/Home/BeruBottomNavigator.dart';
import 'package:flutter/material.dart';

class BeruProfile extends StatefulWidget {
  @override
  _BeruProfileState createState() => _BeruProfileState();
}

class _BeruProfileState extends State<BeruProfile> {
  final TextStyle headline = TextStyle(color: Colors.green, fontSize: 18);

  final TextStyle content =
      TextStyle(fontSize: 21, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      bottomNavigationBar: BeruBottomNavigator(),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 2,
            child: Center(
              child: Card(
                shape: CircleBorder(),
                elevation: 10,
                child: Image.asset(
                  "assets/images/sex/male.png",
                  height: 105,
                ),
              ),
            ),
          ),
          Flexible(
              child: RaisedButton(
            onPressed: () {},
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(
              "My Cart",
              style: headline,
            ),
          )),
          Flexible(
            flex: 3,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              margin: EdgeInsets.symmetric(horizontal: 30),
              elevation: 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionBuild(
                          heading: "Name", contentData: "Vishnu Suresh"),
                      sectionBuild(
                          heading: "Phone Number", contentData: "7902609618"),
                      sectionBuild(
                          heading: "Email",
                          contentData: "achu10vishnu@gmail.com"),
                      RaisedButton(
                        onPressed: () {},
                        child: Text(
                          "Home Address",
                          style: headline,
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child:
                  beruFormButton(context: context, content: "Update Profile"),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  Column sectionBuild({String heading, String contentData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$heading",
          style: headline,
        ),
        SizedBox.fromSize(
          size: Size.fromHeight(8),
        ),
        Text(
          "$contentData",
          style: content,
        ),
      ],
    );
  }
}
