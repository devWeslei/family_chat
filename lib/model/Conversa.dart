import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa {
  String? _idDestinatario;
  String? _idRemetente;
  String? _nome;
  String? _mensagem;
  String? _caminhoFoto;
  String? _tipoMensagem; //texto ou imagem
  int _unreadCount = 0;

  Conversa();

  salvar() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("conversas")
        .doc(this.idRemetente)
        .collection("ultima_conversa")
        .doc(this.idDestinatario)
        .set(this.toMap(), SetOptions(merge: true));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idRemetente": this.idRemetente,
      "idDestinatario": this.idDestinatario,
      "nome": this.nome,
      "mensagem": this.mensagem,
      "caminhoFoto": this.caminhoFoto,
      "tipoMensagem": this.tipoMensagem,
      "unreadCount": this.unreadCount,
    };

    return map;
  }

  int get unreadCount => _unreadCount;
  set unreadCount(int value) {
    _unreadCount = value;
  }

  String? get idDestinatario => _idDestinatario;

  set idDestinatario(String? value) {
    _idDestinatario = value;
  }

  String? get nome => _nome;

  set nome(String? value) {
    _nome = value;
  }

  String? get caminhoFoto => _caminhoFoto;

  set caminhoFoto(String? value) {
    _caminhoFoto = value;
  }

  String? get mensagem => _mensagem;

  set mensagem(String? value) {
    _mensagem = value;
  }

  String? get idRemetente => _idRemetente;

  set idRemetente(String? value) {
    _idRemetente = value;
  }

  String? get tipoMensagem => _tipoMensagem;

  set tipoMensagem(String? value) {
    _tipoMensagem = value;
  }
}
