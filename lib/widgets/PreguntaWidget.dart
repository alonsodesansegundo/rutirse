import 'package:flutter/material.dart';

class PreguntaWidget extends StatelessWidget {
  final String enunciado;
  final bool isLoading;
  final double subtextSize;
  final double imgHeight;
  final String personajePath;
  final double rightSpace;

  PreguntaWidget({
    required this.enunciado,
    required this.isLoading,
    required this.subtextSize,
    required this.imgHeight,
    required this.personajePath,
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
          Container(
            child: Image.asset(
              personajePath,
              height: imgHeight,
            ),
          ),
          SizedBox(width: rightSpace),
        ],
      ),
    );
  }
}
