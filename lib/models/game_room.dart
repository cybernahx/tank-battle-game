import 'player_state.dart';

enum GameStatus { waiting, active, finished }

class GameRoom {
  final String id;
  final String hostId;
  final Map<String, PlayerState> players;
  final GameStatus status;
  final DateTime createdAt;

  GameRoom({
    required this.id,
    required this.hostId,
    required this.players,
    this.status = GameStatus.waiting,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hostId': hostId,
      'players': players.map((k, v) => MapEntry(k, v.toMap())),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GameRoom.fromMap(Map<String, dynamic> map) {
    final playersMap = (map['players'] as Map<String, dynamic>?) ?? {};
    return GameRoom(
      id: map['id'] ?? '',
      hostId: map['hostId'] ?? '',
      players: playersMap.map((k, v) => MapEntry(k, PlayerState.fromMap(v))),
      status: GameStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => GameStatus.waiting,
      ),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
