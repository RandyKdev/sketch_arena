import 'package:intl/intl.dart';

class Room {
  const Room({
    required this.drawTime,
    required this.active,
    required this.rounds,
    required this.players,
    required this.isPrivate,
    required this.createdAt,
    this.roomId,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      roomId: map['roomId'] as int?,
      active: map['active'] as bool,
      drawTime: Duration(seconds: map['drawTime'] as int),
      rounds: map['rounds'] as int,
      players: map['players'] as int,
      createdAt: DateFormat('dd/MM/yyyy HH:mm:ss')
          .parseUtc(
            map['createdAt'] as String,
          )
          .toLocal(),
      isPrivate: map['isPrivate'] as bool,
    );
  }

  final int? roomId;
  final int rounds;
  final int players;
  final Duration drawTime;
  final bool active;
  final bool isPrivate;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'drawTime': drawTime.inSeconds,
      'active': active,
      'isPrivate': isPrivate,
      'rounds': rounds,
      'players': players,
      'createdAt': DateFormat('dd/MM/yyyy HH:mm:ss').format(createdAt.toUtc()),
      if (roomId != null) 'roomId': roomId,
    };
  }
}
