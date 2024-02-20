import 'package:flutter/material.dart';

class Ayuda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double titleSize = screenSize.width * 0.10;
    double textSize = screenSize.width * 0.04;
    double subtextSize = screenSize.width * 0.035;
    double espacioAlto = screenSize.height * 0.03;

    double espacioPadding = screenSize.height * 0.03;
    double imgHeight = screenSize.height * 0.15;
    double imgWidth = screenSize.width / 5;

    return MaterialApp(
      home: Scaffold(
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
                      'Ayuda',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: titleSize,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/img/botones/volver.png',
                        height: imgWidth / 3,
                        width: imgWidth / 3,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                Row(
                  children: [
                    Expanded(child:
                    Text(
                      'Aquí descubrirás como jugar a \'Rutinas\', '
                          'juego que consiste en ordenar las acciones. '
                          '\nAquí tienes un ejemplo:',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),)
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Por favor, pon en orden lo que tiene que hacer Pepe para lavarse los dientes.',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),

                    Image.asset(
                      'assets/img/personajes/cerdo.png',
                      height: imgHeight * 1.3,
                      width: imgWidth * 1.3,
                    ),
                  ],
                ),
                // AYUDA 1
                Row(
                  children: [
                    // Echar pasta de dientes
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/acciones/2.LavarDientes.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        Text(
                          'Echar pasta \nde dientes.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: subtextSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: imgWidth),
                    // Coger cepillo
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/img/acciones/1.LavarDientes.png',
                            height: imgHeight,
                            width: imgWidth,
                          ),
                          Text(
                            'Coger cepillo.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: subtextSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto/2), // Espacio entre los textos
                Text('Para ordenar correctamente, comencemos pulsando en la acción \'Coger cepillo\'.',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto*2), // Espacio entre los textos
                // AYUDA 2
                Row(
                  children: [
                    // Echar pasta de dientes
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/img/acciones/2.LavarDientes.png',
                            height: imgHeight,
                            width: imgWidth,
                          ),
                          Text(
                            'Echar pasta \nde dientes.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: subtextSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Coger cepillo
                    SizedBox(width: imgWidth),
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/acciones/1.LavarDientes.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        Text(
                          'Coger cepillo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: subtextSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto/2), // Espacio entre los textos

                Text('Después de elegir la acción \'Coger cepillo\', '
                    'pulsamos en su posición correcta, '
                    'que en este caso es la acción \'Echar pasta de dientes\'.',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),

                SizedBox(height: espacioAlto*2), // Espacio entre los textos
                Row(
                  children: [
                    // Echar pasta de dientes
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/acciones/2.LavarDientes.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        Text(
                          'Echar pasta \nde dientes.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: subtextSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: imgWidth),
                    //Coger cepillo
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/acciones/1.LavarDientes.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        Text(
                          'Coger cepillo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: subtextSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto/2), // Espacio entre los textos
                Text('Ahora las acciones están en el orden correcto.'
                    '\n¡Muchas gracias por tu atención!',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
