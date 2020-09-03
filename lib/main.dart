import 'dart:io';
import 'package:beru/BLOC/BlocList.dart';
import 'package:beru/Route/Route.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Server/ServerWebSocket.dart';
import 'package:beru/Theme/DefaultTheme.dart';
import 'package:beru/UI/Home/BeruHome.dart';
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
  @override
  void initState() {
    ServerApi.offlineOnline = false;
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
        // home: BeruHome(),
        initialRoute: BeruHome.route,
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
