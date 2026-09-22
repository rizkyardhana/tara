import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../services/api_service.dart';

/// TARA AI Chat Screen
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _api = ApiService();
  final List<ChatBubble> _messages = [
    ChatBubble(
      message:
          'Halo! Saya TARA, teman Anda dalam perjalanan wellbeing. Bagaimana perasaan Anda hari ini? 🌿',
      isFromUser: false,
    ),
  ];

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatBubble(message: text, isFromUser: true));
      _messageController.clear();
    });

    try {
      final result = await _api.sendChat(text);
      final reply = result['reply'] as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _messages.add(
            ChatBubble(
              message:
                  reply['content'] as String? ?? 'Terima kasih sudah berbagi.',
              isFromUser: false,
            ),
          );
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chat tidak tersambung: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerita ke TARA'),
        elevation: 0,
        backgroundColor: TaraColors.bgCoolWhite,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ChatBubbleWidget(bubble: msg),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: TaraColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Bagikan perasaan Anda...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: TaraColors.divider),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: TaraColors.taraGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(20),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble {
  final String message;
  final bool isFromUser;

  ChatBubble({required this.message, required this.isFromUser});
}

class _ChatBubbleWidget extends StatelessWidget {
  final ChatBubble bubble;

  const _ChatBubbleWidget({required this.bubble});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: bubble.isFromUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bubble.isFromUser ? TaraColors.blue : TaraColors.bgCoolWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          bubble.message,
          style: TextStyle(
            fontSize: 14,
            color: bubble.isFromUser ? Colors.white : TaraColors.textDeepIndigo,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
