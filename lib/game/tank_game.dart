import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:flame/input.dart';
import 'player_tank.dart';
import 'game_world.dart';
import 'obstacle.dart';
import '../services/game_service.dart';
import '../models/game_room.dart';

class TankGame extends FlameGame with HasCollisionDetection {
  late final PlayerTank player;
  late final JoystickComponent joystick;
  late final GameWorld gameWorld;
  
  final GameService gameService = GameService();
  String? currentGameId;
  String? localPlayerId;
  StreamSubscription? _gameSubscription;
  final Map<String, PlayerTank> remotePlayers = {};
  double _elapsed = 0;

  @override
  double currentTime() => _elapsed;

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
  }


  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add the game world background
    gameWorld = GameWorld();
    add(gameWorld);
    
    camera.viewfinder.anchor = Anchor.center;

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    player = PlayerTank(joystick: joystick, isLocalPlayer: true)
      ..position = Vector2(GameWorld.worldWidth / 2, GameWorld.worldHeight / 2)
      ..anchor = Anchor.center;

    add(player);
    add(joystick);

    // Fire Button
    final buttonPaint = BasicPalette.red.withAlpha(200).paint();
    final fireButton = HudButtonComponent(
      button: CircleComponent(radius: 25, paint: buttonPaint),
      margin: const EdgeInsets.only(right: 40, bottom: 40),
      onPressed: player.shoot,
    );
    add(fireButton);

    // Add obstacles
    final obstaclePositions = [
      Vector2(200, 200),
      Vector2(800, 200),
      Vector2(500, 400),
      Vector2(200, 600),
      Vector2(800, 600),
    ];
    for (final pos in obstaclePositions) {
      add(Obstacle(position: pos));
    }
  }

  void startMultiplayerGame(String gameId, String playerId) {
    currentGameId = gameId;
    localPlayerId = playerId;
    player.playerId = playerId;

    _gameSubscription = gameService.streamGame(gameId).listen((gameRoom) {
      if (gameRoom != null) {
        _syncRemotePlayers(gameRoom);
      }
    });
  }

  void _syncRemotePlayers(GameRoom gameRoom) {
    for (final entry in gameRoom.players.entries) {
      if (entry.key == localPlayerId) continue;
      
      if (remotePlayers.containsKey(entry.key)) {
        remotePlayers[entry.key]!.updateFromState(entry.value);
      } else {
        final remoteTank = PlayerTank(
          joystick: joystick,
          playerId: entry.key,
          isLocalPlayer: false,
        )..updateFromState(entry.value);
        remotePlayers[entry.key] = remoteTank;
        add(remoteTank);
      }
    }

    // Remove disconnected players
    remotePlayers.keys.toList().forEach((key) {
      if (!gameRoom.players.containsKey(key)) {
        remotePlayers[key]?.removeFromParent();
        remotePlayers.remove(key);
      }
    });
  }

  @override
  void onRemove() {
    _gameSubscription?.cancel();
    super.onRemove();
  }
}
