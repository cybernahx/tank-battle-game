import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/game_service.dart';

class ChatWidget extends StatefulWidget {
  final String gameId;
  final String playerId;
  final GameService gameService;

  const ChatWidget({
    super.key,
    required this.gameId,
    required this.playerId,
    required this.gameService,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  bool _isExpanded = false;

  final List<String> _quickMessages = [
    '👋 Hello!',
    '👍 Nice shot!',
    '😂 LOL',
    '🔥 Let\'s go!',
    '💀 RIP',
    '🎯 Got you!',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: widget.playerId,
      senderName: 'Player ${widget.playerId.substring(0, 4)}',
      message: text.trim(),
    );
    
    widget.gameService.sendMessage(widget.gameId, message);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: 100,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isExpanded ? 280 : 50,
        height: _isExpanded ? 350 : 50,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyan.withAlpha(127)),
        ),
        child: _isExpanded ? _buildExpandedChat() : _buildCollapsedButton(),
      ),
    );
  }

  Widget _buildCollapsedButton() {
    return IconButton(
      onPressed: () => setState(() => _isExpanded = true),
      icon: const Icon(Icons.chat_bubble, color: Colors.cyan),
    );
  }

  Widget _buildExpandedChat() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.cyan.withAlpha(50),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CHAT', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => setState(() => _isExpanded = false),
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        
        // Messages
        Expanded(
          child: StreamBuilder<List<ChatMessage>>(
            stream: widget.gameService.streamMessages(widget.gameId),
            builder: (context, snapshot) {
              final messages = snapshot.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = msg.senderId == widget.playerId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.cyan.withAlpha(127) : Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.message,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // Quick Messages
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _quickMessages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text(_quickMessages[index], style: const TextStyle(fontSize: 12)),
                  onPressed: () => _sendMessage(_quickMessages[index]),
                  backgroundColor: Colors.grey[800],
                  side: BorderSide.none,
                ),
              );
            },
          ),
        ),
        
        // Input
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[900],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _sendMessage(_messageController.text),
                icon: const Icon(Icons.send, color: Colors.cyan),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
