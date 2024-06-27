import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:temu_ekspor_application/pages/intro_pages.dart';
import 'package:temu_ekspor_application/pages/register_page.dart';
import 'package:temu_ekspor_application/pages/login_page.dart';
import 'package:temu_ekspor_application/pages/home_page.dart';
import 'package:temu_ekspor_application/pages/cart_page.dart';
import 'package:temu_ekspor_application/pages/product_detail_page.dart';
import 'package:temu_ekspor_application/pages/payment_page.dart';
import 'package:temu_ekspor_application/pages/order_success_page.dart';
import 'package:temu_ekspor_application/pages/purchase_history_page.dart';
import 'package:temu_ekspor_application/pages/profile_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        // ... other theme settings
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/cart': (context) => const CartPage(),
        '/product_detail': (context) => const ProductDetailPage(),
        '/payment': (context) => const PaymentPage(),
        '/order_success': (context) => const OrderSuccessPage(),
        '/purchase_history': (context) => const PurchaseHistoryPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}