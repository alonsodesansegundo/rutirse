import 'package:flutter/material.dart';

import '../db/obj/respuestaIronia.dart';

///Clase creada para representar una Respuesta del juego Humor
class CartaRespuestaIronia {
  final RespuestaIronia respuesta;
  bool selected;
  Color backgroundColor;

  ///Constructor de la clase CartaRespuestaIronia
  CartaRespuestaIronia({
    required this.respuesta,
    this.selected = false,
    this.backgroundColor = Colors.blue,
  });
}
