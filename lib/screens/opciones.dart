import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/obj/grupo.dart';
import '../db/obj/jugador.dart';
import '../provider/MyProvider.dart';
import '../widgets/ExitDialog.dart';
import '../widgets/ImageTextButton.dart';

class Opciones extends StatefulWidget {
  @override
  _OpcionesState createState() => _OpcionesState();
}

class _OpcionesState extends State<Opciones> {
  late bool loadProvider;
  late List<Grupo> gruposList; // lista de grupos obtenidos de la BBDD
  late String txtGrupo; // texto del grupo seleccionado
  late List<bool>
      btnGruposFlags; // para tener en cuenta que boton ha sido pulsado

  late String nombre;
  Grupo? selectedGrupo = null;

  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      imgHeight = 0.0,
      imgWidth = 0.0,
      imgVolverHeight = 0.0;

  // botones
  late ImageTextButton btnSeguir, btnSalir, btnConfirmar, btnAceptar;

  // cuadros de dialogo
  late ExitDialog exitDialog, confirmDialog;

  @override
  void initState() {
    super.initState();
    loadProvider = false;
    _getGrupos();
    gruposList = [];
    txtGrupo = "";
    btnGruposFlags = [false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createButtons();
    _createDialogs();

    // si es la primera vez, obtengo datos del provider
    if (!loadProvider) {
      loadProvider = true;
      var myProvider = Provider.of<MyProvider>(context);
      nombre = myProvider.jugador.nombre;
      selectedGrupo = myProvider.grupo;
      btnGruposFlags[selectedGrupo!.id - 1] = true;
      txtGrupo = selectedGrupo!.nombre;
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
                  Text(
                    'Opciones',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: titleSize,
                    ),
                  ),
                  ImageTextButton(
                    image: Image.asset(
                      'assets/img/botones/volver.png',
                      height: imgVolverHeight,
                    ),
                    text: Text(
                      'Volver',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // cuadro de dialogo
                          return exitDialog;
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio entre los textos
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Aquí puedes cambiar diferentes opciones para el juego \'Rutinas\'.\n'
                      'Estas opciones son tu nombre y el grupo al que perteneces.',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio
              // Fila para el nombre
              Row(
                children: [
                  Text(
                    'Nombre:',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(width: espacioAlto),
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        this.nombre = text;
                      },
                      decoration: InputDecoration(
                        hintText: nombre,
                        hintStyle: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: espacioAlto),
                ],
              ),
              SizedBox(height: espacioAlto),
              // Fila para el grupo
              Row(
                children: [
                  Text(
                    'Grupo:',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(width: espacioAlto + espacioAlto / 1.5),
                  Text(
                    txtGrupo,
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto),
              // Fila para los botones de seleccionar grupo
              Row(
                children: gruposList.isNotEmpty
                    ? gruposList.asMap().entries.map((entry) {
                        int index = entry.key;
                        Grupo grupo = entry.value;
                        return Row(
                          children: [
                            ImageTextButton(
                              image: Image.asset(
                                'assets/img/grupos/' +
                                    grupo.nombre.toLowerCase() +
                                    '.png',
                                width: imgWidth,
                                height: imgHeight,
                              ),
                              text: Text(
                                grupo.nombre + '\n' + grupo.edades,
                                style: TextStyle(
                                  fontFamily: 'ComicNeue',
                                  fontSize: textSize,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectGroup(index);
                                });
                              },
                              buttonColor: btnGruposFlags[index]
                                  ? Colors.grey
                                  : Colors.transparent,
                            ),
                            if (index < gruposList.length - 1)
                              SizedBox(width: espacioPadding),
                          ],
                        );
                      }).toList()
                    : [Center(child: Text('No hay grupos disponibles'))],
              ),
              SizedBox(height: espacioAlto),
              btnConfirmar,
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
      espacioPadding = screenSize.height * 0.02;
      espacioAlto = screenSize.height * 0.02;
      imgHeight = screenSize.height / 4;
      imgWidth = screenSize.width / 4;
      imgVolverHeight = screenSize.height / 10;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.height / 5;
      imgWidth = screenSize.width / 5;
      imgVolverHeight = screenSize.height / 32;
    }
  }

  // metodo para crear los cuadro de dialogos
  void _createDialogs() {
    // CUADROS DE DIALOGO
    // cuadro de dialogo para cuando quiere jugar pero los datos son incompletos
    exitDialog = ExitDialog(
        title: 'Aviso',
        titleSize: titleSize,
        content:
            "¿Estás seguro de que deseas salir de las opciones del juego 'Rutinas'? "
            "De esta manera los posibles cambios que hayas realizado no se guardarán "
            "y volverás al menú del juego \'Rutinas\'.",
        contentSize: textSize,
        leftImageTextButton: btnSeguir,
        rightImageTextButton: btnSalir,
        spaceRight: espacioPadding * 2);

    // cuadro de dialogo para informar de que se han cambiado las opciones
    confirmDialog = ExitDialog(
        title: 'Éxito',
        titleSize: titleSize,
        content:
            "Las opciones para el juego 'Rutinas' han sido actualizados con éxito.\n"
            "¡Muchas gracias por tu interés y colaboración!",
        contentSize: textSize,
        leftImageTextButton: btnAceptar);
  }

  // metodo para crear los botones necesarios

  void _createButtons() {
    // boton para seguir en opciones
    btnSeguir = ImageTextButton(
      image: Image.asset('assets/img/botones/opciones.png', width: imgWidth),
      text: Text(
        'Seguir en opciones',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // boton para salir de opciones
    btnSalir = ImageTextButton(
      image: Image.asset('assets/img/botones/salir.png', width: imgWidth),
      text: Text(
        'Salir',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // boton para confirmar los cambios
    btnConfirmar = ImageTextButton(
      image: Image.asset('assets/img/botones/fin.png',
          width: imgWidth, height: imgHeight),
      text: Text(
        'Confirmar cambios',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var myProvider = Provider.of<MyProvider>(context);
            Jugador jugador = new Jugador(
                nombre: nombre.toString(), grupoId: selectedGrupo!.id);
            insertJugador(jugador);
            myProvider.jugador = jugador;
            myProvider.grupo = selectedGrupo!;
            return confirmDialog;
          },
        );
      },
    );

    // boton para aceptar que se han actualizado las opciones
    btnAceptar = ImageTextButton(
      image: Image.asset('assets/img/botones/aceptar.png', width: imgWidth),
      text: Text(
        'Aceptar',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }

  // Método para obtener la lista de grupos de la BBDD
  Future<void> _getGrupos() async {
    try {
      List<Grupo> grupos = await getGrupos();
      setState(() {
        gruposList = grupos;
      });
    } catch (e) {
      print("Error al obtener la lista de grupos: $e");
    }
  }

  // Método para cuando se selecciona un grupo
  void _selectGroup(int index) {
    btnGruposFlags[index] = !btnGruposFlags[index]; // se actualiza su pulsación
    if (btnGruposFlags[index]) {
      // si está activado
      txtGrupo = gruposList[index].nombre; // se muestra el nombre
      selectedGrupo = gruposList[index]; // se actualiza el id seleccionado
      for (int i = 0; i < btnGruposFlags.length; i++) // pongo los demás a false
        if (index != i) btnGruposFlags[i] = false;
    } else {
      // si con la pulsación ha sido deseleccionado
      txtGrupo = "";
      selectedGrupo = null;
    }
  }
}
