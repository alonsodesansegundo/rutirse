import '../db/accion.dart';

class CartaAccion {
  final Accion accion;
  bool selected;

  CartaAccion({
    required this.accion,
    this.selected = false,
  });
}
