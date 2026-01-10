import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/tank_game.dart';
import '../widgets/health_bar.dart';
import '../widgets/chat_widget.dart';
import '../services/game_service.dart';

class GameScreen extends StatefulWidget {
  final String gameId;
  final String playerId;

  const GameScreen({
    super.key,
    required this.gameId,
    required this.playerId,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final TankGame _game;
  final GameService _gameService = GameService();
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _game = TankGame();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _game.startMultiplayerGame(widget.gameId, widget.playerId);
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _game.pauseEngine();
      } else {
        _game.resumeEngine();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game
          GameWidget(game: _game),
          
          // HUD Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Health
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const HealthBar(health: 3),
                  ),
                  
                  // Pause Button
                  IconButton(
                    onPressed: _togglePause,
                    icon: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Chat Widget
          ChatWidget(
            gameId: widget.gameId,
            playerId: widget.playerId,
            gameService: _gameService,
          ),
          
          // Pause Menu Overlay
          if (_isPaused)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _togglePause,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: const Text('RESUME', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: const Text('QUIT', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
