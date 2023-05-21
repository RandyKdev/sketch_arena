import 'dart:convert';

import 'package:supabase_edge_functions_example/functions/create_player_function.dart';
import 'package:supabase_edge_functions_example/functions/create_room_function.dart';
import 'package:supabase_edge_functions_example/functions/create_round_function.dart';
import 'package:supabase_edge_functions_example/functions/end_current_round_function.dart';
import 'package:supabase_edge_functions_example/functions/exit_player_function.dart';
import 'package:supabase_edge_functions_example/functions/join_room_function.dart';
import 'package:supabase_edge_functions_example/functions/send_message_function.dart';
import 'package:supabase_edge_functions_example/services/supabase_service.dart';
import 'package:supabase_functions/supabase_functions.dart';

void main() {
  SupabaseService.init();

  SupabaseFunctions(fetch: (request) async {
    if (request.body == null) return Response.error();

    final bodyString = await Utf8Decoder().bind(request.body!).join();
    final bodyJson = jsonDecode(bodyString);

    final invokeCode = bodyJson['invokeCode'];

    if (invokeCode is! String) return Response.error();

    late Response response;
    switch (invokeCode) {
      case 'createPlayer':
        response = await createPlayerFunction(bodyJson);
        break;
      case 'createRoom':
        response = await createRoomFunction(bodyJson);
        break;
      case 'joinRoom':
        response = await joinRoomFunction(bodyJson);
        break;
      case 'createRound':
        response = await createRoundFunction(bodyJson);
        break;
      case 'endCurrentRound':
        response = await endCurrentRoundFunction(bodyJson);
        break;
      case 'exitPlayer':
        response = await exitPlayerFunction(bodyJson);
        break;
      case 'sendMessage':
        response = await sendMessageFunction(bodyJson);
        break;
      default:
        response = Response.error();
    }

    return response;
  });
}
