import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/onboarding/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registrasi_screen.dart';
import 'screens/auth/verify_otp_screen.dart';
import 'screens/onboarding/safety_agreement_screen.dart';
import 'screens/onboarding/personalization_screen.dart';
import 'screens/onboarding/accessibility_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/chat_screen.dart';
import 'screens/home/journal_screen.dart';
import 'screens/home/journal_entries_screen.dart';
import 'screens/home/bisindo_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/main_navigation.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/check_in_screen.dart';
import 'screens/home/tara_space_screen.dart';
import 'screens/home/taman_pikiran_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/home/skrining_screen.dart';
import 'screens/home/rujukan_profesional_screen.dart';
import 'screens/profile/security_crisis_screen.dart';
import 'screens/support/help_center_screen.dart';
import 'screens/support/about_screen.dart';
import 'screens/support/privacy_screen.dart';
import 'screens/profile/notifications_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Entry Flow (Screens 1-10)
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrasiScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) => const VerifyOTPScreen(),
    ),
    GoRoute(
      path: '/safety-agreement',
      builder: (context, state) => const SafetyAgreementScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/personalization',
      builder: (context, state) => const PersonalizationScreen(),
    ),
    GoRoute(
      path: '/accessibility',
      builder: (context, state) => const AccessibilityScreen(),
    ),

    // Main Navigation with Bottom NavBar (Screens 11, 17, 23, 18, [and more in bottom nav])
    ShellRoute(
      builder: (context, state, child) =>
          MainNavigation(child: child, location: state.uri.toString()),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
        GoRoute(
          path: '/journal',
          builder: (context, state) => const JournalScreen(),
        ),
        GoRoute(
          path: '/journal-entries',
          builder: (context, state) => const JournalEntriesScreen(),
        ),
        GoRoute(
          path: '/bisindo',
          builder: (context, state) => const BisindoScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Feature Screens
    GoRoute(
      path: '/check-in',
      builder: (context, state) => const CheckInScreen(),
    ),
    GoRoute(
      path: '/tara-space',
      builder: (context, state) => const TaraSpaceScreen(),
    ),
    GoRoute(
      path: '/taman-pikiran',
      builder: (context, state) => const TamanPikiranScreen(),
    ),
    GoRoute(
      path: '/skrining',
      builder: (context, state) => const SkriningSertaScreen(),
    ),
    GoRoute(
      path: '/rujukan-profesional',
      builder: (context, state) => const RujakanProfesionalScreen(),
    ),

    // Settings Screens
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/security-crisis',
      builder: (context, state) => const SecurityCrisisScreen(),
    ),
    GoRoute(
      path: '/help-center',
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('404 - Page not found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Go to Home'),
          ),
        ],
      ),
    ),
  ),
);
