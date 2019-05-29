import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SplashPage.dart';
import 'HomePage.dart';
import 'loginPage.dart';
import 'FoodPage.dart';
import 'TransportPage.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Project',
      debugShowCheckedModeBanner: false,
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => new HomePage(),
        '/TransportPage': (BuildContext context) => new TransportPage(),
        '/FoodPage': (BuildContext context) => new FoodPage(),
        '/LoginPage': (BuildContext context) => new LoginPage(),

      },
    );
  }
}


