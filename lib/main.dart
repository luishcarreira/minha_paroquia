import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/components/usuario_perfil_widget.dart';
import 'package:minha_paroquia/core/pages/pastorais/pastorais_sobre_page.dart';
import 'package:minha_paroquia/core/pages/splash/splash_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthFirebaseService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.principal,
      ),
      home: SplashPage(),
    );
  }
}
