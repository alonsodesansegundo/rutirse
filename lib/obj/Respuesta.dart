import 'dart:ui';

///Clase creada para representar una Carta de una Respuesta a las preguntas del juego Humor.
class Respuesta {
  int? id;
  String texto;
  Color color;

  ///Constructor de la clase Respuesta
  Respuesta({this.id, required this.texto, required this.color});
}
