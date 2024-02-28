import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa el paquete de Provider
import 'package:rutinas/provider/MyProvider.dart';

import 'screens/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // Wrap tu aplicación con ChangeNotifierProvider
      create: (context) => MyProvider(), // Crea una instancia de tu Provider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutinas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}
