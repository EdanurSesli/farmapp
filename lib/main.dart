import 'dart:io';
import 'package:farmapp/firebase_options.dart';
import 'package:farmapp/services/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/productadd_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/market_register_screen.dart';
import 'screens/farmer_register_screen.dart';
import 'screens/seller_verification_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Farm2MarketApp());
  //home: GoogleSignInScreen(),
}

class Farm2MarketApp extends StatelessWidget {
  const Farm2MarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.white),
          scaffoldBackgroundColor: Colors.grey[100],
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 114, 154, 104),
          ),
        ),
        home: const InitialScreen(),
        initialRoute: '/splashScreen',
        routes: {
          '/splashScreen': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/addProduct': (context) => const ProductAddScreen(),
          '/cart': (context) => const CartScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterSelectionScreen(),
          /*'/profile': (context) => const ProfileScreen(
                userName: '',
                email: '',
              ),*/
          '/marketRegister': (context) => const MarketRegisterScreen(),
          '/farmerRegister': (context) => const FarmerRegisterScreen(),
          '/sellerVerification': (context) => const SellerVerificationScreen(),
          '/orderConfirmation': (context) => const OrderConfirmationScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/categories': (context) => const CategoriesScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late Future<String> _initialRoute;

  @override
  void initState() {
    super.initState();
    _initialRoute = _determineInitialRoute();
  }

  Future<String> _determineInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return isLoggedIn ? '/home' : '/home';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initialRoute,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, snapshot.data!);
          });
          return const SizedBox();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
