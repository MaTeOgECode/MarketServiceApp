import 'package:MarketServiceApp/pages/historial_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:MarketServiceApp/pages/login_page.dart';
import 'package:MarketServiceApp/environments/dev.dart';
import 'package:MarketServiceApp/pages/home_page.dart';
import 'package:MarketServiceApp/pages/register_page.dart';
import 'package:MarketServiceApp/pages/info_page.dart';
import 'package:MarketServiceApp/pages/perfil_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig.apiKey,
      projectId: firebaseConfig.projectId,
      storageBucket: firebaseConfig.storageBucket,
      messagingSenderId: firebaseConfig.messagingSenderId,
      appId: firebaseConfig.appId,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryBlue = Color(0xFF137FEC);
  static const Color lightBackground = Color(0xFFF6F7F8);
  static const Color darkBackground = Color(0xFF101922);
  static const Color darkInput = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Pro',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/info': (context) => const AboutCreatorsPage(),
        '/profile': (context) => const ProfilePage(),
        '/historial': (context) => const ServiceHistoryPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: lightBackground,
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF0D141B),
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: lightBackground,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF0D141B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: primaryBlue,
          onPrimary: Colors.white,
          surface: darkInput,
          onSurface: Colors.white,
        ),
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
    );
  }
}