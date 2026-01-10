import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class GameWorld extends PositionComponent {
  static const double worldWidth = 1000;
  static const double worldHeight = 800;

  GameWorld() : super(size: Vector2(worldWidth, worldHeight));

  @override
  void render(Canvas canvas) {
    // Draw background (desert/grass color)
    final bgPaint = Paint()..color = const Color(0xFF3D5A3D);
    canvas.drawRect(size.toRect(), bgPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawRect(size.toRect(), borderPaint);
  }
}
