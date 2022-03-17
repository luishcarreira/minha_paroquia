import 'package:cloud_firestore/cloud_firestore.dart';

class MensagemModel {
  String? uid;
  String? nome;
  String? mensagem;
  Timestamp? data;
  bool? deleted = false;
  String? codigo_pastoral;

  MensagemModel({
    this.uid,
    this.nome,
    this.mensagem,
    this.data,
    this.deleted,
    this.codigo_pastoral,
  });

  //MensagemModel(this.uid, this.nome, this.mensagem, this.data);

  MensagemModel.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.nome = map['nome'];
    this.mensagem = map['mensagem'];
    this.data = map['data'] as Timestamp;
    this.codigo_pastoral = map['codigo_pastoral'];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": this.uid,
      "nome": this.nome,
      "mensagem": this.mensagem,
      "data": new DateTime.now(),
      "deleted": false,
      "codigo_pastoral": this.codigo_pastoral,
    };
  }
}
