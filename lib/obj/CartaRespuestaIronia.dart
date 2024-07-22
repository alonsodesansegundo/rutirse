import 'package:flutter/material.dart';

import '../db/obj/respuestaIronia.dart';

class CartaRespuestaIronia {
  final RespuestaIronia respuesta;
  bool selected;
  Color backgroundColor;

  CartaRespuestaIronia({
    required this.respuesta,
    this.selected = false,
    this.backgroundColor = Colors.blue,
  });
}
