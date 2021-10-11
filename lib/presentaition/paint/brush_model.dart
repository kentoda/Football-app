import 'package:flutter/widgets.dart';

class BrushModel extends ChangeNotifier {
  Color _color = Color(0xff000000);
  double _width = 3;

  Color get color => _color;
  set color(Color color) {
    _color = color;
    notifyListeners();
  }

  double get width => _width;
  set width(double width) {
    _width = width;
    notifyListeners();
  }
}
