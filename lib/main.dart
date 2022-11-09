import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'our_apps_constants.dart';
import 'our_apps_json_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: kOurAppsActionBarColor,
        systemNavigationBarColor: kOurAppsMainScreenCards,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OurAppsJSONII(),
    );
  }
}
