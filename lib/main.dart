import 'package:beru/BLOC/BlocList.dart';
import 'package:beru/Route/Route.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/Theme/DefaultTheme.dart';
import 'package:beru/UI/InterNetConectivity/InitalCheck.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  ServerApi.offlineOnline = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Server Url ${ServerApi.url}");
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
