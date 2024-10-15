import 'package:Rutirse/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/obj/terapeuta.dart';
import '../widgets/ImageTextButton.dart';
import 'common/home.dart';
import 'common/homeTerapeuta.dart';
import 'common/informacion.dart';

///Constante para darle un valor de duración (en ms) a la animación de desplazamiento
const int myDurationMS = 350;

///Constante para darle un valor a la velocidad de desplazamiento
const double myScrollSpeed = 25;

///Método que se corresponde con el punto de partida o inicial de la aplicación
void main() {
  runApp(MyApp());
}

///Clase principal de la aplicación, la que se lanza al comienzo
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

/// Pantalla principal de la aplicación.
class MyHomePage extends StatelessWidget {
  late int intentosPassword = 0;

  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgHeight,
      imgWidth,
      espacioAcercaDe,
      maxWidth;

  late ImageTextButton btnRutinas, btnIronias, btnAnimo, btnTerapeuta, btnInfo;

  late StatefulBuilder passwordDialog, noPasswordDialog;

  late String terapeutaPassword, terapeutaPista;

  late TextEditingController _enterPasswordController = TextEditingController(),
      _createPasswordController = TextEditingController(),
      _confirmPasswordController = TextEditingController(),
      _pistaController = TextEditingController();

  late String _errorMessage = "";

  ///Método que se utiliza para darle valor a las variables relacionadas con tamaños de fuente, imágenes, etc.
  ///<br><b>Parámetros</b><br>
  ///[context] El contexto de la aplicación, que proporciona acceso a información
  ///sobre el entorno en el que se está ejecutando el widget, incluyendo el tamañode la pantalla
  void _createVariablesSize(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo
    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.width * 0.03;
    imgHeight = screenSize.height / 10;
    espacioAcercaDe = espacioAlto * 2;
    imgWidth = screenSize.width / 3 - espacioPadding * 2;
    maxWidth = MediaQuery.of(context).size.width * 0.8;
  }

  ///Método encargado de inicializar los botones que tendrá la pantalla
  ///<br><b>Parámetros</b><br>
  ///[context] El contexto de la aplicación, que proporciona acceso a información
  ///sobre el entorno en el que se está ejecutando el widget, incluyendo el tamañode la pantalla
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

  ///Método encargado de inicializar los cuadros de dialogo que tendrá la pantalla
  ///<br><b>Parámetros</b><br>
  ///[context] El contexto de la aplicación, que proporciona acceso a información
  ///sobre el entorno en el que se está ejecutando el widget, incluyendo el tamañode la pantalla
  void _createDialogs(BuildContext context) {
    passwordDialog = StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Text(
            'Introducir contraseña',
            style: TextStyle(
              fontFamily: 'ComicNeue',
              fontSize: titleSize * 0.75,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Para poder iniciar como terapeuta debes de introducir la contraseña correspondiente.",
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
              TextField(
                controller: _enterPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Introduce la contraseña',
                  hintStyle: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
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
                      fontSize: textSize,
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
                      fontSize: textSize,
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
              fontSize: titleSize,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Al ser la primera vez que inicias como terapeuta, debes de crear una contraseña.",
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
              TextField(
                controller: _createPasswordController,
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
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
                  fontSize: textSize,
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
                  fontSize: textSize,
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
                      fontSize: textSize,
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
                      fontSize: textSize,
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
                      fontSize: textSize,
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

  ///Método que nos permite obtener la contraseña de terapeuta y almacenarla en la variable [terapeutaPassword]
  Future<void> _getPassword() async {
    try {
      String aux = await getPassword();
      terapeutaPassword = aux;
    } catch (e) {
      print("Error al obtener la password de terapeuta: $e");
    }
  }

  ///Método que nos permite obtener la pista de la contraseña y almacenarla en la variable [terapeutaPista]
  Future<void> _getPista() async {
    try {
      String aux = await getPista();
      terapeutaPista = aux;
    } catch (e) {
      print("Error al obtener la pista de la contraseña de terapeuta: $e");
    }
  }

  ///Método que nos permite comprobar si la contraseña introducida es correcta o no.<br>
  ///En caso de ser incorrecta se guarda el mensaje correspondiente en [_errorMessage], de ser correcta pasamos a la pantalla [HomeTerapeuta]
  ///<br><b>Parámetros</b><br>
  ///[setState] Función proporcionada por Flutter que permite actualizar el estado del widget asociado.
  /// Se usa para mostrar el mensaje de error y aumentar el contador de intentos si la contraseña es incorrecta.<br>
  ///[context] El contexto de la aplicación, usado para la navegación entre pantallas
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

  ///Método encargado de comprobar que a la hora de crear una contraseña se realiza correctamente, de no ser así se mostrará el
  ///[_errorMessage] adecuado a dicho error. En caso de crearla correctamente seremos redirigidos a [HomeTerapeuta]
  ///<br><b>Parámetros</b><br>
  ///[setState] Función proporcionada por Flutter que permite actualizar el estado del widget asociado.
  /// Se usa para mostrar el mensaje de error<br>
  ///[context] El contexto de la aplicación, usado para la navegación entre pantallas
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
                children: [btnRutinas],
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
