import 'dart:io';

import 'package:beru/BLOC/BlocList.dart';
import 'package:beru/Route/Route.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';
import 'package:beru/Theme/DefaultTheme.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/InterNetConectivity/InitalCheck.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  // ServerApi.offlineOnline = false;
  // ServerSocket.serverSocket();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;
  Exception _errorOnInitFirebase;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _errorOnInitFirebase = e;
      });
    }
  }

  Widget checkFirebaseInIt() {
    if (_error) {
      return BeruErrorPage(errMsg: _errorOnInitFirebase.toString());
    }
    if (!_initialized) {
      return beruLoadingBar();
    }
    return InitalCheck();
  }

  @override
  void initState() {
    initializeFlutterFire();
    ServerApi.offlineOnline = true;
    ServerSocket.serverSocket();
    super.initState();
  }

  @override
  void dispose() {
    print("Dispose of MyappState");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Server Url ${ServerApi.offlineOnline} ${ServerApi.url}");
    return MultiProvider(
      providers: bloc,
      child: MaterialApp(
        theme: defaultTheme,
        onGenerateRoute: (settings) => transitionOnRoute(settings),
        debugShowCheckedModeBanner: false,
        home: checkFirebaseInIt(),
      ),
    );
  }
}

void globalClose() {
  if (Platform.isAndroid) {
    ServerSocket.dispose();
    SystemNavigator.pop();
  }
}
