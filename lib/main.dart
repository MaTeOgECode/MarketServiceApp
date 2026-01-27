import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miproyecto/pages/login_page.dart';
import 'package:miproyecto/environments/dev.dart';
import 'package:miproyecto/pages/home_page.dart';
import 'package:miproyecto/pages/register_page.dart';

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

  // Colores extraídos de tu código HTML
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
      },
      
      // CONFIGURACIÓN DE TEMA CLARO
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: lightBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: Brightness.light,
          primary: primaryBlue,
          surface: Colors.white,
        ),
        fontFamily: 'Inter', // Asegúrate de tener esta fuente en pubspec.yaml
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

      // CONFIGURACIÓN DE TEMA OSCURO
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: darkBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: Brightness.dark,
          primary: primaryBlue,
          surface: darkInput,
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBackground,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Permite que el sistema elija según la configuración del usuario
      themeMode: ThemeMode.system, 
    );
  }
}