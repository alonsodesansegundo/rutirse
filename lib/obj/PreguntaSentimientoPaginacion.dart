import '../db/obj/preguntaSentimiento.dart';

///Clase que nos permite obtener las preguntas del juego Sentimientos de manera paginada. Creada para el punto
///de vista del terapeuta, de ver preguntas añadidas a dicho juego
class PreguntaSentimientoPaginacion {
  List<PreguntaSentimiento> preguntas;
  bool hayMasPreguntas;

  ///Constructor de la clase PreguntaSentimientoPaginacion
  PreguntaSentimientoPaginacion(this.preguntas, this.hayMasPreguntas);
}
