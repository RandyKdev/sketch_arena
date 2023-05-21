import 'package:intl/intl.dart';
import 'package:sketch_arena/models/sketch_path.dart';

class Round {
  const Round({
    required this.correctWord,
    required this.currentSketcherId,
    required this.active,
    required this.roomId,
    required this.sketch,
    required this.createdAt,
    this.roundId,
  });

  factory Round.fromMap(Map<String, dynamic> map) {
    return Round(
      correctWord: map['correctWord'] as String,
      currentSketcherId: map['currentSketcherId'] as int,
      active: map['active'] as bool,
      roomId: map['roomId'] as int,
      roundId: map['roundId'] as int?,
      sketch: (map['sketch'] as List<dynamic>?)
              ?.map((e) => SketchPath.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateFormat('dd/MM/yyyy HH:mm:ss')
          .parseUTC(
            map['createdAt'] as String,
          )
          .toLocal(),
    );
  }

  final String correctWord;
  final int currentSketcherId;
  final bool active;
  final int roomId;
  final int? roundId;
  final List<SketchPath> sketch;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'correctWord': correctWord,
      'currentSketcherId': currentSketcherId,
      'active': active,
      'roomId': roomId,
      'sketch': sketch.map((e) => e.toMap()).toList(),
      'createdAt': DateFormat('dd/MM/yyyy HH:mm:ss').format(createdAt.toUtc()),
      if (roundId != null) 'roundId': roundId,
    };
  }
}
