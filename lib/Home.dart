import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:family_chat/telas/AbaContatos.dart';
import 'package:family_chat/telas/AbaConversas.dart';
import 'RouteGenerator.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> itensMenu = ["configurações", "Deslogar"];

  String _emailUsuario = "";

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    setState(() {
      _emailUsuario = usuarioLogado!.email!;
    });
  }

  Future _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteGenerator.ROTA_LOGIN, (_) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _verificaUsuarioLogado();
    _recuperarDadosUsuario();
    _tabController = TabController(length: 2, vsync: this);
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "configurações":
        Navigator.pushNamed(context, RouteGenerator.ROTA_CONFIGURACOES);
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
    // print("Item escolhido: " + itemEscolhido);
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.ROTA_LOGIN, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            "Family Chat",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          elevation: Platform.isIOS ? 0 : 4,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            controller: _tabController,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                text: "Conversas",
              ),
              Tab(
                text: "Contatos",
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            AbaConversas(),
            AbaContatos(),
          ],
        ));
  }
}
