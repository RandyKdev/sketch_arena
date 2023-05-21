import 'package:sketch_arena/models/round.dart';
import 'package:supabase_edge_functions_example/services/supabase_service.dart';
import 'package:supabase_functions/supabase_functions.dart';

Future<Response> createRoundFunction(Map<String, dynamic> body) async {
  final round = Round.fromMap(body);
  final createdRound = await SupabaseService.instance.createRound(round);

  if (createdRound == null) {
    return Response.error();
  }

  return Response.json(createdRound.toMap());
}
