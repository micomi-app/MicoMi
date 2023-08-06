import 'package:flutter/material.dart';

Color withNewHue(Color color, double hue) {
  return HSLColor.fromColor(color).withHue(hue).toColor();
}

double getHue(Color color) {
  return HSLColor.fromColor(color).hue;
}

ColorScheme theme(BuildContext context) {
  return Theme.of(context).colorScheme;
}

Color? toSecondaryColorSL(BuildContext context, Color? color) {
  if (color == null) return null;
  return withNewHue(theme(context).secondary, getHue(color));
}