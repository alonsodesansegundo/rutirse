import '../db/obj/jugadorView.dart';

///Clase que nos permite obtener los objetos JugadoresView de manera paginada. Esta clase está pensada para
///el punto de vista del terapeuta (eliminar jugador)
class JugadoresPaginacion {
  List<JugadorView> jugadores;
  bool hayMasJugadores;

  ///Constructor de la clase JugadoresPaginacion
  JugadoresPaginacion(this.jugadores, this.hayMasJugadores);
}
