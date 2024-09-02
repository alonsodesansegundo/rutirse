import 'package:flutter/material.dart';

import '../db/obj/situacion.dart';

///Clase creada para representar una Carta de una Situacion como respuesta en el juego Sentimientos
class CartaSituacion {
  final Situacion situacion;
  bool selected;
  Color backgroundColor;

  ///Constructor de la clase CartaSituacion
  CartaSituacion({
    required this.situacion,
    this.selected = false,
    this.backgroundColor = Colors.transparent,
  });
}
