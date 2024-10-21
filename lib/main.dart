import 'package:ecommercettl/pages/customer/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/authen/auth_page.dart';
import 'pages/admin/admin_shop_requests.dart';
import 'pages/customer/bottomnav.dart';
import 'pages/authen/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => AuthPage(),
        '/bottom-nav': (context) => BottomNav(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}