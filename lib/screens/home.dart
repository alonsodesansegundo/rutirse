import 'package:flutter/material.dart';

import '../db/db.dart';
import '../db/grupos.dart';
import '../widgets/ImageTextButton.dart';
import 'ayuda.dart';
import 'jugar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Grupos> gruposList = [];
  @override
  void initState() {
    super.initState();
    fetchGrupos();
  }

  Future<void> fetchGrupos() async {
    try {
      List<Grupos> grupos = await getGrupos();
      setState(() {
        gruposList = grupos;
      });
    } catch (e) {
      print("Error al obtener la lista de grupos: $e");
    }
  }

  String txtGrupo = ""; // texto del grupo seleccionado
  List<bool> btnGrupos = [
    false,
    false,
    false
  ]; // para tener en cuenta que boton ha sido pulsado
  List<String> txtGrupos = [
    "Atención T.",
    "Infancia",
    "Adolescencia"
  ]; // textos correspondientes a los botones

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    double titleSize = screenSize.width * 0.10;
    double textSize = screenSize.width * 0.03;

    double espacioPadding = screenSize.height * 0.03;
    double espacioAlto = screenSize.height * 0.03;

    double imgHeight = screenSize.height / 5;
    double imgWidth = screenSize.width / 5;
    TextEditingController _nombre = TextEditingController();

    void selectGroup(int index) {
      btnGrupos[index] = !btnGrupos[index];
      if (btnGrupos[index]) {
        txtGrupo = txtGrupos[index];
        for (int i = 0; i < btnGrupos.length; i++)
          if (index != i) btnGrupos[i] = false;
      } else
        txtGrupo = "";
    }

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(espacioPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rutinas',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                Text(
                  'Antes de empezar, ¿puedes decirnos tu nombre y de qué grupo eres? '
                  'Esto nos va a ayudar a seguir tu progreso. '
                  '¡Muchas gracias!',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
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
                        controller: _nombre,
                        decoration: InputDecoration(
                          hintText: 'Introduce tu nombre',
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
              Row(
                children: gruposList.isNotEmpty
                    ? gruposList.asMap().entries.map((entry) {
                  int index = entry.key;
                  Grupos grupo = entry.value;
                  return Row(
                    children: [
                      ImageTextButton(
                        image: Image.asset(
                          'assets/img/grupos/' + grupo.name.toLowerCase() + '.png',
                          width: imgWidth,
                          height: imgHeight,
                        ),
                        text: Text(
                          grupo.name+'\n'+grupo.edades,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectGroup(index);
                          });
                        },
                        buttonColor: btnGrupos[index] ? Colors.grey : Colors.transparent,
                      ),
                      if (index < gruposList.length - 1) SizedBox(width: espacioPadding),
                    ],
                  );
                }).toList()
                    : [Center(child: Text('No hay grupos disponibles'))],
              ),

              SizedBox(height: espacioAlto),
                Row(
                  children: [
                    ImageTextButton(
                      image: Image.asset('assets/img/botones/jugar.png',
                          width: imgWidth, height: imgHeight),
                      text: Text(
                        'Jugar',
                        style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Jugar()),
                        );
                      },
                    ),
                    SizedBox(width: espacioAlto),
                    ImageTextButton(
                      image: Image.asset('assets/img/botones/ayuda.png',
                          width: imgWidth, height: imgHeight),
                      text: Text(
                        'Ayuda',
                        style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Ayuda(origen: 'home')),
                        );
                      },
                    ),
                    SizedBox(width: espacioAlto),
                    ImageTextButton(
                      image: Image.asset('assets/img/botones/terapeuta.png',
                          width: imgWidth, height: imgHeight),
                      text: Text(
                        'Terapeuta',
                        style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black),
                      ),
                      onPressed: () {
                        // Acción al presionar el botón
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
