import 'package:flutter/material.dart';
import 'package:flutter_cep2/flutter_cep2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/paroquia/cadastros/paroquia_endereco_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class ParoquiaCEPPage extends StatefulWidget {
  final String ref;
  const ParoquiaCEPPage({Key? key, required this.ref}) : super(key: key);

  @override
  State<ParoquiaCEPPage> createState() => _ParoquiaCEPPageState();
}

class _ParoquiaCEPPageState extends State<ParoquiaCEPPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cep = TextEditingController();

  void _searchCEP() async {
    try {
      final CEP = flutter_cep2();
      final result = await CEP.search(_cep.text);

      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ParoquiaEnderecoPage(
              result: result,
              ref: widget.ref,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red[400],
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Digite o CEP',
                style: GoogleFonts.poppins(
                  fontSize: 25,
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
                'Escreva o nome para sua paroquia. Todos',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color.fromARGB(255, 193, 201, 192),
                ),
              ),
              Text(
                'vão identificar a paroquia pelo',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color.fromARGB(255, 193, 201, 192),
                ),
              ),
              Text(
                'nome que voce vai colocar aqui.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color.fromARGB(255, 193, 201, 192),
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
                    controller: _cep,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
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
              onTap: _searchCEP,
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
