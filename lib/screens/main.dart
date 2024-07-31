// lib/main.dart
import 'package:Rutirse/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/obj/terapeuta.dart';
import '../widgets/ImageTextButton.dart';
import 'common/home.dart';
import 'common/homeTerapeuta.dart';
import 'common/informacion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
        title: 'Rutirse',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  late int intentosPassword = 0;

  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgHeight,
      imgWidth,
      espacioAcercaDe,
      dialogTextSize,
      dialogTitleSize,
      maxWidth;

  late ImageTextButton btnRutinas, btnIronias, btnAnimo, btnTerapeuta, btnInfo;

  late StatefulBuilder passwordDialog, noPasswordDialog;

  late String terapeutaPassword, terapeutaPista;

  late TextEditingController _enterPasswordController = TextEditingController(),
      _createPasswordController = TextEditingController(),
      _confirmPasswordController = TextEditingController(),
      _pistaController = TextEditingController();

  late String _errorMessage = "";

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _createVariablesSize(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo
    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.height * 0.015;
    imgHeight = screenSize.height / 10;
    espacioAcercaDe = espacioAlto * 2;
    imgWidth = screenSize.width / 3 - espacioPadding * 2;
    dialogTitleSize = titleSize * 0.75;
    dialogTextSize = textSize * 0.85;
    maxWidth = MediaQuery.of(context).size.width * 0.8;
  }

  void _createButtons(BuildContext context) {
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
          MaterialPageRoute(builder: (context) => Home(juego: 'rutinas')),
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
                builder: (context) => Home(juego: 'sentimientos')),
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
          MaterialPageRoute(builder: (context) => Home(juego: 'humor')),
        );
      },
    );

    btnTerapeuta = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/terapeuta.png',
        width: imgWidth,
      ),
      text: Text(
        'Soy terapeuta',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        intentosPassword = 0;
        _errorMessage = "";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (terapeutaPassword == "")
              return noPasswordDialog;
            else
              return passwordDialog;
          },
        );
      },
    );

    btnInfo = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/info.png',
        width: imgWidth,
      ),
      text: Text(
        'Acerca de',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Informacion()),
        );
      },
    );
  }

  void _createDialogs(BuildContext context) {
    passwordDialog = StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Text(
            'Introducir contraseña',
            style: TextStyle(
              fontFamily: 'ComicNeue',
              fontSize: dialogTitleSize * 0.75,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Para poder iniciar como terapeuta debes de introducir la contraseña correspondiente.",
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: dialogTextSize,
                  ),
                ),
                TextField(
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: dialogTextSize,
                  ),
                  controller: _enterPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Introducir contraseña',
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
                        fontSize: textSize,
                      ),
                    ),
                  ),
                if (intentosPassword >= 3)
                  Container(
                    child: Row(
                      children: [
                        SizedBox(height: espacioAlto),
                        Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Text(
                            "PISTA: " + terapeutaPista,
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize,
                            ),
                          ),
                        ),
                      ],
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
                  onPressed: () {
                    _validateEnterPassword(setState, context);
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

    noPasswordDialog = StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Text(
            'Crear contraseña',
            style: TextStyle(
              fontFamily: 'ComicNeue',
              fontSize: dialogTitleSize,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Al ser la primera vez que inicias como terapeuta, debes de crear una contraseña.",
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: dialogTextSize,
                ),
              ),
              TextField(
                controller: _createPasswordController,
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: dialogTextSize,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
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
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
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
                controller: _pistaController,
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
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _validateCreatePassword(setState, context);
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

  // Método para obtener la contraseña de terapeuta
  Future<void> _getPassword() async {
    try {
      String aux = await getPassword();
      terapeutaPassword = aux;
    } catch (e) {
      print("Error al obtener la password de terapeuta: $e");
    }
  }

  // Método para obtener la contraseña de terapeuta
  Future<void> _getPista() async {
    try {
      String aux = await getPista();
      terapeutaPista = aux;
    } catch (e) {
      print("Error al obtener la pista de la contraseña de terapeuta: $e");
    }
  }

  void _validateEnterPassword(StateSetter setState, BuildContext context) {
    String enterPassword = _enterPasswordController.text;

    if (enterPassword != terapeutaPassword) {
      setState(() {
        _errorMessage = 'La contraseña es incorrecta';
        intentosPassword++;
      });
      _enterPasswordController.text = "";
    } else {
      _errorMessage = "";
      _enterPasswordController.text = "";

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeTerapeuta()),
      );
    }
  }

  void _validateCreatePassword(StateSetter setState, BuildContext context) {
    String password = _createPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String pista = _pistaController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Las contraseñas no pueden estar vacías';
      });
    } else if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Las contraseñas no coinciden';
      });
    } else if (pista.isEmpty) {
      setState(() {
        _errorMessage = 'La pista es obligatoria';
      });
    } else {
      updatePassword(password, pista);
      _errorMessage = "";
      _createPasswordController.text = "";
      _confirmPasswordController.text = "";

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeTerapeuta()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _createVariablesSize(context);
    _createButtons(context);
    _createDialogs(context);
    _getPassword();
    _getPista();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(espacioPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rutirse',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize,
                        ),
                      ),
                      Image.asset(
                        'assets/img/icon.png',
                        height: imgHeight,
                      ),
                    ],
                  ),
                  Text(
                    'Juegos de Habilidad Social',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: titleSize / 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio entre los textos
              // Explicación pantalla
              Text(
                '¡Hola! A continuación puedes elegir entre varios juegos. '
                'Con ellos queremos ayudarte a mejorar en diferentes situaciones '
                'que puedes encontrarte en tu día a día.\n'
                '¡Esperamos que disfrutes con esta experiencia!',
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
              SizedBox(height: espacioAlto), // Espacio entre los textos
              Text(
                '¿A qué te apetece jugar?',
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
              SizedBox(height: espacioAlto), // Espacio entre los textos
              Row(
                children: [btnRutinas, btnIronias, btnAnimo],
              ),

              SizedBox(height: espacioAcercaDe),
              Text(
                'Otras opciones:',
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
              SizedBox(height: espacioAlto),
              Row(
                children: [btnTerapeuta, btnInfo],
              )
            ],
          ),
        ),
      ),
    );
  }
}
