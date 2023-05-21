class Message {
  const Message({
    required this.playerId,
    required this.content,
    required this.roomId,
    required this.isCorrectGuess,
    this.messageId,
  });

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      playerId: map['playerId'] as String,
      content: map['message'] as String,
      roomId: map['roomId'] as String,
      isCorrectGuess: map['playerId'] as bool,
    );
  }

  final String? messageId;
  final String playerId;
  final String roomId;
  final String content;
  final bool isCorrectGuess;
}
