class PlayerState {
  final String id;
  final double x;
  final double y;
  final double angle;
  final int health;

  PlayerState({
    required this.id,
    required this.x,
    required this.y,
    required this.angle,
    this.health = 3,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'x': x,
      'y': y,
      'angle': angle,
      'health': health,
    };
  }

  factory PlayerState.fromMap(Map<String, dynamic> map) {
    return PlayerState(
      id: map['id'] ?? '',
      x: (map['x'] ?? 0).toDouble(),
      y: (map['y'] ?? 0).toDouble(),
      angle: (map['angle'] ?? 0).toDouble(),
      health: map['health'] ?? 3,
    );
  }
}
