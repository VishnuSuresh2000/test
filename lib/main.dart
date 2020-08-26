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
import 'package:provider/provider.dart';

void main() {
  ServerApi.offlineOnline = false;
  ServerSocket.serverSocket();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Server Url ${ServerApi.offlineOnline} ${ServerApi.url}");
    return initFirebase();
  }

  FutureBuilder<FirebaseApp> initFirebase() {
    return FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return MaterialApp(
            home: BeruErrorPage(
          errMsg: snapshot.error.toString(),
        ));
      }
      if (snapshot.connectionState == ConnectionState.done) {
        return body();
      }
      return MaterialApp(
        home: beruLoadingBar(),
      );
    },
  );
  }

  MultiProvider body() {
    return MultiProvider(
      providers: bloc,
      child: MaterialApp(
        theme: defaultTheme,
        onGenerateRoute: (settings) => transitionOnRoute(settings),
        debugShowCheckedModeBanner: false,
        home: InitalCheck(),
      ),
    );
  }
}
