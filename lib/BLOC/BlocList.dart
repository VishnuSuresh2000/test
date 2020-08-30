import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/BLOC/CustomProviders/BLOCForHome.dart';
import 'package:beru/BLOC/CustomProviders/BlocForAddToBag.dart';
import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:beru/BLOC/CustomeStream/CartStream.dart';
import 'package:beru/BLOC/CustomeStream/ProductStream.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List bloc = <SingleChildWidget>[
  ChangeNotifierProvider<UserState>(create: (context) => UserState()),
  StreamProvider<ConnectivityResult>.value(
      value: Connectivity().onConnectivityChanged),
  ChangeNotifierProvider<BlocForCategory>(
    create: (context) => BlocForCategory(),
  ),
  ChangeNotifierProvider<BloCForHome>(
    create: (_) => BloCForHome(),
  ),
  StreamProvider<SallesData>(
    create: (context) => ProductSallesStream().stream,
    catchError: (context, error) {
      print("Error from ProductSallesStrea init $error");
      return null;
    },
  ),
  StreamProvider<CartData>(
    create: (context) => CartStream().stream,
    catchError: (context, error) {
      print("Error from ProductSallesStrea init $error");
      return null;
    },
  ),
  // ChangeNotifierProvider<BlocForAddToBag>(
  //   create: (context) => BlocForAddToBag(),
  // )
  ChangeNotifierProxyProvider<CartData, BlocForAddToBag>(
    create: (context) => BlocForAddToBag(),
    update: (context, value, previous) => previous..updateCart(value),
  )
];
