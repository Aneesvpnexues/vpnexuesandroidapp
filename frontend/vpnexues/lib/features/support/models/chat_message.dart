enum MessageSender { user, bot }

enum MessageType { text, faq, contact, greeting }

class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final MessageType type;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    this.type = MessageType.text,
    required this.timestamp,
  });
}
