import 'dart:ui';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SketchPath {
  const SketchPath({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.color,
    required this.thickness,
  });

  factory SketchPath.fromMap(Map<String, dynamic> map) {
    return SketchPath(
      x1: map['x1'] as double,
      y1: map['y1'] as double,
      x2: map['x2'] as double,
      y2: map['y2'] as double,
      color: colorFromHex(map['color'] as String)!,
      thickness: map['thickness'] as double,
    );
  }

  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final Color color;
  final double thickness;

  Map<String, dynamic> toMap() {
    return {
      'x1': x1,
      'y1': y1,
      'x2': x2,
      'y2': y2,
      'color': colorToHex(color),
      'thickness': thickness,
    };
  }
}
