import 'package:sketch_arena/models/room.dart';
import 'package:sketch_arena/models/round.dart';
import 'package:supabase_edge_functions_example/services/supabase_service.dart';
import 'package:supabase_functions/supabase_functions.dart';

Future<Response> endCurrentRoundFunction(Map<String, dynamic> body) async {
  final round = Round.fromMap(body);
  final room = Room.fromMap(body);

  await SupabaseService.instance.endCurrentRound(room: room, round: round);

  final isGameOver = await SupabaseService.instance.isGameOver(room);

  if (isGameOver) {
    return Response.json({
      'isGameOver': isGameOver,
    });
  }

  final nextPlayer = await SupabaseService.instance.getNextPlayer(room);

  if (nextPlayer == null) {
    return Response.json({
      'isGameOver': isGameOver,
    });
  }

  final words = SupabaseService.instance.getChoiceWords();

  return Response.json({
    'isGameOver': isGameOver,
    'nextPlayerId': nextPlayer.playerId,
    'words': words,
  });
}
