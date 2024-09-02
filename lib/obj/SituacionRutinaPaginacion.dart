import '../db/obj/situacionRutina.dart';

///Clase que nos permite obtener las preguntas del juego Rutinas de manera paginada. Creada para el punto
///de vista del terapeuta, de ver preguntas añadidas a dicho juego
class SituacionRutinaPaginacion {
  List<SituacionRutina> situaciones;
  bool hayMasSituaciones;

  ///Constructor de la clase SituacionRutinaPaginacion
  SituacionRutinaPaginacion(this.situaciones, this.hayMasSituaciones);
}
