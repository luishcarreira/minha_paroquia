import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class CadastroEventoPage extends StatefulWidget {
  final String codigo_pastoral;
  const CadastroEventoPage({
    Key? key,
    required this.codigo_pastoral,
  }) : super(key: key);

  @override
  State<CadastroEventoPage> createState() => _CadastroEventoPageState();
}

class _CadastroEventoPageState extends State<CadastroEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _descricao = TextEditingController();
  final TextEditingController _data = TextEditingController();
  final format = DateFormat("dd/MM/yyyy HH:mm");

  _onSubmit() async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      DocumentReference docRef = firebase.firestore.collection('eventos').doc();
      firebase.firestore.collection('eventos').doc(docRef.id).set({
        'nome': _nome.text,
        'descricao': _descricao.text,
        'data': _data.text,
        'cod_pastoral': widget.codigo_pastoral,
        'ref_evento': docRef.id
      });

      Navigator.pop(context);
    } else {
      //mensagem de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
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
          Column(
            children: [
              Text(
                'Preencha as informações',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'para o novo evento',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nome,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Nome'),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Preencha o campo corretamente!';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    maxLines: 3,
                    controller: _descricao,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Descrição'),
                    ),
                    //keyboardType: TextInputType.,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Preencha o campo corretamente!';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  DateTimeField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: AppColors.principal,
                      ),
                    ),
                    format: format,
                    controller: _data,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now(),
                          ),
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child ?? Container(),
                            );
                          },
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    validator: (text) {
                      if (text == null) {
                        return 'Preencha o campo corretamente!';
                      }
                      return null;
                    },
                  ),
                ],
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
