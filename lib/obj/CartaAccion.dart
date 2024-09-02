import 'package:flutter/material.dart';

import '../db/obj/accion.dart';

///Clase creada para representar una Carta de una Accion a ordenar en el juego Rutinas
class CartaAccion {
  final Accion accion;
  bool selected;
  Color backgroundColor;

  ///Constructor de la clase CartaAccion
  CartaAccion({
    required this.accion,
    this.selected = false,
    this.backgroundColor = Colors.transparent,
  });
}
