class Message {
  const Message({
    required this.playerId,
    required this.content,
    required this.roomId,
    this.isCorrectGuess,
    this.messageId,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      playerId: map['playerId'] as int,
      content: map['message'] as String,
      roomId: map['roomId'] as int,
      isCorrectGuess: map['isCorrectGuess'] as bool?,
      messageId: map['messageId'] as int?,
    );
  }

  final int? messageId;
  final int playerId;
  final int roomId;
  final String content;
  final bool? isCorrectGuess;

  Message copy({
    int? messageId,
    int? playerId,
    int? roomId,
    String? content,
    bool? isCorrectGuess,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      playerId: playerId ?? this.playerId,
      roomId: roomId ?? this.roomId,
      content: content ?? this.content,
      isCorrectGuess: isCorrectGuess ?? this.isCorrectGuess,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'message': content,
      'playerId': playerId,
      if (isCorrectGuess != null) 'isCorrectGuess': isCorrectGuess,
      if (messageId != null) 'messageId': messageId,
    };
  }
}
