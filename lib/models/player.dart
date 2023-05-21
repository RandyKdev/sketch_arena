import 'package:intl/intl.dart';

class Player {
  const Player({
    required this.playerName,
    required this.avatarCode,
    required this.createdAt,
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
      createdAt: DateFormat('dd/MM/yyyy HH:mm:ss')
          .parseUtc(
            map['createdAt'] as String,
          )
          .toLocal(),
    );
  }

  final String playerName;
  final int avatarCode;
  final double? roundScore;
  final double? totalScore;
  final int? roomId;
  final int? playerId;
  final bool? active;
  final DateTime createdAt;

  Player copy({
    String? playerName,
    int? avatarCode,
    double? roundScore,
    double? totalScore,
    int? roomId,
    int? playerId,
    bool? active,
    DateTime? createdAt,
  }) {
    return Player(
      playerName: playerName ?? this.playerName,
      avatarCode: avatarCode ?? this.avatarCode,
      createdAt: createdAt ?? this.createdAt,
      active: active ?? this.active,
      playerId: playerId ?? this.playerId,
      roomId: roomId ?? this.roomId,
      roundScore: roundScore ?? this.roundScore,
      totalScore: totalScore ?? this.totalScore,
    );
  }

  Map<String, dynamic> completePlayerMap() {
    return {
      'playerName': playerName,
      'avatarCode': avatarCode,
      'roundScore': roundScore,
      'totalScore': totalScore,
      'roomId': roomId,
      'playerId': playerId,
      'active': active,
      'createdAt': DateFormat('dd/MM/yyyy HH:mm:ss').format(createdAt.toUtc()),
    };
  }

  Map<String, dynamic> createPlayerMap() {
    return {
      'playerName': playerName,
      'avatarCode': avatarCode,
      'createdAt': DateFormat('dd/MM/yyyy HH:mm:ss').format(createdAt.toUtc()),
    };
  }
}
