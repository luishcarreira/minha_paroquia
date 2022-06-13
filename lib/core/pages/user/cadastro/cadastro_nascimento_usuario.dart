import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/user/cadastro/cadastro_sobre_usuario_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class CadastroNascimentoUsuario extends StatefulWidget {
  const CadastroNascimentoUsuario({Key? key}) : super(key: key);

  @override
  State<CadastroNascimentoUsuario> createState() =>
      _CadastroNascimentoUsuarioState();
}

class _CadastroNascimentoUsuarioState extends State<CadastroNascimentoUsuario> {
  final format = DateFormat("dd-MM-yyyy");
  final TextEditingController _data = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _onSubmit() {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      firebase.firestore
          .collection('usuarios')
          .doc(firebase.usuario!.uid)
          .update({
        'nascimento': _data.text,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CadastroSobreUsuarioPage(),
        ),
      );
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
                'Qual a sua',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'data de',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'nascimento?',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Center(
            child: Text(
              'Insira sua data de nascimento',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFFA1C69C),
              ),
            ),
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
                  child: DateTimeField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: AppColors.principal,
                      ),
                    ),
                    format: format,
                    controller: _data,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                    },
                    validator: (text) {
                      if (text == null) {
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
