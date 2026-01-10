import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'tank_game.dart';
import 'player_tank.dart';

enum PowerUpType {
  speedBoost,
  shield,
  rapidFire,
  healthPack,
}

class PowerUp extends PositionComponent with HasGameReference<TankGame>, CollisionCallbacks {
  final PowerUpType type;
  double _lifetime = 15.0; // Despawn after 15 seconds
  double _bobOffset = 0;

  PowerUp({
    required Vector2 position,
    required this.type,
  }) : super(position: position, size: Vector2(30, 30), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw power-up with different colors based on type
    final color = _getColor();
    final paint = Paint()..color = color;
    
    // Outer glow
    final glowPaint = Paint()
      ..color = color.withAlpha(100)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2 + _bobOffset), 18, glowPaint);
    
    // Main circle
    canvas.drawCircle(Offset(size.x / 2, size.y / 2 + _bobOffset), 12, paint);
    
    // Icon
    _drawIcon(canvas);
  }

  Color _getColor() {
    switch (type) {
      case PowerUpType.speedBoost:
        return Colors.yellow;
      case PowerUpType.shield:
        return Colors.blue;
      case PowerUpType.rapidFire:
        return Colors.orange;
      case PowerUpType.healthPack:
        return Colors.green;
    }
  }

  void _drawIcon(Canvas canvas) {
    final iconPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final center = Offset(size.x / 2, size.y / 2 + _bobOffset);
    
    switch (type) {
      case PowerUpType.speedBoost:
        // Lightning bolt
        final path = Path()
          ..moveTo(center.dx - 3, center.dy - 6)
          ..lineTo(center.dx + 2, center.dy - 1)
          ..lineTo(center.dx - 1, center.dy + 1)
          ..lineTo(center.dx + 4, center.dy + 6);
        canvas.drawPath(path, iconPaint);
        break;
      case PowerUpType.shield:
        // Shield shape
        canvas.drawCircle(center, 5, iconPaint);
        break;
      case PowerUpType.rapidFire:
        // Multiple bullets
        canvas.drawCircle(center.translate(-4, 0), 2, iconPaint..style = PaintingStyle.fill);
        canvas.drawCircle(center, 2, iconPaint);
        canvas.drawCircle(center.translate(4, 0), 2, iconPaint);
        break;
      case PowerUpType.healthPack:
        // Plus sign
        canvas.drawLine(center.translate(0, -4), center.translate(0, 4), iconPaint);
        canvas.drawLine(center.translate(-4, 0), center.translate(4, 0), iconPaint);
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Bobbing animation
    _bobOffset = sin(game.currentTime() * 3) * 3;
    
    // Lifetime countdown
    _lifetime -= dt;
    if (_lifetime <= 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is PlayerTank && other.isLocalPlayer) {
      _applyEffect(other);
      removeFromParent();
    }
  }

  void _applyEffect(PlayerTank player) {
    switch (type) {
      case PowerUpType.speedBoost:
        player.applySpeedBoost(5.0); // 5 second boost
        break;
      case PowerUpType.shield:
        player.applyShield(3.0); // 3 second shield
        break;
      case PowerUpType.rapidFire:
        player.applyRapidFire(5.0); // 5 second rapid fire
        break;
      case PowerUpType.healthPack:
        player.heal(1);
        break;
    }
  }
}
