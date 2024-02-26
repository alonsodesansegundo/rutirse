import 'package:flutter/material.dart';

class PreguntaWidget extends StatelessWidget {
  final String enunciado;
  final bool isLoading;
  final double subtextSize;
  final double imgWidth;
  final String personajeName;

  PreguntaWidget({
    required this.enunciado,
    required this.isLoading,
    required this.subtextSize,
    required this.imgWidth,
    required this.personajeName,
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
          Container(
            child: Image.asset(
              'assets/img/personajes/' + this.personajeName + '.png',
              width: imgWidth,
            ),
          ),
        ],
      ),
    );
  }
}
