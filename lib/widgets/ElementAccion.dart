import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ElementAccion extends StatefulWidget {
  int? id;
  String text1;
  int numberAccion;
  double textSize;
  double espacioPadding;
  double espacioAlto;
  double btnWidth;
  double btnHeight;
  double textSituacionWidth;
  double imgWidth;
  final Function() onPressedGaleria;
  final Function() onPressedArasaac;
  String accionText;
  List<int> accionImage;
  Color color;
  final TextEditingController accionTextController = TextEditingController();
  bool flagAdolescencia;

  ElementAccion({
    this.id = -1,
    required this.text1,
    required this.numberAccion,
    required this.textSize,
    required this.espacioPadding,
    required this.espacioAlto,
    required this.btnWidth,
    required this.btnHeight,
    required this.textSituacionWidth,
    required this.onPressedGaleria,
    required this.onPressedArasaac,
    required this.imgWidth,
    this.accionText = "",
    this.accionImage = const [],
    this.color = Colors.transparent,
    this.flagAdolescencia = false,
  });

  @override
  _ElementAccionState createState() => _ElementAccionState();
}

class _ElementAccionState extends State<ElementAccion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (!widget.flagAdolescencia)
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: widget.espacioPadding,
                        child: Text(
                          widget.text1,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: widget.textSize,
                          ),
                        ),
                      ),
                      Container(
                        width: widget.espacioPadding,
                        child: Text(
                          "(máx. 30 caracteres)",
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: widget.textSize * 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: widget.btnWidth * 1.75,
                    height: widget.textSize * 4.5,
                    child: TextField(
                      controller:
                          TextEditingController(text: widget.accionText),
                      onChanged: (text) {
                        widget.accionText = text;
                      },
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: widget.textSize,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: widget.espacioAlto / 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              width: widget.espacioPadding,
              child: Text(
                'Imagen \nacción ' + widget.numberAccion.toString() + "*:",
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: widget.textSize,
                ),
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(widget.btnWidth, widget.btnHeight),
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: Text(
                    'Acción\n(desde galería)',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: widget.textSize,
                    ),
                  ),
                  onPressed: widget.onPressedGaleria,
                ),
                SizedBox(height: widget.espacioAlto / 3),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    minimumSize: Size(widget.btnWidth, widget.btnHeight),
                  ),
                  child: Text(
                    'Acción\n(desde ARASAAC)',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: widget.textSize,
                    ),
                  ),
                  onPressed: widget.onPressedArasaac,
                ),
              ],
            ),
            if (widget.accionImage.isNotEmpty)
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: widget.espacioAlto,
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.memory(
                            Uint8List.fromList(widget.accionImage),
                            width: widget.imgWidth,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
          ],
        ),
      ],
    );
  }
}
