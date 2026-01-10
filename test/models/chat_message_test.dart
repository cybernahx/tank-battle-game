import 'package:flutter_test/flutter_test.dart';
import 'package:tank_game/models/chat_message.dart';

void main() {
  group('ChatMessage', () {
    test('toMap converts to correct format', () {
      final message = ChatMessage(
        id: 'msg1',
        senderId: 'user1',
        senderName: 'Player 1',
        message: 'Hello!',
      );

      final map = message.toMap();

      expect(map['id'], 'msg1');
      expect(map['senderId'], 'user1');
      expect(map['senderName'], 'Player 1');
      expect(map['message'], 'Hello!');
      expect(map['timestamp'], isNotNull);
    });

    test('fromMap creates correct instance', () {
      final map = {
        'id': 'msg2',
        'senderId': 'user2',
        'senderName': 'Player 2',
        'message': 'Hi there!',
        'timestamp': '2024-01-01T12:00:00.000',
      };

      final message = ChatMessage.fromMap(map);

      expect(message.id, 'msg2');
      expect(message.senderId, 'user2');
      expect(message.senderName, 'Player 2');
      expect(message.message, 'Hi there!');
    });

    test('fromMap handles missing values', () {
      final map = <String, dynamic>{};

      final message = ChatMessage.fromMap(map);

      expect(message.id, '');
      expect(message.senderId, '');
      expect(message.senderName, 'Player');
      expect(message.message, '');
    });
  });
}
