import 'package:sketch_arena/models/room.dart';
import 'package:supabase_edge_functions_example/services/supabase_service.dart';
import 'package:supabase_functions/supabase_functions.dart';
import 'package:sketch_arena/models/player.dart';

Future<Response> createRoomFunction(Map<String, dynamic> body) async {
  final room = Room.fromMap(body);
  final player = Player.fromMap(body);
  final createdRoom = await SupabaseService.instance.createRoom(
    room: room,
    player: player,
  );

  if (createdRoom == null) {
    return Response.error();
  }

  return Response.json(createdRoom.toMap());
}
