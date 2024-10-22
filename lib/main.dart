import 'package:ecommercettl/pages/authen/auth_page.dart';
import 'package:ecommercettl/pages/authen/login.dart';
import 'package:ecommercettl/pages/authen/register.dart';
import 'package:ecommercettl/pages/client/shop_list_product_page.dart';
import 'package:ecommercettl/pages/client/shopaddproduct.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/pages/client/shoplistproduct.dart';
import 'package:ecommercettl/pages/customer/component/FilterAction.dart';
import 'package:ecommercettl/pages/customer/component/PhotoGallery.dart';
import 'package:ecommercettl/pages/customer/component/PriceRange.dart';
import 'package:ecommercettl/pages/customer/component/ProductReview.dart';
import 'package:ecommercettl/pages/customer/component/SearchScreen.dart';
import 'package:ecommercettl/pages/customer/component/guarantee_card.dart';
import 'package:ecommercettl/pages/customer/component/searchProduct.dart';
import 'package:ecommercettl/pages/customer/home.dart';
import 'package:ecommercettl/pages/customer/productDetail.dart';
import 'package:ecommercettl/pages/customer/test.dart';
import 'package:flutter/material.dart';
import 'package:ecommercettl/pages/customer/bottomnav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/admin/product_list_page.dart';

void main() async {
  // Ensure widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/search': (context) => SearchScreen(),
        '/searchProduct': (context) => SearchProduct(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthPage(),
    );
  }
}
