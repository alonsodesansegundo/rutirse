import 'package:sqflite/sqflite.dart';

import '../db.dart';

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

Future<List<Grupo>> getGrupos() async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> gruposMap = await db.query('grupo');
    return gruposMap.map((map) => Grupo.gruposFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener grupos: $e");
    return [];
  }
}

Future<Grupo> getGrupoById(int groupId) async {
  final Database db = await initializeDB();
  final List<Map<String, dynamic>> grupoMap = await db.query(
    'grupo',
    where: 'id = ?',
    whereArgs: [groupId],
  );
  if (grupoMap.isNotEmpty) {
    return Grupo.gruposFromMap(grupoMap.first);
  } else {
    throw Exception(
        'No se encontró ningún grupo con el ID especificado: $groupId');
  }
}

void insertGrupos(Database database) async {
  await database.transaction((txn) async {
    txn.rawInsert(
        "INSERT INTO grupo (nombre, edades) VALUES ('Atención T.','4 - 7 años')");
    txn.rawInsert(
        "INSERT INTO grupo (nombre, edades) VALUES ('Infancia','8 - 11 años')");
    txn.rawInsert(
        "INSERT INTO grupo (nombre, edades) VALUES ('Adolescencia','12 - 17 años')");
  });
}
