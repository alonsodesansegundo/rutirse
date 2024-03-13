import 'Pictograma.dart';

class PictogramasPaginacion {
  List<Pictograma> listaPictogramas;
  int elementosPorPagina;
  int paginaActual;

  PictogramasPaginacion({
    required this.listaPictogramas,
    required this.elementosPorPagina,
  }) : paginaActual = 1;

  List<Pictograma> obtenerPictogramasPaginaActual() {
    final startIndex = (paginaActual - 1) * elementosPorPagina;
    final endIndex = startIndex + elementosPorPagina;

    // Asegúrate de que el índice final no exceda el tamaño de la lista
    final safeEndIndex = endIndex <= listaPictogramas.length
        ? endIndex
        : listaPictogramas.length;

    return listaPictogramas.sublist(startIndex, safeEndIndex);
  }

  bool hayMasPaginas() {
    return paginaActual < calcularTotalPaginas();
  }

  void irAPaginaSiguiente() {
    if (hayMasPaginas()) {
      paginaActual++;
    }
  }

  void irAPaginaAnterior() {
    paginaActual--;
  }

  int calcularTotalPaginas() {
    return (listaPictogramas.length / elementosPorPagina).ceil();
  }
}
