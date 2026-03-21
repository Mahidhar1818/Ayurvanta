enum MessageRole { user, ai }

class ChatMessage {
  final String id;
  final String text;
  final MessageRole role;
  final DateTime timestamp;
  final bool isTyping;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.timestamp,
    this.isTyping = false,
  });

  ChatMessage copyWith({String? text, bool? isTyping}) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      role: role,
      timestamp: timestamp,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
