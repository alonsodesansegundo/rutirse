class Pregunta {
  final int id;
  final String enunciado;
  final String personajePath;
  final int grupoId;
  final int partidaId;

  Pregunta(
      {required this.id,
      required this.enunciado,
      required this.personajePath,
      required this.grupoId,
      required this.partidaId});

  Pregunta.preguntasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        personajePath = item["personajePath"],
        grupoId = item["grupoId"],
        partidaId = item["partidaId"];

  Map<String, Object> preguntasToMap() {
    return {
      'id': id,
      'enunciado': enunciado,
      'personajePath': personajePath,
      'grupoId': grupoId,
      'partidaId': partidaId
    };
  }

  @override
  String toString() {
    return 'Pregunta {id: $id, enunciado: $enunciado, personajePath: $personajePath, '
        'grupoId: $grupoId, partidaId: $partidaId}';
  }
}
