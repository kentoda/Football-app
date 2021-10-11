import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:touchdown/presentaition/paint/brush_model.dart';

class StrokesModel extends ChangeNotifier {
  List<Stroke> _strokes = [];

  get all => _strokes;

  void add(BrushModel pen, Offset offset) {
    _strokes.add(Stroke(pen.color)..add(offset));
    notifyListeners();
  }

  void update(Offset offset) {
    _strokes.last.add(offset);
    print("描画かいし");
    notifyListeners();
  }

  void clear() {
    _strokes = [];
    notifyListeners();
    print("消したよ💕");
  }
}

class Stroke {
  final List<Offset> points = [];
  final Color color;

  Stroke(this.color);

  add(Offset offset) {
    points.add(offset);
  }
}
