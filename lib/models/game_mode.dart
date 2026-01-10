enum GameMode {
  deathmatch,
  teamBattle,
  practice,
}

class GameModeInfo {
  final GameMode mode;
  final String name;
  final String description;
  final int maxPlayers;
  final bool hasTeams;

  const GameModeInfo({
    required this.mode,
    required this.name,
    required this.description,
    required this.maxPlayers,
    this.hasTeams = false,
  });

  static const List<GameModeInfo> modes = [
    GameModeInfo(
      mode: GameMode.deathmatch,
      name: 'Deathmatch',
      description: 'Free-for-all battle. Last tank standing wins!',
      maxPlayers: 4,
    ),
    GameModeInfo(
      mode: GameMode.teamBattle,
      name: 'Team Battle',
      description: '2v2 team warfare. Defeat the enemy team!',
      maxPlayers: 4,
      hasTeams: true,
    ),
    GameModeInfo(
      mode: GameMode.practice,
      name: 'Practice',
      description: 'Solo practice mode with bots.',
      maxPlayers: 1,
    ),
  ];

  static GameModeInfo getInfo(GameMode mode) {
    return modes.firstWhere((m) => m.mode == mode);
  }
}
