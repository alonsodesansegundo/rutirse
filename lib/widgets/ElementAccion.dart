import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ElementAccion extends StatefulWidget {
  String text1;
  int numberAccion;
  double textSize;
  double espacioPadding;
  double espacioAlto;
  double btnWidth;
  double btnHeight;
  double textSituacionWidth;
  final Function() onPressedGaleria;
  final Function() onPressedArasaac;
  String accionText;
  XFile? accionImage;
  Color color;
  final TextEditingController accionTextController = TextEditingController();

  ElementAccion({
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
    this.accionImage = null,
    this.accionText = "",
    this.color = Colors.transparent,
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
            Container(
              width: widget.espacioPadding * 4,
              child: Text(
                widget.text1,
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: widget.textSize,
                ),
              ),
            ),
            Container(
              width: widget.btnWidth,
              height: widget.textSize * 4.5,
              child: TextField(
                controller: TextEditingController(text: widget.accionText),
                onChanged: (text) {
                  widget.accionText = text;
                },
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: widget.espacioAlto / 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              width: widget.espacioPadding * 4,
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
                    textStyle: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: widget.textSize,
                      color: Colors.blue,
                    ),
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
                    minimumSize: Size(widget.btnWidth, widget.btnHeight),
                    textStyle: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: widget.textSize,
                      color: Colors.blue,
                    ),
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
          ],
        ),
      ],
    );
  }
}
