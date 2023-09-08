
import 'package:final_app/screens/mainScreen.dart';
import 'package:final_app/screens/signInScreen.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: login(),
      routes: {
        'homeScreen': (context) => HomeScreen(),
        'login': (context) => login(),
      },
    );
  }
}
