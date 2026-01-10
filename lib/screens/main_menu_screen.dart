import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/neon_button.dart';
import 'lobby_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _titleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!,
              Colors.black,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Title
                ScaleTransition(
                  scale: _titleAnimation,
                  child: Text(
                    'TANK BATTLE',
                    style: GoogleFonts.orbitron(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                      shadows: [
                        const Shadow(color: Colors.cyan, blurRadius: 20),
                        Shadow(color: Colors.cyan.withAlpha(127), blurRadius: 40),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'MULTIPLAYER',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    letterSpacing: 8,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 80),
                
                NeonButton(
                  text: 'PLAY',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LobbyScreen()),
                    );
                  },
                  glowColor: Colors.green,
                ),
                const SizedBox(height: 20),
                
                NeonButton(
                  text: 'SETTINGS',
                  onPressed: () {
                    // TODO: Settings screen
                  },
                  glowColor: Colors.orange,
                ),
                const SizedBox(height: 20),
                
                NeonButton(
                  text: 'EXIT',
                  onPressed: () {
                    // Exit app
                  },
                  glowColor: Colors.red,
                ),
                
                const SizedBox(height: 60),
                Text(
                  'v1.0.0',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
