import 'package:Rutirse/screens/common/removePlayer.dart';
import 'package:Rutirse/screens/sentimientos/menuTerapeutaSentimientos.dart';
import 'package:flutter/material.dart';

import '../../db/obj/terapeuta.dart';
import '../../widgets/ImageTextButton.dart';
import '../humor/menuTerapeutaHumor.dart';
import '../rutinas/menuTerapeutaRutinas.dart';

class HomeTerapeuta extends StatefulWidget {
  @override
  _HomeTerapeutaState createState() => _HomeTerapeutaState();
}

class _HomeTerapeutaState extends State<HomeTerapeuta> {
  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgVolverHeight,
      imgWidth,
      dialogTextSize,
      dialogTitleSize;

  late ImageTextButton btnVolver,
      btnRutinas,
      btnAnimo,
      btnIronias,
      btnRemovePlayer,
      btnChangePassword;

  late StatefulBuilder changePasswordDialog;

  late TextEditingController _enterPasswordController,
      _newPasswordController,
      _confirmPasswordController,
      _newPistaController;

  late String _errorMessage, terapeutaPassword;

  late bool loadData;

  @override
  void initState() {
    super.initState();
    loadData = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!loadData) {
      loadData = true;
      _createVariablesSize();
      _createButtons();
      _createDialogs();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(espacioPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rutirse',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize,
                        ),
                      ),
                      Text(
                        'Menú Terapeuta',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize / 2,
                        ),
                      ),
                    ],
                  ),
                  btnVolver,
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio entre los textos
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Como terapeuta tienes la posibilidad de acceder a los distintos juegos, ya '
                      'sea para añadir nuevas preguntas, modificar o eliminar preguntas existentes'
                      ' o consultar los datos de cualquier jugador para ver su progreso. '
                      'También puedes eliminar jugadores o cambiar la contraseña.',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto),
              Text(
                '¿A qué juego quieres acceder?',
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
              SizedBox(height: espacioAlto), // Espacio
              Row(
                children: [btnRutinas, btnIronias, btnAnimo],
              ),
              SizedBox(height: espacioAlto),
              Text(
                'Otras opciones:',
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
              SizedBox(height: espacioAlto), // Espacio

              Row(
                children: [btnRemovePlayer, btnChangePassword],
              )
            ],
          ),
        ),
      ),
    );
  }

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.height * 0.03;
    imgVolverHeight = screenSize.height / 32;
    imgWidth = screenSize.width / 3 - espacioPadding * 2;
    dialogTitleSize = titleSize * 0.5;
    dialogTextSize = textSize * 0.85;
  }

  // metodo para crear los botones necesarios
  void _createButtons() {
    btnRutinas = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/rutinas.png',
        width: imgWidth,
      ),
      text: Text(
        'Rutinas',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuTerapeuta()),
        );
      },
    );
    btnAnimo = ImageTextButton(
        image: Image.asset(
          'assets/img/botones/sentimientos.png',
          width: imgWidth,
        ),
        text: Text(
          'Sentimientos',
          style: TextStyle(
              fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuTerapeutaSentimientos()),
          );
        });

    btnIronias = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/humor.png',
        width: imgWidth,
      ),
      text: Text(
        'Humor',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuTerapeutaHumor()),
        );
      },
    );

    // boton para dar volver a la pantalla principal de rutinas
    btnVolver = ImageTextButton(
      image:
          Image.asset('assets/img/botones/home.png', height: imgVolverHeight),
      text: Text(
        'Volver',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    btnRemovePlayer = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/borrar.png',
        width: imgWidth,
      ),
      text: Text(
        'Eliminar\njugador',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RemovePlayer()),
        );
      },
    );

    btnChangePassword = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/contraseña.png',
        width: imgWidth,
      ),
      text: Text(
        'Cambiar\ncontraseña',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        _newPasswordController = TextEditingController();
        _confirmPasswordController = TextEditingController();
        _enterPasswordController = TextEditingController();
        _newPistaController = TextEditingController();

        _errorMessage = "";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return changePasswordDialog;
          },
        );
      },
    );
  }

  void _createDialogs() {
    changePasswordDialog = StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Text(
            'Cambiar contraseña',
            style: TextStyle(
              fontFamily: 'ComicNeue',
              fontSize: dialogTitleSize,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Debes introducir la contraseña actual y la nueva contraseña, además de una pista.",
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: dialogTextSize,
                  ),
                ),
                TextField(
                  controller: _enterPasswordController,
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: dialogTextSize,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña antigua',
                  ),
                ),
                SizedBox(
                  height: espacioAlto,
                ),
                TextField(
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: dialogTextSize,
                  ),
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña nueva',
                  ),
                ),
                TextField(
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: dialogTextSize,
                  ),
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Repetir contraseña nueva',
                  ),
                ),
                SizedBox(
                  height: espacioAlto,
                ),
                TextField(
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: dialogTextSize,
                  ),
                  controller: _newPistaController,
                  decoration: InputDecoration(
                    labelText: 'Pista para recordar contraseña',
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: espacioAlto),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'ComicNeue',
                        fontSize: dialogTextSize,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (await _validateChangePassword(setState)) {
                      Navigator.pop(context);
                      await updatePassword(_newPasswordController.text,
                          _newPistaController.text);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Contraseña cambiada',
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: dialogTitleSize,
                              ),
                            ),
                            content: Text(
                              'La contraseña ha sido cambiada con éxito.',
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: dialogTextSize,
                              ),
                            ),
                            actions: <Widget>[
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Aceptar',
                                    style: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontSize:
                                          dialogTextSize, // Cambia el color según tus preferencias
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: dialogTextSize,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: dialogTextSize,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _validateChangePassword(StateSetter setState) async {
    await _getPassword();
    if (terapeutaPassword != _enterPasswordController.text) {
      setState(() {
        _errorMessage = "Contraseña incorrecta";
      });
      return false;
    }
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      print("ERROR 1");

      setState(() {
        _errorMessage = "La nueva contraseña no puede ser vacía";
      });
      return false;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      print("ERROR 2");

      setState(() {
        _errorMessage = "Las nuevas contraseñas no coinciden";
      });
      return false;
    }
    if (_newPistaController.text.isEmpty) {
      print("ERROR 3");
      setState(() {
        _errorMessage = "La pista es obligatoria";
      });
      return false;
    }
    return true;
  }

  // Método para obtener la lista de grupos de la BBDD
  Future<void> _getPassword() async {
    try {
      String aux = await getPassword();
      setState(() {
        terapeutaPassword = aux;
      });
    } catch (e) {
      print("Error al obtener la password de terapeuta: $e");
    }
  }
}
