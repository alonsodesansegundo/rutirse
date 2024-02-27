import 'package:flutter/material.dart';

import '../db/obj/accion.dart';

class CartaAccion {
  final Accion accion;
  bool selected;
  Color backgroundColor;

  CartaAccion({
    required this.accion,
    this.selected = false,
    this.backgroundColor = Colors.transparent,
  });
}
