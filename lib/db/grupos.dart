class Grupo{
  final int id;
  final String name;
  final String edades;


  Grupo({required this.id, required this.name, required this.edades});

  Grupo.gruposFromMap(Map<String, dynamic> item)
      : id = item["id"],
        name = item["name"],
        edades = item["edades"];

  Map<String, Object> gruposToMap() {
    return {'id': id, 'name': name, 'edades':edades};
  }

  @override
  String toString() {
    return 'Grupo {id: $id, name: $name, edades: $edades}';
  }
}