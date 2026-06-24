import 'dart:developer';
// testadmin@gmail.com
//22 22 22
import 'package:e_cource/feature/auth/presentation/provider/auth_provider.dart';
import 'package:e_cource/firebase_options.dart';
import 'package:e_cource/general/core/di/injection/injection_config.dart';
import 'package:e_cource/general/core/services/go_route/rout_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("firebase initialize complete");

    await confirugationDependency();

  log("sl confirugationDependency complete");

  runApp(MultiProvider(
    
    
    providers: [

ChangeNotifierProvider(create: (context) => sl<AuthProvider>(),)

    ],
    child: const EcourceApp()));
}

class EcourceApp extends StatelessWidget {
  const EcourceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
