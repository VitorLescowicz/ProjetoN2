// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/compra_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/compra_list_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<CompraProvider>(
          create: (_) => CompraProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Registro de Compras Online',
            debugShowCheckedModeBanner: false,  // Remove a tag "Debug"
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                primary: AppColors.primary,
                secondary: AppColors.accent,
                surface: AppColors.surface,
                background: AppColors.background,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: AppColors.text,
              ),
              scaffoldBackgroundColor: AppColors.background,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
              cardColor: AppColors.cardBackground,
            ),
            home: authProvider.isAuthenticated
                ? const CompraListScreen()
                : const AuthScreen(),
            routes: {
              // Defina outras rotas aqui, se necessário
            },
          );
        },
      ),
    );
  }
}
