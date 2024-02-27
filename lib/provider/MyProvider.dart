import 'package:flutter/material.dart';

import '../db/obj/grupo.dart';
import '../db/obj/jugador.dart';

class MyProvider with ChangeNotifier {
  late Jugador _jugador;
  late Grupo _grupo;

  // getters y setters varios
  Jugador get jugador => this._jugador;

  set jugador(Jugador jugador) {
    this._jugador = jugador; //actualizamos el valor
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  // getters y setters varios
  Grupo get grupo => this._grupo;

  set grupo(Grupo grupo) {
    this._grupo = grupo; //actualizamos el valor
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }
}
