import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardEventoWidget extends StatefulWidget {
  final String? nome;

  const CardEventoWidget({
    Key? key,
    required this.nome,
  }) : super(key: key);

  @override
  State<CardEventoWidget> createState() => _CardEventoWidgetState();
}

class _CardEventoWidgetState extends State<CardEventoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: Color(0xFFE1E1E6),
          ),
        ),
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(),
    );
  }
}
