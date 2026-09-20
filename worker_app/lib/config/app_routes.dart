import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/main_screen.dart'; 
import '../screens/onboarding/skill_selection_screen.dart';
import '../screens/onboarding/document_upload_screen.dart';
import '../screens/onboarding/verification_pending_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String skills = '/onboarding/skills';
  static const String verification = '/onboarding/verification';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        home: (context) => const MainScreen(),
        skills: (context) => const SkillSelectionScreen(),
        verification: (context) => const VerificationPendingScreen(),
      };
}
