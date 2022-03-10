import 'package:flutter/material.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/auth/auth_check.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 2),
    ).then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthCheck()),
        ));
    return Scaffold(
      backgroundColor: AppColors.principal,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
