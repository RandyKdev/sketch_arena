import 'package:supabase_edge_functions_example/services/supabase_service.dart';
import 'package:supabase_functions/supabase_functions.dart';
import 'package:sketch_arena/models/message.dart';

Future<Response> sendMessageFunction(Map<String, dynamic> body) async {
  final message = Message.fromMap(body);

  final createdMessage = await SupabaseService.instance.createMessage(message);

  if (createdMessage == null) return Response.error();

  return Response.json(createdMessage.toMap());
}
