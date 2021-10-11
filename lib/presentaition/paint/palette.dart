import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:touchdown/presentaition/paint/brush_model.dart';

class Palette extends StatelessWidget {
  static const colors = [
    Colors.white,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<BrushModel>(context);
    return Container(
      height: 50,
      child: ListView.builder(
        // 色が増えたときに横スクロール、とりあえずこのまま
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final c = colors[index];
          return GestureDetector(
            onTap: () {
              pen.color = c;
            },
            child: color(c, c == pen.color),
          );
        },
      ),
    );
  }

  Widget color(Color color, bool selected) {
    return Container(
      height: 50,
      width: 45,
      child: Center(
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            // カラー円周りのボーダー
            border: Border.all(
              width: selected ? 3 : 1,
            ),
          ),
        ),
      ),
    );
  }
}
