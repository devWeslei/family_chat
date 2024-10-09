import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;
import '../RouteGenerator.dart';
import '../model/Usuario.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  Usuario _usuarioLogado = Usuario();

  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? _idUsuarioLogado;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  Stream<QuerySnapshot>? _adicionarListenerConversas() {
    final stream = db
        .collection("conversas")
        .doc(_idUsuarioLogado)
        .collection("ultima_conversa")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    return null;
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = auth.currentUser!;

    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(usuarioLogado.uid).get();

    dynamic user = snapshot.data();

    setState(() {
      _idUsuarioLogado = usuarioLogado.uid;
      _usuarioLogado.nome = user["nome"];
      _usuarioLogado.urlImagem = user["caminhoFoto"];
      _usuarioLogado.email = usuarioLogado.email;
    });

    _adicionarListenerConversas();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando conversas"),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados!");
            } else {
              QuerySnapshot? querySnapshot = snapshot.data;

              if (querySnapshot?.docs.length == 0) {
                return Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda :( ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: querySnapshot?.docs.length,
                itemBuilder: (context, indice) {
                  List<DocumentSnapshot> conversas =
                      querySnapshot!.docs.toList();
                  DocumentSnapshot item = conversas[indice];

                  String? urlImagem = item["caminhoFoto"];
                  String tipo = item["tipoMensagem"];
                  String mensagem = item["mensagem"];
                  String nome = item["nome"];
                  String idDestinatario = item["idDestinatario"];
                  int unreadCount = item["unreadCount"] ?? 0;

                  Usuario usuario = Usuario();
                  usuario.nome = nome;
                  usuario.urlImagem = urlImagem;
                  usuario.idUsuario = idDestinatario;

                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteGenerator.ROTA_MENSAGENS,
                        arguments: usuario,
                      );
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          urlImagem != null ? NetworkImage(urlImagem) : null,
                    ),
                    title: badges.Badge(
                      showBadge: unreadCount > 0,
                      badgeContent: Text(
                        unreadCount.toString(),
                        style: TextStyle(fontSize: 25),
                      ),
                      badgeAnimation: badges.BadgeAnimation.slide(),
                      child: Text(
                        nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      tipo == "texto" ? mensagem : "imagem...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }
}
