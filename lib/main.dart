import 'dart:developer';
// testadmin@gmail.com
//222222
import 'package:e_cource/feature/auth/presentation/provider/auth_provider.dart';
import 'package:e_cource/feature/settings/presentation/provider/settings_tab_provider.dart';
import 'package:e_cource/firebase_options.dart';
import 'package:e_cource/general/core/di/injection/injection_config.dart';
import 'package:e_cource/general/core/services/go_route/rout_config.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:google_fonts/google_fonts.dart';

// Cache the text theme once at app level
final _cachedTextTheme = GoogleFonts.outfitTextTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  await FirebaseAuth.instance.authStateChanges().first;

  log("firebase initialize complete");

  await confirugationDependency();

  log("sl confirugationDependency complete");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => sl<AuthProviders>()),
        ChangeNotifierProvider(create: (context) => SettingsTabProvider()),
      ],
      child: const EcourceApp(),
    ),
  );
}

class EcourceApp extends StatelessWidget {
  const EcourceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.white,
          textTheme: _cachedTextTheme,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
