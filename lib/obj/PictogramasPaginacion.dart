import 'Pictograma.dart';

///Clase que nos permite obtener los Pictogramas de ARASAAC de manera paginada. Hecha para
///cuando un terapeuta busca un pictograma desde ARASAAC
class PictogramasPaginacion {
  List<Pictograma> listaPictogramas;
  int elementosPorPagina;
  int paginaActual;

  ///Constructor de la clase PictogramasPaginacion
  PictogramasPaginacion({
    required this.listaPictogramas,
    required this.elementosPorPagina,
  }) : paginaActual = 1;

  ///Método que nos permite obtener la nueva lista de pictogramas una vez cambiamos de página
  ///<br><b>Salida</b><br>
  ///La nueva lista de pictogramas, una vez cambiamos de página
  List<Pictograma> obtenerPictogramasPaginaActual() {
    final startIndex = (paginaActual - 1) * elementosPorPagina;
    final endIndex = startIndex + elementosPorPagina;

    // Asegúrate de que el índice final no exceda el tamaño de la lista
    final safeEndIndex = endIndex <= listaPictogramas.length
        ? endIndex
        : listaPictogramas.length;

    return listaPictogramas.sublist(startIndex, safeEndIndex);
  }

  ///Método que nos permite conocer si hay más páginas (para poder mostrar el botón Siguiente de ser necesario)
  ///<br><b>Salida</b><br>
  ///Valor booleano que es true si hay más páginas hacia adelante, false en caso contrario
  bool hayMasPaginas() {
    return paginaActual < calcularTotalPaginas();
  }

  ///Método que nos permite avanzar de página
  void irAPaginaSiguiente() {
    if (hayMasPaginas()) {
      paginaActual++;
    }
  }

  ///Método que nos permite retroceder de página
  void irAPaginaAnterior() {
    paginaActual--;
  }

  ///Método que calcula el número total de páginas
  ///<br><b>Salida</b><br>
  ///Número total de páginas
  int calcularTotalPaginas() {
    return (listaPictogramas.length / elementosPorPagina).ceil();
  }
}
