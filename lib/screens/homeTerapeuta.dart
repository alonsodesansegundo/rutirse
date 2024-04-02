import 'package:TresEnUno/screens/rutinas/menuTerapeuta.dart';
import 'package:flutter/material.dart';

import '../../widgets/ImageTextButton.dart';
import '../db/obj/terapeuta.dart';

class HomeTerapeuta extends StatefulWidget {
  @override
  _HomeTerapeutaState createState() => _HomeTerapeutaState();
}

class _HomeTerapeutaState extends State<HomeTerapeuta> {
  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      imgVolverHeight = 0.0,
      imgWidth = 0.0,
      dialogTextSize = 0.0,
      dialogTitleSize = 0.0;

  late ImageTextButton btnVolver,
      btnRutinas,
      btnAnimo,
      btnIronias,
      btnChangePassword;

  late StatefulBuilder changePasswordDialog;

  late TextEditingController _enterPasswordController,
      _newPasswordController,
      _confirmPasswordController;

  late String _errorMessage, terapeutaPassword;

  late bool flag = false;

  @override
  void initState() {
    super.initState();
    flag = false;
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createButtons();
    _createDialogs();
    if (!flag) {
      flag = true;
      _newPasswordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
      _enterPasswordController = TextEditingController();
      _errorMessage = "";
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
                        'TresEnUno',
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
                      'sea para añadir nuevas preguntas, modificar o eliminar preguntas añadidas'
                      ' por terapeutas o consultar los datos de cualquier jugador para ver su progreso. ',
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
                children: [btnRutinas, btnAnimo, btnIronias],
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
                children: [btnChangePassword],
              )
            ],
          ),
        ),
      ),
    );
  }

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _updateVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal) {
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.06;
      espacioAlto = screenSize.height * 0.03;
      imgVolverHeight = screenSize.height / 10;
      imgWidth = screenSize.width / 6 - espacioPadding * 2;
      dialogTitleSize = titleSize * 0.35;
      dialogTextSize = textSize * 0.45;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgVolverHeight = screenSize.height / 32;
      imgWidth = screenSize.width / 3 - espacioPadding * 2;
      dialogTitleSize = titleSize * 0.75;
      dialogTextSize = textSize * 0.85;
    }
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
        onPressed: () {});

    btnIronias = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/ironias.png',
        width: imgWidth,
      ),
      text: Text(
        'Ironías',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {},
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
                  "Debes introducir la contraseña actual y la nueva contraseña.",
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
                      await updatePassword(_newPasswordController.text);
                      flag = false;
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
                    flag = false;
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
      setState(() {
        _errorMessage = "La nueva contraseña no puede ser vacía";
      });
      return false;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Las nuevas contraseñas no coinciden";
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
