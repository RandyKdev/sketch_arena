import 'package:supabase_edge_functions_example/services/supabase_service.dart';
import 'package:supabase_functions/supabase_functions.dart';
import 'package:sketch_arena/models/player.dart';

Future<Response> createPlayerFunction(Map<String, dynamic> body) async {
  final player = Player.fromMap(body);
  final createdPlayer = await SupabaseService.instance.createPlayer(player);

  if (createdPlayer == null) {
    return Response.error();
  }

  return Response.json(createdPlayer.completePlayerMap());
}
