import 'package:flutter/material.dart';
import 'package:rutinas/widgets/ImageTextButton.dart';

class ExitDialog extends StatefulWidget {
  final String title;
  final double titleSize;
  final String content;
  final double contentSize;
  final ImageTextButton leftImageTextButton;
  final ImageTextButton rightImageTextButton;
  final double spaceRight;

  ExitDialog({
    required this.title,
    required this.titleSize,
    required this.content,
    required this.contentSize,
    required this.leftImageTextButton,
    required this.rightImageTextButton,
    required this.spaceRight,
  });

  @override
  _ExitDialogState createState() => _ExitDialogState();
}

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
      content: Text(
        widget.content,
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: widget.contentSize,
        ),
      ),
      actions: [
        Row(
          children: [
            widget.leftImageTextButton,
            Spacer(), // Añade un espacio para empujar el siguiente elemento hacia la derecha
            widget.rightImageTextButton,
            SizedBox(width: widget.spaceRight),
          ],
        ),
      ],
    );
  }
}
