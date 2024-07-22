import '../db/obj/preguntaSentimiento.dart';

class PreguntaSentimientoPaginacion {
  List<PreguntaSentimiento> preguntas;
  bool hayMasPreguntas;

  PreguntaSentimientoPaginacion(this.preguntas, this.hayMasPreguntas);
}
