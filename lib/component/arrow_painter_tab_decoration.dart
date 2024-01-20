import 'package:flutter/material.dart';

class ArrowDownTabBarIndicator extends Decoration {
  final BoxPainter _painter;
  ArrowDownTabBarIndicator(
      {double width = 20, double height = 10, required Color color})
      : _painter = _ArrowDownPainter(width, height, color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _ArrowDownPainter extends BoxPainter {
  final Paint _paint;
  final double width;
  final double height;
  final Color color;

  _ArrowDownPainter(this.width, this.height, this.color)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    Path trianglePath = Path();
    if (cfg.size != null) {
      Offset centerBottom =
          Offset(cfg.size!.width / 2, cfg.size!.height + height) + offset;
      Offset topLeft =
          Offset(cfg.size!.width / 2 - (width / 2), cfg.size!.height) + offset;
      Offset topRight =
          Offset(cfg.size!.width / 2 + (width / 2), cfg.size!.height) + offset;

      trianglePath.moveTo(topLeft.dx, topLeft.dy);
      trianglePath.lineTo(topRight.dx, topRight.dy);
      trianglePath.lineTo(centerBottom.dx, centerBottom.dy);
      trianglePath.lineTo(topLeft.dx, topLeft.dy);

      trianglePath.close();
      canvas.drawPath(trianglePath, _paint);
    }
  }
}
