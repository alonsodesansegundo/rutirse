import 'package:flutter/material.dart';

import '../widgets/ImageTextButton.dart';
import 'ayuda.dart';
import 'jugar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  children: [
                    ImageTextButton(
                      text: Text(
                        'Atención T.\n4 - 7 años',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                          color: Colors.black,
                        ),
                      ),
                      image: Image.asset('assets/img/grupos/atenciónT.png',
                          width: imgWidth, height: imgHeight),
                      onPressed: () {
                        setState(() {
                          selectGroup(0);
                        });
                      },
                      buttonColor: btnGrupos[0]
                          ? Colors.grey
                          : Colors.transparent, // Pasar el color al widget
                    ),
                    SizedBox(width: espacioAlto),
                    ImageTextButton(
                      text: Text(
                        'Infancia\n'
                        '7 - 11 años',
                        style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black),
                      ),
                      image: Image.asset('assets/img/grupos/infancia.png',
                          width: imgWidth, height: imgHeight),
                      onPressed: () {
                        setState(() {
                          selectGroup(1);
                        });
                      },
                      buttonColor: btnGrupos[1]
                          ? Colors.grey
                          : Colors.transparent, // Pasar el color al widget
                    ),
                    SizedBox(width: espacioAlto),
                    ImageTextButton(
                      text: Text(
                        'Adolescencia\n'
                        '12 - 17 años',
                        style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black),
                      ),
                      image: Image.asset('assets/img/grupos/adolescentes.png',
                          width: imgWidth, height: imgHeight),
                      onPressed: () {
                        setState(() {
                          selectGroup(2);
                        });
                      },
                      buttonColor: btnGrupos[2]
                          ? Colors.grey
                          : Colors.transparent, // Pasar el color al widget
                    ),
                  ],
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
                          MaterialPageRoute(builder: (context) => Ayuda(origen: 'home')),
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