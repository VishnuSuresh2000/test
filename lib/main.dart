import 'package:beru/BLOC/BlocList.dart';
import 'package:beru/Route/Route.dart';
import 'package:beru/Theme/DefaultTheme.dart';
import 'package:beru/UI/Home/BeruHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: bloc,
      child: MaterialApp(
        theme: defaultTheme,
        onGenerateRoute: (settings) =>transitionOnRoute(settings),
        debugShowCheckedModeBanner: false,
        home: BeruHome(),
      ),
    );
  }
}

class TestNavigation extends StatelessWidget {
  const TestNavigation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () => Navigator.of(context).pushNamed(BeruHome.route),
            child: Text("test Route"),
          ),
        ),
      ),
    );
  }
}
