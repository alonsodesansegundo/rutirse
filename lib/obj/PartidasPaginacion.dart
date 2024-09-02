import '../db/obj/partidaView.dart';

///Clase que nos permite obtener los objetos PartidaView de manera paginada. Esta clase está pensada para
///el punto de vista del terapeuta (ver progresos)
class PartidasPaginacion {
  List<PartidaView> partidas;
  bool hayMasPartidas;

  ///Constructor de la clase PartidasPaginacion
  PartidasPaginacion(this.partidas, this.hayMasPartidas);
}
