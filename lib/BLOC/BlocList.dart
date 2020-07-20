import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List bloc = <SingleChildWidget>[
  ChangeNotifierProvider<UserState>(create: (context) => UserState()),
  StreamProvider<ConnectivityResult>.value(
      value: Connectivity().onConnectivityChanged),
  ChangeNotifierProvider<BlocForCategory>(create: (context)=>BlocForCategory(),)
];
