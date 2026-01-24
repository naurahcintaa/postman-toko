import 'package:flutter/material.dart';
import '../views/dashboard.dart';
import '../views/login_view.dart';
import '../views/register_user_view.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Poppins'),
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/': (context) => const RegisterUserView(),
      '/login': (context) => const LoginView(),
      '/dashboard': (context) => const DashboardView(),
    },
  ));
}