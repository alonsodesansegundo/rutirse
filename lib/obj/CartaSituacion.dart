import 'package:flutter/material.dart';

import '../db/obj/situacion.dart';

class CartaSituacion {
  final Situacion situacion;
  bool selected;
  Color backgroundColor;

  CartaSituacion({
    required this.situacion,
    this.selected = false,
    this.backgroundColor = Colors.transparent,
  });
}
