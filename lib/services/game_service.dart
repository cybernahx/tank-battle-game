import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_room.dart';
import '../models/player_state.dart';
import '../models/chat_message.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _gamesRef => _firestore.collection('games');

  /// Create a new game room
  Future<String> createGame(String hostId) async {
    final docRef = _gamesRef.doc();
    final game = GameRoom(
      id: docRef.id,
      hostId: hostId,
      players: {
        hostId: PlayerState(id: hostId, x: 500, y: 400, angle: 0),
      },
      status: GameStatus.waiting,
    );
    await docRef.set(game.toMap());
    return docRef.id;
  }

  /// Join an existing game
  Future<bool> joinGame(String gameId, String playerId) async {
    final docRef = _gamesRef.doc(gameId);
    final doc = await docRef.get();
    
    if (!doc.exists) return false;
    
    final data = doc.data() as Map<String, dynamic>;
    final players = (data['players'] as Map<String, dynamic>?) ?? {};
    
    if (players.length >= 4) return false;
    
    players[playerId] = PlayerState(
      id: playerId,
      x: 200 + (players.length * 200).toDouble(),
      y: 400,
      angle: 0,
    ).toMap();
    
    await docRef.update({'players': players});
    return true;
  }

  /// Leave a game
  Future<void> leaveGame(String gameId, String playerId) async {
    final docRef = _gamesRef.doc(gameId);
    await docRef.update({
      'players.$playerId': FieldValue.delete(),
    });
  }

  /// Stream game state updates
  Stream<GameRoom?> streamGame(String gameId) {
    return _gamesRef.doc(gameId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GameRoom.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  /// Update player position
  Future<void> updatePlayerState(String gameId, PlayerState state) async {
    await _gamesRef.doc(gameId).update({
      'players.${state.id}': state.toMap(),
    });
  }

  /// Get available games to join
  Stream<List<GameRoom>> streamAvailableGames() {
    return _gamesRef
        .where('status', isEqualTo: GameStatus.waiting.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameRoom.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Start the game
  Future<void> startGame(String gameId) async {
    await _gamesRef.doc(gameId).update({
      'status': GameStatus.active.name,
    });
  }

  // ========== CHAT METHODS ==========

  /// Send a chat message
  Future<void> sendMessage(String gameId, ChatMessage message) async {
    await _gamesRef.doc(gameId).collection('messages').doc(message.id).set(message.toMap());
  }

  /// Stream chat messages
  Stream<List<ChatMessage>> streamMessages(String gameId) {
    return _gamesRef
        .doc(gameId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .limitToLast(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }
}

