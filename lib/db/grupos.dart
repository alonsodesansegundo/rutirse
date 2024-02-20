class Grupos{
  final int id;
  final String name;
  final String edades;


  Grupos({required this.id, required this.name, required this.edades});

  Grupos.gruposFromMap(Map<String, dynamic> item)
      : id = item["id"],
        name = item["name"],
        edades = item["edades"];

  Map<String, Object> gruposToMap() {
    return {'id': id, 'name': name, 'edades':edades};
  }

  @override
  String toString() {
    return 'Grupos {id: $id, name: $name, edades: $edades}';
  }
}