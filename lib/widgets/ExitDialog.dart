import 'package:flutter/material.dart';
import 'package:rutinas/widgets/ImageTextButton.dart';

class ExitDialog extends StatefulWidget {
  final Text title;
  final Text content;
  final ImageTextButton leftImageTextButton;
  final ImageTextButton rightImageTextButton;
  final double spaceRight;

  ExitDialog({
    required this.title,
    required this.content,
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
      title: widget.title,
      content: widget.content,
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
