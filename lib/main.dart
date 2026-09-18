import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:learnx_flutter/presentation/main_navigation_screen.dart';
import 'package:learnx_flutter/presentation/on_boarding.dart';
import 'package:learnx_flutter/presentation/auth/sign_in.dart';
import 'package:learnx_flutter/presentation/auth/sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'LearnX LMS',
      theme: ThemeData(
        fontFamily: "Almarai-Arabic",
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      home: session != null ? const MainNavigationScreen() : const OnBoardingPage(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      routes: {
        "SignUp": (context) => const SignUp(),
        "SignIn": (context) => const SignIn(),
        "Home": (context) => const MainNavigationScreen(),
        "MainNavigation": (context) => const MainNavigationScreen(),
      },
    );
  }
}
