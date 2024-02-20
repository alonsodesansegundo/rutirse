import 'package:flutter/material.dart';

class ImageTextButton extends StatefulWidget {
  final Image image;
  final Text text;
  final VoidCallback onPressed;
  Color buttonColor; // Nuevo parámetro para el color del botón

  ImageTextButton({
    required this.image,
    required this.text,
    required this.onPressed,
    this.buttonColor=Colors.transparent, // Agregar el nuevo parámetro
  });

  @override
  _ImageTextButtonState createState() => _ImageTextButtonState();
}

class _ImageTextButtonState extends State<ImageTextButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        primary: widget.buttonColor, // Usar el color proporcionado
        elevation: 0,
      ),
      child: Column(
        children: [
          widget.image,
          widget.text,
        ],
      ),
    );
  }
}
