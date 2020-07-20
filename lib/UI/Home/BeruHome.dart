import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/Responsive/CustomRatio.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/InterNetConectivity/CheckConnectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class BeruHome extends StatefulWidget {
  static const String route = '/BeruHome';
  @override
  _BeruHomeState createState() => _BeruHomeState();
}

class _BeruHomeState extends State<BeruHome> with TickerProviderStateMixin {
  int index = 0;

  @override
  void initState() {
    super.initState();
    var channel =
        IOWebSocketChannel.connect("ws://beru-server.herokuapp.com/test");
    channel.stream.listen((event) {
      print("data from WS ${event.toString()}");
    }, onError: (error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return checkInterNet(getCategory(context));
  }

  Consumer getCategory(BuildContext context) {
    return Consumer<BlocForCategory>(
      builder: (context, value, child) {
        if (value == null || value.data.loading) {
          return BeruLoadingBar();
        } else if (value.data.isError) {
          return BeruErrorPage(
            errMsg: value.data.error.toString(),
          );
        } else {
          return body(context, value.data.list);
        }
      },
    );
  }

  Scaffold body(BuildContext context, List<BeruCategory> items) {
    TabController tabController =
        TabController(length: items.length, vsync: this, initialIndex: index);
    tabController.addListener(() {
      index = tabController.index;
    });
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            leading: Icon(
              Icons.menu,
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    right: ResponsiveRatio.getWigth(10, context)),
                child: Icon(
                  Icons.notifications,
                  color: Color(0xff545d68),
                ),
              ),
            ],
            centerTitle: true,
            pinned: true,
            expandedHeight: ResponsiveRatio.getHight(200, context),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.none,
              titlePadding: EdgeInsets.only(
                  top: 100,
                  bottom: ResponsiveRatio.getHight(70, context),
                  left: ResponsiveRatio.getWigth(20, context)),
              title: Text(
                "Categories",
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            title: Text("Beru"),
            bottom: TabBar(
                indicatorColor: Colors.transparent,
                controller: tabController,
                tabs: items
                    .map((e) => Tab(
                          text: "${e.name.toString().toUpperCase()}",
                        ))
                    .toList()),
          )
        ];
      },
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(" test"),
          );
        },
      ),
    ));
  }
}
