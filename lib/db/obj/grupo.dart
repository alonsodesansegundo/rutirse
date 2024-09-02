import 'package:sqflite/sqflite.dart';

import '../db.dart';

///Clase relativa a la tabla Grupo
class Grupo {
  final int id;
  final String nombre;
  final String edades;

  ///Constructor de la clase Grupo
  Grupo({required this.id, required this.nombre, required this.edades});

  ///Crea una instancia de Grupo a partir de un mapa de datos, dicho mapa debe contener: id, nombre y edades
  Grupo.gruposFromMap(Map<String, dynamic> item)
      : id = item["id"],
        nombre = item["nombre"],
        edades = item["edades"];

  ///Convierte una instancia de Grupo a un mapa de datos
  Map<String, Object> gruposToMap() {
    return {'id': id, 'nombre': nombre, 'edades': edades};
  }

  ///Sobreescritura del método equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Grupo &&
        other.id == id &&
        other.nombre == nombre &&
        other.edades == edades;
  }

  ///Sobreescritura del método hashCode
  @override
  int get hashCode => id.hashCode ^ nombre.hashCode ^ edades.hashCode;

  ///Sobreescritura del método toString
  @override
  String toString() {
    return 'Grupo {id: $id, name: $nombre, edades: $edades}';
  }
}

///Método que se encarga de obtener los resultados de la tabla Grupo
///<br><b>Parámetros</b><br>
///@params database Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///@returns La lista de grupos existentes
Future<List<Grupo>> getGrupos([Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    final List<Map<String, dynamic>> gruposMap = await database.query('grupo');
    return gruposMap.map((map) => Grupo.gruposFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener grupos: $e");
    return [];
  }
}

///Método que nos permite obtener un objeto Grupo dado un id
///<br><b>Parámetros</b><br>
///[groupId] Identificador del grupo que queremos obtener<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
Future<Grupo> getGrupoById(int groupId, [Database? db]) async {
  // Usa el parámetro db proporcionado o inicializa uno nuevo si db es null
  final Database database = db ?? await initializeDB();

  // Realiza la consulta en la base de datos
  final List<Map<String, dynamic>> grupoMap = await database.query(
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

///Método que se encarga de hacer la insercción de grupos que están presentes inicialmente
///<br><b>Parámetros</b><br>
///@params database Objeto Database sobre la cual se ejecutan las insercciones
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
