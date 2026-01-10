import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/neon_button.dart';
import '../services/auth_service.dart';
import '../services/game_service.dart';
import 'game_screen.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final AuthService _authService = AuthService();
  final GameService _gameService = GameService();
  final TextEditingController _gameCodeController = TextEditingController();
  
  bool _isLoading = false;
  String? _playerId;

  @override
  void initState() {
    super.initState();
    _signIn();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInAnonymously();
    setState(() {
      _playerId = user?.uid;
      _isLoading = false;
    });
  }

  Future<void> _createGame() async {
    if (_playerId == null) return;
    setState(() => _isLoading = true);
    
    final gameId = await _gameService.createGame(_playerId!);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(gameId: gameId, playerId: _playerId!),
        ),
      );
    }
  }

  Future<void> _joinGame() async {
    if (_playerId == null) return;
    final gameId = _gameCodeController.text.trim();
    if (gameId.isEmpty) return;
    
    setState(() => _isLoading = true);
    final success = await _gameService.joinGame(gameId, _playerId!);
    
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(gameId: gameId, playerId: _playerId!),
        ),
      );
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join game')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOBBY', style: GoogleFonts.orbitron()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Player ID: ${_playerId?.substring(0, 8) ?? 'Loading...'}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(height: 40),
                    
                    NeonButton(
                      text: 'CREATE GAME',
                      onPressed: _createGame,
                      glowColor: Colors.green,
                      width: 250,
                    ),
                    const SizedBox(height: 40),
                    
                    Text(
                      'OR JOIN WITH CODE',
                      style: GoogleFonts.orbitron(
                        color: Colors.grey[500],
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _gameCodeController,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Enter Game Code',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.cyan),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.cyan.withAlpha(127)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.cyan, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    NeonButton(
                      text: 'JOIN GAME',
                      onPressed: _joinGame,
                      glowColor: Colors.cyan,
                      width: 250,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
