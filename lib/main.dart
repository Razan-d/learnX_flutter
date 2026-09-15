import 'package:flutter/material.dart';
import 'package:learnx_flutter/presentation/home_page.dart';
import 'package:learnx_flutter/presentation/on_boarding.dart';
import 'package:learnx_flutter/presentation/sign_in.dart';
import 'package:learnx_flutter/presentation/sign_up.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner:false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      routes: {
        "SignUp" :(context) => SignUp(),
        "SignIn" :(context) => SignIn(),
        "Home" :(context) => HomePage(),
        },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
       return Container();
  }
}
