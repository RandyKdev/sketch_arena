import 'package:supabase_edge_functions_example/services/supabase_service.dart';
import 'package:supabase_functions/supabase_functions.dart';
import 'package:sketch_arena/models/player.dart';

Future<Response> exitPlayerFunction(Map<String, dynamic> body) async {
  final player = Player.fromMap(body);

  await SupabaseService.instance.exitPlayer(player);

  return Response.json({});
}
