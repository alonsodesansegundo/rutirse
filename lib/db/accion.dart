class Accion {
  final int id;
  final String texto;
  final int orden;
  final String imagenPath;
  final int preguntaId;

  Accion(
      {required this.id,
      required this.texto,
      required this.orden,
      required this.imagenPath,
      required this.preguntaId});

  Accion.accionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        texto = item["texto"],
        orden = item["orden"],
        imagenPath = item["imagenPath"],
        preguntaId = item["preguntaId"];

  Map<String, Object> accionesToMap() {
    return {
      'id': id,
      'texto': texto,
      'orden': orden,
      'imagenPath': imagenPath,
      'preguntaId': preguntaId
    };
  }

  @override
  String toString() {
    return 'Accion {id: $id, texto: $texto, orden: $orden, imagenPath: $imagenPath, preguntaId: $preguntaId}';
  }
}
