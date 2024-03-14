import 'dart:typed_data';

import 'package:flutter/material.dart';

class PreguntaWidget extends StatelessWidget {
  final String enunciado;
  final bool isLoading;
  final double subtextSize;
  final double imgHeight;
  final Uint8List? personajeImg;
  final double rightSpace;

  PreguntaWidget({
    required this.enunciado,
    required this.isLoading,
    required this.subtextSize,
    required this.imgHeight,
    this.personajeImg,
    required this.rightSpace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8.0),
              child: Text(
                isLoading ? "Cargando..." : enunciado,
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: subtextSize,
                ),
              ),
            ),
          ),
          if (personajeImg != null)
            Container(
              child: Image.memory(personajeImg!),
              height: imgHeight,
            ),
          SizedBox(width: rightSpace),
        ],
      ),
    );
  }
}
