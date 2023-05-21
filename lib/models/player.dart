class Player {
  const Player({
    required this.playerName,
    required this.avatarCode,
    this.roundScore,
    this.totalScore,
    this.roomId,
    this.playerId,
    this.active,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      avatarCode: map['avatarCode'] as int,
      playerName: map['playerName'] as String,
      roundScore: map['roundScore'] as double?,
      totalScore: map['totalScore'] as double?,
      roomId: map['roomId'] as int?,
      playerId: map['playerId'] as int?,
      active: map['active'] as bool?,
    );
  }

  final String playerName;
  final int avatarCode;
  final double? roundScore;
  final double? totalScore;
  final int? roomId;
  final int? playerId;
  final bool? active;

  Map<String, dynamic> completePlayerMap() {
    return {
      'playerName': playerName,
      'avatarCode': avatarCode,
      'roundScore': roundScore,
      'totalScore': totalScore,
      'roomId': roomId,
      'playerId': playerId,
      'active': active,
    };
  }

  Map<String, dynamic> createPlayerMap() {
    return {
      'playerName': playerName,
      'avatarCode': avatarCode,
    };
  }
}
