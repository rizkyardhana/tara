import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../services/api_service.dart';
import '../../widgets/tara_common.dart';

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

    final outgoingMessage = ChatBubble(message: text, isFromUser: true);
    setState(() {
      _messages.add(outgoingMessage);
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
        setState(() {
          _messages.remove(outgoingMessage);
          _messageController.text = text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesan belum terkirim. Silakan coba lagi.'),
          ),
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
      backgroundColor: TaraColors.authBackgroundGradient[1],
      appBar: AppBar(
        toolbarHeight: 68,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('TARA AI'),
            SizedBox(height: 2),
            Text(
              'Ruang aman untuk bercerita',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: TaraColors.textMuted,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: TaraColors.authBackgroundGradient.first,
        actions: [
          IconButton(
            tooltip: 'Bantuan krisis',
            onPressed: () => context.push('/security-crisis'),
            icon: const Icon(Icons.support_agent_rounded),
          ),
        ],
      ),
      body: TaraPastelBackground(
        child: Column(
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
                border: Border(top: BorderSide(color: TaraColors.authBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Bagikan perasaan Anda...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: TaraColors.authBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: TaraColors.authBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: TaraColors.authAccent,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: TaraColors.authButtonGradient,
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
          maxWidth: MediaQuery.of(context).size.width * 0.84,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bubble.isFromUser
              ? TaraColors.authAccent
              : const Color(0xFFF7F3FC),
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(16),
            topEnd: const Radius.circular(16),
            bottomStart: Radius.circular(bubble.isFromUser ? 16 : 4),
            bottomEnd: Radius.circular(bubble.isFromUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bubble.isFromUser ? 'Kamu' : 'TARA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: bubble.isFromUser
                    ? Colors.white.withValues(alpha: 0.82)
                    : TaraColors.authAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bubble.message,
              style: TextStyle(
                fontSize: 15,
                color: bubble.isFromUser
                    ? Colors.white
                    : TaraColors.textDeepIndigo,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
