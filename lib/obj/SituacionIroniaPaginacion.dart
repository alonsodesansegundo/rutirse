import '../db/obj/situacionIronia.dart';

///Clase que nos permite obtener las preguntas del juego Humor de manera paginada. Creada para el punto
///de vista del terapeuta, de ver preguntas añadidas a dicho juego
class SituacionIroniaPaginacion {
  List<SituacionIronia> situaciones;
  bool hayMasSituaciones;

  ///Constructor de la clase SituacionIroniaPaginacion
  SituacionIroniaPaginacion(this.situaciones, this.hayMasSituaciones);
}
