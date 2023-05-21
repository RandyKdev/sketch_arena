import 'package:edge_http_client/edge_http_client.dart';
import 'package:sketch_arena/constants/db_tables.dart';
import 'package:sketch_arena/models/message.dart';
import 'package:sketch_arena/models/player.dart';
import 'package:sketch_arena/models/room.dart';
import 'package:sketch_arena/models/round.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_functions/supabase_functions.dart';
import 'package:word_generator/word_generator.dart';

class SupabaseService {
  static SupabaseService? _instance;
  SupabaseService._();
  static SupabaseService get instance {
    if (_instance == null) {
      _instance = SupabaseService._();
      _supabaseClient = SupabaseClient(
        Deno.env.get('SUPABASE_URL')!,
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
        httpClient: EdgeHttpClient(),
      );
    }

    return _instance!;
  }

  static void init() => SupabaseService.instance;

  static late SupabaseClient _supabaseClient;

  Future<Player?> createPlayer(Player player) async {
    final cretedPlayerResponse = await _supabaseClient
        .from(playersTable)
        .insert(player.createPlayerMap())
        .maybeSingle()
        .select<Map<String, dynamic>?>();

    if (cretedPlayerResponse == null) return null;

    return Player.fromMap(cretedPlayerResponse);
  }

  Future<Room?> createRoom({
    required Player player,
    required Room room,
  }) async {
    final createdRoomResponse = await _supabaseClient
        .from(roomTable)
        .insert(room.toMap())
        .maybeSingle()
        .select<Map<String, dynamic>?>();

    if (createdRoomResponse == null) return null;

    room = Room.fromMap(createdRoomResponse);
    final joinedPlayer = await joinRoom(player: player, roomId: room.roomId!);

    if (joinedPlayer == null) return null;

    return room;
  }

  Future<Room?> getRoom(int roomId) async {
    final getRoomResponse = await _supabaseClient
        .from(roomTable)
        .select<Map<String, dynamic>?>()
        .eq('roomId', roomId)
        .maybeSingle();

    if (getRoomResponse == null) return null;

    return Room.fromMap(getRoomResponse);
  }

  Future<Room?> findAvailableRoom(Player player) async {
    final cretedRoomResponse = await _supabaseClient
        .from(roomTable)
        .select<List<Map<String, dynamic>>>()
        .eq('isPrivate', false)
        .eq('active', true);

    final rooms = cretedRoomResponse.map((e) => Room.fromMap(e)).toList();

    final futures = rooms.map((e) {
      return _supabaseClient
          .from(playersTable)
          .select<List<Map<String, dynamic>>>()
          .eq('roomId', e.roomId);
    }).toList();

    final results = await Future.wait(futures);

    final playersList =
        results.map((e) => e.map((e) => Player.fromMap(e)).toList()).toList();

    Room? room;
    for (int i = 0; i < rooms.length; i++) {
      if (playersList[i].length < rooms[i].players) {
        room = rooms[i];
        break;
      }
    }

    if (room == null) return null;

    final joinedPlayer = await joinRoom(player: player, roomId: room.roomId!);

    if (joinedPlayer == null) return null;

    return room;
  }

  Future<Player?> joinRoom({
    required Player player,
    required int roomId,
  }) async {
    final joinedPlayerResponse = await _supabaseClient
        .from(playersTable)
        .update(
          player
              .copy(
                roomId: roomId,
                totalScore: 0,
                roundScore: 0,
                active: true,
              )
              .completePlayerMap(),
        )
        .eq('playerId', player.playerId)
        .maybeSingle()
        .select<Map<String, dynamic>?>();

    if (joinedPlayerResponse == null) {
      return null;
    }

    return Player.fromMap(joinedPlayerResponse);
  }

  Future<Round?> createRound(Round round) async {
    final createdRoundResponse = await _supabaseClient
        .from(roundTable)
        .insert(round.toMap())
        .maybeSingle()
        .select<Map<String, dynamic>?>();

    if (createdRoundResponse == null) return null;

    return Round.fromMap(createdRoundResponse);
  }

  Future<Round?> getCurrentRound(int roomId) async {
    final getCurrentRoundResponse = await _supabaseClient
        .from(roundTable)
        .select<Map<String, dynamic>?>()
        .eq('roomId', roomId)
        .eq('active', true)
        .maybeSingle();

    if (getCurrentRoundResponse == null) return null;

    return Round.fromMap(getCurrentRoundResponse);
  }

  List<String> getChoiceWords() {
    return WordGenerator().randomNouns(5);
  }

  Future<bool> isGameOver(Room room) async {
    final roundsResponse = await _supabaseClient
        .from(roundTable)
        .select<List<Map<String, dynamic>>>()
        .eq('roomId', room.roomId)
        .eq('active', false);

    return roundsResponse.length >= room.rounds;
  }

  Future<Player?> getNextPlayer(Room room) async {
    final roundsResponse = await _supabaseClient
        .from(roundTable)
        .select<List<Map<String, dynamic>>>()
        .eq('roomId', room.roomId)
        .eq('active', false);

    final rounds = roundsResponse.map((e) => Round.fromMap(e)).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final playersResponse = await _supabaseClient
        .from(playersTable)
        .select<List<Map<String, dynamic>>>()
        .eq('roomId', room.roomId)
        .eq('active', true);

    final players = playersResponse.map((e) => Player.fromMap(e)).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (players.isEmpty) return null;

    if (rounds.isEmpty) return players.first;

    final lastPlayerId = rounds.last.currentSketcherId;

    int index = 0;
    for (; index < players.length; index++) {
      if (players[index].playerId == lastPlayerId) {
        break;
      }
    }

    if (index == players.length || index == players.length - 1) {
      return players.first;
    }

    return players[index + 1];
  }

  Future<Round?> endCurrentRound({
    required Room room,
    required Round round,
  }) async {
    final endedRoundResponse = await _supabaseClient
        .from(roundTable)
        .update({'active': false})
        .eq('roundId', round.roundId)
        .maybeSingle()
        .select<Map<String, dynamic>?>();

    if (endedRoundResponse == null) {
      return null;
    }

    return Round.fromMap(endedRoundResponse);
  }

  Future<void> exitPlayer(Player player) async {
    await _supabaseClient
        .from(playersTable)
        .update({'active': false}).eq('playerId', player.playerId);
  }

  Future<Message?> createMessage(Message message) async {
    final currentRound = await getCurrentRound(message.roomId);

    if (currentRound != null) {
      message = message.copy(
        isCorrectGuess: currentRound.correctWord == message.content,
      );
      if (message.isCorrectGuess!) message = message.copy(content: '');
    }

    final createdMessage = await _supabaseClient
        .from(messagesTable).insert(message.toMap())
        .maybeSingle()
        .select<Map<String, dynamic>?>();

    if (createdMessage == null) return null;

    return Message.fromMap(createdMessage);
  }
}
