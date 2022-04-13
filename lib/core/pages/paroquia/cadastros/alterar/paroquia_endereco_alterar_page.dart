import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cep2/flutter_cep2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/home/home_page.dart';
import 'package:minha_paroquia/core/pages/paroquia/minhas_paroquias_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class ParoquiaEnderecoAlterarPage extends StatefulWidget {
  final CEP result;
  final String ref_paroquia;
  const ParoquiaEnderecoAlterarPage({
    Key? key,
    required this.result,
    required this.ref_paroquia,
  }) : super(key: key);

  @override
  State<ParoquiaEnderecoAlterarPage> createState() =>
      _ParoquiaEnderecoAlterarPageState();
}

class _ParoquiaEnderecoAlterarPageState
    extends State<ParoquiaEnderecoAlterarPage> {
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );

    return FutureBuilder<DocumentSnapshot>(
      future: firebase.firestore
          .collection('paroquia')
          .doc(widget.ref_paroquia)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          final TextEditingController _ctrlApelido = TextEditingController(
            text: data['apelido'],
          );

          final _formKey = GlobalKey<FormState>();
          final TextEditingController _numero = TextEditingController();

          _onSubmit() async {
            AuthFirebaseService firebase =
                Provider.of<AuthFirebaseService>(context, listen: false);
            final isValid = _formKey.currentState!.validate();

            if (isValid) {
              firebase.firestore
                  .collection('paroquia')
                  .doc(widget.ref_paroquia)
                  .update(
                {
                  'endereco_completo': widget.result.logradouro +
                      ', Nº ' +
                      _numero.text +
                      ' - ' +
                      widget.result.bairro +
                      ', ' +
                      widget.result.localidade +
                      ' - ' +
                      widget.result.uf,
                  'cep': widget.result.cep,
                  'logradouro': widget.result.logradouro,
                  'bairro': widget.result.bairro,
                  'localidade': widget.result.localidade,
                  'uf': widget.result.uf,
                  'numero': _numero.text
                },
              );

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao atualizar endereço'),
                  backgroundColor: Colors.red[400],
                ),
              );
            }
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: SafeArea(
                top: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: ListView(
              children: [
                SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Confirme o endereco e',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: AppColors.principal,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'preencha o numero.',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: AppColors.principal,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Logradouro')),
                        enabled: false,
                        initialValue: widget.result.logradouro,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Bairro')),
                        enabled: false,
                        initialValue: widget.result.bairro,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Cidade')),
                        enabled: false,
                        initialValue: widget.result.localidade,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), label: Text('UF')),
                        enabled: false,
                        initialValue: widget.result.uf,
                      ),
                      SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Numero')),
                          controller: _numero,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: _onSubmit,
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
                              'Atualizar',
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

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
