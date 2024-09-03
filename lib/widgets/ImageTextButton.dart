import 'package:flutter/material.dart';

///Widget propio que consiste en un botón formado por imagen (pictograma) y texto
class ImageTextButton extends StatefulWidget {
  final Image image;
  final Text text;
  final VoidCallback onPressed;
  Color buttonColor; // Nuevo parámetro para el color del botón

  ///Constructor de la clase ImageTextButton
  ImageTextButton({
    required this.image,
    required this.text,
    required this.onPressed,
    this.buttonColor = Colors.transparent, // Agregar el nuevo parámetro
  });

  @override
  _ImageTextButtonState createState() => _ImageTextButtonState();
}

/// Estado asociado al widget [ImageTextButton] que gestiona la lógica
/// y la interfaz de usuario del widget
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
