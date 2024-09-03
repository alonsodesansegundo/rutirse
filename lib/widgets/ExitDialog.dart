import 'package:flutter/material.dart';

import 'ImageTextButton.dart';

///Widget que consiste en un cuadro de dialogo de salida de una pantalla
class ExitDialog extends StatefulWidget {
  final String title;
  final double titleSize;
  final String content;
  final double contentSize;
  final ImageTextButton leftImageTextButton;
  final ImageTextButton? rightImageTextButton; // Cambiado a tipo opcional
  final Image? optionalImage;

  ///Constructor de la clase ExitDialog
  ExitDialog({
    required this.title,
    required this.titleSize,
    required this.content,
    required this.contentSize,
    required this.leftImageTextButton,
    this.rightImageTextButton, // Cambiado a tipo opcional
    this.optionalImage, // Parámetro opcional
  });

  @override
  _ExitDialogState createState() => _ExitDialogState();
}

/// Estado asociado al widget [ExitDialog] que gestiona la lógica
/// y la interfaz de usuario del widget
class _ExitDialogState extends State<ExitDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: widget.titleSize,
        ),
      ),
      content: Row(
        children: [
          Expanded(
            child: Text(
              widget.content,
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: widget.contentSize,
              ),
            ),
          ),
          if (widget.optionalImage != null)
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: widget.optionalImage,
            ),
        ],
      ),
      actions: [
        Row(
          children: [
            widget.leftImageTextButton,
            Spacer(),
            if (widget.rightImageTextButton != null)
              widget.rightImageTextButton!,
          ],
        ),
      ],
    );
  }
}
