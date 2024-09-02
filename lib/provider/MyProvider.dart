import 'package:flutter/material.dart';

import '../db/obj/grupo.dart';
import '../db/obj/jugador.dart';

///Clase MyProvider de la aplicación, para almacenar de manera eficiente y rápida datos de uso (jugador y grupo)
class MyProvider with ChangeNotifier {
  late Jugador _jugador;
  late Grupo _grupo;

  ///Getter de jugador
  Jugador get jugador => this._jugador;

  ///Setter de jugador
  set jugador(Jugador jugador) {
    this._jugador = jugador; //actualizamos el valor
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  ///Getter de grupo
  Grupo get grupo => this._grupo;

  ///Setter de grupo
  set grupo(Grupo grupo) {
    this._grupo = grupo; //actualizamos el valor
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }
}
