import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_intrinsic_value_calculator/changeUsername.dart';
import 'package:stock_intrinsic_value_calculator/screens/aboutScreen.dart';
import 'package:stock_intrinsic_value_calculator/screens/home.dart';
import 'package:stock_intrinsic_value_calculator/screens/riskManagementScreen.dart';
import 'screens/login.dart';
import'screens/register.dart';
import 'screens/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ChangeUsername(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.lightBlue,
        ),
        home: const Login(),
        routes: {
          '/register':(context) => const Register(),
          '/home':(context) => const Home(),
          '/settings':(context) => const SettingsScreen(),
          '/riskManagement' : (context) => const RiskManagementScreen(),
          '/about': (context) => const AboutScreen(),
        },
      ),
    );
  }
}
