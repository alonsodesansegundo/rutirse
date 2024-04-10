import 'package:TresEnUno/db/obj/respuestaIronia.dart';
import 'package:flutter/material.dart';

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
