import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/providers/auth_provider.dart';
import 'package:trip_organizer_project/core/theme/app_theme.dart';
import 'package:trip_organizer_project/data/repositories/firebase/firebase_auth_repository.dart';
import 'package:trip_organizer_project/data/repositories/firebase/firebase_trip_repository.dart';
import 'package:trip_organizer_project/data/repositories/firebase/firebase_user_repository.dart';
import 'package:trip_organizer_project/firebase_options.dart';
import 'package:trip_organizer_project/presentation/screens/add_trip_screen.dart';
import 'package:trip_organizer_project/presentation/screens/auth/login_screen.dart';
import 'package:trip_organizer_project/presentation/screens/auth/register_screen.dart';
import 'package:trip_organizer_project/presentation/screens/browse_destinations_screen.dart';
import 'package:trip_organizer_project/presentation/screens/budget/add_expense_screen.dart';
import 'package:trip_organizer_project/presentation/screens/budget/budget_screen.dart';
import 'package:trip_organizer_project/presentation/screens/home_screen.dart';
import 'package:trip_organizer_project/presentation/screens/profile_screen.dart';
import 'package:trip_organizer_project/presentation/screens/settings_screen.dart';
import 'package:trip_organizer_project/presentation/screens/splash_screen.dart';

void main() async {
  FlutterError.onError = (details) {
    debugPrint('=== FLUTTER ERROR ===');
    debugPrint(details.exceptionAsString());
    debugPrint(details.stack.toString());
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('=== UNCAUGHT ERROR ===');
    debugPrint(error.toString());
    debugPrint(stack.toString());
    return true;
  };

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            authRepository: FirebaseAuthRepository(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AppStore>(
          create: (_) => AppStore(
            tripRepository: FirebaseTripRepository(),
            userRepository: FirebaseUserRepository(),
          ),
          update: (_, auth, store) {
            if (auth.status == AuthStatus.authenticated && !store!.isLoaded) {
              store.load(auth.uid!, fallbackName: auth.displayName, fallbackEmail: auth.email);
            } else if (auth.status == AuthStatus.unauthenticated &&
                store!.isLoaded) {
              store.reset();
            }
            return store!;
          },
        ),
      ],
      child: const VoyageApp(),
    ),
  );
}

class VoyageApp extends StatelessWidget {
  const VoyageApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkModeEnabled = context.watch<AppStore>().preferences.darkModeEnabled;

    return MaterialApp(
      title: 'Voyage',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: const AuthGate(),
      routes: {
        '/register': (_) => const RegisterScreen(),
        '/budget': (_) => const BudgetScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/add_trip': (_) => const AddTripScreen(),
        '/browse_destinations': (_) => const BrowseDestinationsScreen(),
        '/add_expense': (_) => const AddExpenseScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthProvider>().status;
    final store = context.watch<AppStore>();

    if (authStatus == AuthStatus.unknown ||
        (authStatus == AuthStatus.authenticated && !store.isLoaded)) {
      return const SplashScreen();
    }

    if (authStatus == AuthStatus.unauthenticated) {
      return const LoginScreen();
    }

    return const HomeScreen();
  }
}
