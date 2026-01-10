import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:math';
import 'tank_game.dart';
import 'bullet.dart';
import 'game_world.dart';
import 'obstacle.dart';
import '../models/player_state.dart';

class PlayerTank extends SpriteComponent with HasGameReference<TankGame>, CollisionCallbacks {
  final JoystickComponent joystick;
  double _baseSpeed = 200.0;
  double _speedMultiplier = 1.0;
  double _timeSinceLastShot = 0;
  double _baseCooldown = 0.5;
  double _cooldownMultiplier = 1.0;
  double _timeSinceLastSync = 0;
  final double _syncInterval = 0.1;
  
  String? playerId;
  int health = 3;
  bool isLocalPlayer;
  bool hasShield = false;

  double get speed => _baseSpeed * _speedMultiplier;
  double get _shootCooldown => _baseCooldown * _cooldownMultiplier;

  PlayerTank({
    required this.joystick,
    this.playerId,
    this.isLocalPlayer = true,
  }) : super(size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('tank.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (isLocalPlayer) {
      if (!joystick.delta.isZero()) {
        position.add(joystick.relativeDelta * speed * dt);
        angle = joystick.delta.screenAngle();
      }
      
      position.x = position.x.clamp(size.x / 2, GameWorld.worldWidth - size.x / 2);
      position.y = position.y.clamp(size.y / 2, GameWorld.worldHeight - size.y / 2);
      // Sync state to server
      _timeSinceLastSync += dt;
      if (_timeSinceLastSync >= _syncInterval && playerId != null) {
        syncToServer();
        _timeSinceLastSync = 0;
      }
    }
    
    _timeSinceLastShot += dt;
  }

  void syncToServer() {
    if (game.currentGameId != null && playerId != null) {
      game.gameService.updatePlayerState(
        game.currentGameId!,
        PlayerState(
          id: playerId!,
          x: position.x,
          y: position.y,
          angle: angle,
          health: health,
        ),
      );
    }
  }

  void updateFromState(PlayerState state) {
    position.x = state.x;
    position.y = state.y;
    angle = state.angle;
    health = state.health;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      final pushDirection = (position - other.position).normalized();
      position.add(pushDirection * 2);
    }
  }

  void shoot() {
    if (_timeSinceLastShot >= _shootCooldown) {
      final direction = Vector2(cos(angle - pi / 2), sin(angle - pi / 2));
      
      final bullet = Bullet(
        position: position + direction * 30,
        direction: direction,
        ownerId: playerId,
      );
      game.add(bullet);
      _timeSinceLastShot = 0;
    }
  }

  // Power-up methods
  void applySpeedBoost(double duration) {
    _speedMultiplier = 1.5;
    Future.delayed(Duration(milliseconds: (duration * 1000).toInt()), () {
      _speedMultiplier = 1.0;
    });
  }

  void applyShield(double duration) {
    hasShield = true;
    Future.delayed(Duration(milliseconds: (duration * 1000).toInt()), () {
      hasShield = false;
    });
  }

  void applyRapidFire(double duration) {
    _cooldownMultiplier = 0.3;
    Future.delayed(Duration(milliseconds: (duration * 1000).toInt()), () {
      _cooldownMultiplier = 1.0;
    });
  }

  void heal(int amount) {
    health = (health + amount).clamp(0, 3);
  }
}

