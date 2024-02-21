class Grupo {
  final int id;
  final String nombre;
  final String edades;

  Grupo({required this.id, required this.nombre, required this.edades});

  Grupo.gruposFromMap(Map<String, dynamic> item)
      : id = item["id"],
        nombre = item["nombre"],
        edades = item["edades"];

  Map<String, Object> gruposToMap() {
    return {'id': id, 'nombre': nombre, 'edades': edades};
  }

  @override
  String toString() {
    return 'Grupo {id: $id, name: $nombre, edades: $edades}';
  }
}
