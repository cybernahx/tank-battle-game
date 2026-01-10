import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'tank_game.dart';

class Obstacle extends SpriteComponent with HasGameReference<TankGame>, CollisionCallbacks {
  Obstacle({
    required Vector2 position,
    Vector2? size,
  }) : super(position: position, size: size ?? Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('obstacle.png');
    add(RectangleHitbox());
  }
}
