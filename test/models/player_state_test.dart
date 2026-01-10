import 'package:flutter_test/flutter_test.dart';
import 'package:tank_game/models/player_state.dart';

void main() {
  group('PlayerState', () {
    test('toMap converts to correct format', () {
      final state = PlayerState(
        id: 'player1',
        x: 100.0,
        y: 200.0,
        angle: 1.5,
        health: 2,
      );

      final map = state.toMap();

      expect(map['id'], 'player1');
      expect(map['x'], 100.0);
      expect(map['y'], 200.0);
      expect(map['angle'], 1.5);
      expect(map['health'], 2);
    });

    test('fromMap creates correct instance', () {
      final map = {
        'id': 'player2',
        'x': 150.0,
        'y': 250.0,
        'angle': 2.0,
        'health': 3,
      };

      final state = PlayerState.fromMap(map);

      expect(state.id, 'player2');
      expect(state.x, 150.0);
      expect(state.y, 250.0);
      expect(state.angle, 2.0);
      expect(state.health, 3);
    });

    test('fromMap handles missing values', () {
      final map = <String, dynamic>{};

      final state = PlayerState.fromMap(map);

      expect(state.id, '');
      expect(state.x, 0.0);
      expect(state.y, 0.0);
      expect(state.angle, 0.0);
      expect(state.health, 3);
    });
  });
}
