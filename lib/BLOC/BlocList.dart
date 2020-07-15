import 'package:beru/BLOC/userProvider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List bloc =<SingleChildWidget> [
  ChangeNotifierProvider<UserState>(create: (context) => UserState()),
  StreamProvider<ConnectivityResult>.value(value:Connectivity().onConnectivityChanged)
];
