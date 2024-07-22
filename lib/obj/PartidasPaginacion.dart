import '../db/obj/partidaView.dart';

class PartidasPaginacion {
  List<PartidaView> partidas;
  bool hayMasPartidas;

  PartidasPaginacion(this.partidas, this.hayMasPartidas);
}
