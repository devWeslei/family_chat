import 'package:flutter/material.dart';
import 'package:family_chat/Login.dart';
import 'RouteGenerator.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final ThemeData temaPadrao = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xffd38565),
    secondary: const Color(0xffe9c2b2),
  ),
);

final ThemeData temaIOS = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xffd38565),
    secondary: const Color(0xffe9c2b2),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: Platform.isIOS ? temaIOS : temaPadrao,
    home: const Login(),
    initialRoute: RouteGenerator.ROTA_LOGIN,
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
