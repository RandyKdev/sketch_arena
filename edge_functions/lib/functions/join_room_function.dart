import 'package:sketch_arena/models/room.dart';
import 'package:supabase_edge_functions_example/services/supabase_service.dart';
import 'package:supabase_functions/supabase_functions.dart';
import 'package:sketch_arena/models/player.dart';

Future<Response> joinRoomFunction(Map<String, dynamic> body) async {
  final player = Player.fromMap(body);
  final roomId = body['roomId'] as int?;

  if (roomId == null) {
    final foundRoom = await SupabaseService.instance.findAvailableRoom(player);
    if (foundRoom == null) Response.error();

    return Response.json(foundRoom!.toMap());
  }

  final futures = [
    SupabaseService.instance.joinRoom(
      roomId: roomId,
      player: player,
    ),
    SupabaseService.instance.getRoom(roomId),
  ];
  final results = await Future.wait(futures);

  final joinedPlayer = results[0] as Player?;
  final room = results[1] as Room?;

  if (joinedPlayer == null || room == null) {
    return Response.error();
  }

  return Response.json(joinedPlayer.completePlayerMap()..addAll(room.toMap()));
}
