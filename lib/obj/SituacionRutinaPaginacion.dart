import '../db/obj/situacionRutina.dart';

class SituacionRutinaPaginacion {
  List<SituacionRutina> situaciones;
  bool hayMasSituaciones;

  SituacionRutinaPaginacion(this.situaciones, this.hayMasSituaciones);
}
