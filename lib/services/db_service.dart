import 'package:sketch_arena/constants/db_tables.dart';
import 'package:sketch_arena/models/player.dart';
import 'package:sketch_arena/models/room.dart';
import 'package:sketch_arena/models/round.dart';
import 'package:sketch_arena/models/sketch_path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService {
  final supabase = Supabase.instance.client;

  Future<Player?> createPlayer({required Player player}) async {
    final cretedPlayerResponse = await supabase.functions.invoke(
      'createPlayer',
      body: player.createPlayerMap(),
    );

    if (cretedPlayerResponse.status != 200) {
      return null;
    }

    return Player.fromMap(cretedPlayerResponse.data as Map<String, dynamic>);
  }

  Future<Room?> createRoom({required Player player}) async {
    final cretedRoomResponse = await supabase.functions.invoke(
      'createRoom',
      body: player.completePlayerMap(),
    );

    if (cretedRoomResponse.status != 200) {
      return null;
    }

    return Room.fromMap(cretedRoomResponse.data as Map<String, dynamic>);
  }

  Future<Room?> joinRoom({
    required Player player,
    required String? roomId,
  }) async {
    final joinedRoomResponse = await supabase.functions.invoke(
      'joinRoom',
      body: player.completePlayerMap()..addAll({'roomId': roomId}),
    );

    if (joinedRoomResponse.status != 200) {
      return null;
    }

    return Room.fromMap(joinedRoomResponse.data as Map<String, dynamic>);
  }

  Stream<List<Player>> streamPlayersInRoom(Room rooom) {
    return supabase
        .from(playersTable)
        .stream(primaryKey: ['playerId'])
        .eq('roomId', rooom.roomId)
        .order('createdAt')
        .map<List<Player>>(
          (players) => players.map(Player.fromMap).toList(),
        );
  }

  Stream<Room?> streamRoomData(Room rooom) {
    return supabase
        .from(roomTable)
        .stream(primaryKey: ['roomId'])
        .eq('roomId', rooom.roomId)
        .limit(1)
        .map<Room?>(
          (rooms) => rooms.map(Room.fromMap).toList().firstOrNull,
        );
  }

  Stream<List<Round>> streamRounds(Room rooom) {
    return supabase
        .from(roundTable)
        .stream(primaryKey: ['roundId'])
        .eq('roomId', rooom.roomId)
        .map<List<Round>>(
          (rooms) => rooms.map(Round.fromMap).toList(),
        );
  }

  Future<Round?> startRound({
    required Room rooom,
    required String choosenWord,
    required Player player,
  }) async {
    final startedRoundResponse = await supabase.functions.invoke(
      'createRound',
      body: {
        'roomId': rooom.roomId,
        'choosenWord': choosenWord,
        'playerId': player.playerId,
      },
    );

    if (startedRoundResponse.status != 200) {
      return null;
    }

    return Round.fromMap(startedRoundResponse.data as Map<String, dynamic>);
  }

  Future<List<String>?> getChoiceWords({
    required Room rooom,
    required Player player,
  }) async {
    final getChoiceWordsResponse = await supabase.functions.invoke(
      'getChoiceWords',
      body: {
        'roomId': rooom.roomId,
        'playerId': player.playerId,
      },
    );

    if (getChoiceWordsResponse.status != 200) {
      return null;
    }

    return (getChoiceWordsResponse.data as List<dynamic>)
        .map((e) => e as String)
        .toList();
  }

  Future<void> updateSketch({
    required Round round,
    required List<SketchPath> sketch,
  }) async {
    await supabase.from(roundTable).update({
      'sketch': sketch.map((e) => e.toMap()).toList(),
    }).eq('roundId', round.roundId);
  }

  Future<Player?> getNextRoundPlayer({
    required Room rooom,
    required Player player,
  }) async {
    final getNextRoundPlayerResponse = await supabase.functions.invoke(
      'getNextRoundPlayer',
      body: {
        'roomId': rooom.roomId,
        'playerId': player.playerId,
      },
    );

    if (getNextRoundPlayerResponse.status != 200) {
      return null;
    }

    return Player.fromMap(
      getNextRoundPlayerResponse.data as Map<String, dynamic>,
    );
  }

  Future<void> exitPlayer(Player player) async {
    await supabase.functions.invoke(
      'exitPlayer',
      body: {'playerId': player.playerId},
    );
  }
}
