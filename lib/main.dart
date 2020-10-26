import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lost_heros_endsars/providers/home_page_provider.dart';
import 'package:lost_heros_endsars/utils/constants.dart'; 
import 'package:lost_heros_endsars/utils/routes.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox(userDataBoxKey);
  await Hive.openBox(navigationKey);
  await Hive.openBox(victimBox);
  OneSignal.shared.init('a1deba28-690f-4f60-9965-a0d76da16aa8');

  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    var url = openedResult.notification.payload.launchUrl;
    print(openedResult);
  });

  OneSignal.shared.setNotificationReceivedHandler((openedResult) {
    print(openedResult);
    var url = openedResult.payload.launchUrl;
    print(openedResult);
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => HomePageProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'EndSARS Hero',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.black,
        primaryColorLight: Colors.black
      ),
      onGenerateRoute: (settings) => RouteGenerator.onGenerateRoute(settings),
      initialRoute: 'splash_screen',
      debugShowCheckedModeBanner: false,
    );
  }
}