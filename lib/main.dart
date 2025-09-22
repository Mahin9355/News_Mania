import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import '../screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsMania',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}