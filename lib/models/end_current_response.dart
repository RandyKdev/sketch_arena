class EndCurrentResponse {
  const EndCurrentResponse({
    required this.isGameOver,
    this.nextPlayerId,
    this.words,
  });

  factory EndCurrentResponse.fromMap(Map<String, dynamic> json) {
    return EndCurrentResponse(
      isGameOver: json['isGameOver'] as bool,
      nextPlayerId: json['nextPlayerId'] as int?,
      words:
          (json['words'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  final bool isGameOver;
  final int? nextPlayerId;
  final List<String>? words;
}
