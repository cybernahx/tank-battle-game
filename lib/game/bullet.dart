import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'tank_game.dart';
import 'obstacle.dart';
import 'game_world.dart';
import 'effects.dart';
import 'audio_manager.dart';
import 'player_tank.dart';

class Bullet extends SpriteComponent with HasGameReference<TankGame>, CollisionCallbacks {
  final double speed = 400.0;
  final Vector2 direction;
  final String? ownerId;

  Bullet({
    required Vector2 position,
    required this.direction,
    this.ownerId,
  }) : super(position: position, size: Vector2(10, 10), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('bullet.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(direction * speed * dt);

    if (position.x < 0 || position.x > GameWorld.worldWidth ||
        position.y < 0 || position.y > GameWorld.worldHeight) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      game.add(ExplosionEffect(position: position.clone()));
      AudioManager.playExplosion();
      removeFromParent();
    } else if (other is PlayerTank) {
      // Don't hit yourself
      if (other.playerId == ownerId) return;

      // Check shield
      if (other.hasShield) {
        // Shield collision effect (maybe blue explosion?)
        game.add(ExplosionEffect(position: position.clone())); // Reuse explosion for now
        AudioManager.playHit();
        removeFromParent();
        return;
      }

      // Apply damage
      if (other.isLocalPlayer) {
        other.health--;
        if (other.health <= 0) {
          // Respawn or game over logic
          other.position = Vector2(500, 400); // Simple respawn
          other.health = 3;
        }
        // Force immediate sync
        other.syncToServer();
      }
      
      game.add(ExplosionEffect(position: position.clone()));
      AudioManager.playExplosion();
      removeFromParent();
    }
  }
}

