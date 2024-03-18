import '../db/obj/pregunta.dart';

class PreguntasPaginacion {
  List<Pregunta> preguntas;
  bool hayMasPreguntas;

  PreguntasPaginacion(this.preguntas, this.hayMasPreguntas);
}
