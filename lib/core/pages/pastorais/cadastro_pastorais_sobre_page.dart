import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/paroquia/minhas_paroquias_page.dart';
import 'package:minha_paroquia/core/pages/pastorais/pastorais_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class CadastroPastoraisSobrePage extends StatefulWidget {
  final String refParoquia;
  final String refPastoral;
  const CadastroPastoraisSobrePage({
    Key? key,
    required this.refParoquia,
    required this.refPastoral,
  }) : super(key: key);

  @override
  State<CadastroPastoraisSobrePage> createState() =>
      _CadastroPastoraisSobrePageState();
}

class _CadastroPastoraisSobrePageState
    extends State<CadastroPastoraisSobrePage> {
  final TextEditingController _sobre = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _onSubmit() {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      firebase.firestore
          .collection('paroquia')
          .doc(widget.refParoquia)
          .collection('pastoral')
          .doc(widget.refPastoral)
          .update({
        'sobre': _sobre.text,
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => PastoraisPage(
              ref: widget.refParoquia,
            ),
          ),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 40),
          Column(
            children: [
              Text(
                'Nos fale um pouco',
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'mais sobre',
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'a pastoral',
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            children: [
              Text(
                'Escreva uma breve biografia sobre você! Os',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'outros usuários poderão visualizar sua',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'biografia visitando seu perfil.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _sobre,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.name,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Preencha o campo corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.all(24),
            child: GestureDetector(
              onTap: () {
                _onSubmit();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.principal,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Continuar',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
