import 'package:sketch_arena/constants/db_tables.dart';
import 'package:sketch_arena/constants/edge_functions.dart';
import 'package:sketch_arena/models/end_current_response.dart';
import 'package:sketch_arena/models/message.dart';
import 'package:sketch_arena/models/player.dart';
import 'package:sketch_arena/models/room.dart';
import 'package:sketch_arena/models/round.dart';
import 'package:sketch_arena/models/sketch_path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService {
  final supabase = Supabase.instance.client;

  Future<Player?> createPlayer({required Player player}) async {
    final cretedPlayerResponse = await supabase.functions.invoke(
      edgeFunctionName,
      body: player.createPlayerMap()..addAll({'invokeCode': 'createPlayer'}),
    );

    if (cretedPlayerResponse.status != 200) {
      return null;
    }

    return Player.fromMap(cretedPlayerResponse.data as Map<String, dynamic>);
  }

  Future<Room?> createRoom({required Player player, required Room room}) async {
    final cretedRoomResponse = await supabase.functions.invoke(
      edgeFunctionName,
      body: player.completePlayerMap()
        ..addAll(room.toMap())
        ..addAll({'invokeCode': 'createRoom'}),
    );

    if (cretedRoomResponse.status != 200) {
      return null;
    }

    return Room.fromMap(cretedRoomResponse.data as Map<String, dynamic>);
  }

  Future<Room?> joinRoom({
    required Player player,
    required int? roomId,
  }) async {
    final joinedRoomResponse = await supabase.functions.invoke(
      edgeFunctionName,
      body: player.completePlayerMap()
        ..addAll({
          if (roomId != null) 'roomId': roomId,
          'invokeCode': 'joinRoom',
        }),
    );

    if (joinedRoomResponse.status != 200) {
      return null;
    }

    return Room.fromMap(joinedRoomResponse.data as Map<String, dynamic>);
  }

  Stream<List<Player>> streamPlayersInRoom(Room room) {
    return supabase
        .from(playersTable)
        .stream(primaryKey: ['playerId'])
        .eq('roomId', room.roomId)
        .order('createdAt')
        .map<List<Player>>(
          (players) => players.map(Player.fromMap).toList(),
        );
  }

  Stream<Room?> streamRoomData(Room room) {
    return supabase
        .from(roomTable)
        .stream(primaryKey: ['roomId'])
        .eq('roomId', room.roomId)
        .limit(1)
        .map<Room?>(
          (rooms) => rooms.map(Room.fromMap).toList().firstOrNull,
        );
  }

  Stream<List<Round>> streamRounds(Room room) {
    return supabase
        .from(roundTable)
        .stream(primaryKey: ['roundId'])
        .eq('roomId', room.roomId)
        .map<List<Round>>(
          (rooms) => rooms.map(Round.fromMap).toList(),
        );
  }

  Stream<List<Message?>> streamMessages(Room room) {
    return supabase
        .from(messagesTable)
        .stream(primaryKey: ['messageId'])
        .eq('roomId', room.roomId)
        .map((message) => message.map(Message.fromMap).toList());
  }

  Future<Message?> sendMessage(Message message) async {
    final sentMessageResponse = await supabase.functions.invoke(
      edgeFunctionName,
      body: {
        ...message.toMap(),
        'invokeCode': 'sendMessage',
      },
    );

    if (sentMessageResponse.status != 200) {
      return null;
    }

    return Message.fromMap(sentMessageResponse.data as Map<String, dynamic>);
  }

  Future<bool> isMessageCorrect(String message, String roomId) async {
    Map<String, dynamic> correctWordData;
    try {
      correctWordData = await supabase
          .from(roundTable)
          .select<Map<String, dynamic>>('correctWord')
          .eq('roomId', roomId)
          .eq('active', true)
          .single();
      if (message == correctWordData['correctWord']) return true;
      return false;
    } on PostgrestException catch (error) {
      print('Caught an error while fetching correct word');
      print(error);
      return false;
    }
  }

  Future<Round?> createRound(Round round) async {
    final startedRoundResponse = await supabase.functions.invoke(
      edgeFunctionName,
      body: {
        ...round.toMap(),
        'invokeCode': 'createRound',
      },
    );

    if (startedRoundResponse.status != 200) {
      return null;
    }

    return Round.fromMap(startedRoundResponse.data as Map<String, dynamic>);
  }

  Future<void> updateSketch({
    required Round round,
    required List<SketchPath> sketch,
  }) async {
    await supabase.from(roundTable).update({
      'sketch': sketch.map((e) => e.toMap()).toList(),
    }).eq('roundId', round.roundId);
  }

  Future<EndCurrentResponse?> endCurrentRound({
    required Room room,
    required Round round,
  }) async {
    final getNextRoundPlayerResponse = await supabase.functions.invoke(
      edgeFunctionName,
      body: {
        ...room.toMap(),
        ...round.toMap(),
        'invokeCode': 'endCurrentRound',
      },
    );

    if (getNextRoundPlayerResponse.status != 200) {
      return null;
    }

    return EndCurrentResponse.fromMap(
      getNextRoundPlayerResponse.data as Map<String, dynamic>,
    );
  }

  Future<void> exitPlayer(Player player) async {
    await supabase.functions.invoke(
      edgeFunctionName,
      body: {
        ...player.completePlayerMap(),
        'invokeCode': 'exitPlayer',
      },
    );
  }
}
