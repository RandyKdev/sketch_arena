// import 'dart:convert';

import 'package:supabase_functions/supabase_functions.dart';
import 'package:edge_http_client/edge_http_client.dart';
import 'package:supabase/supabase.dart';

void main() {
  final supabase = SupabaseClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    httpClient: EdgeHttpClient(),
  );

  SupabaseFunctions(fetch: (request) async {
    print((await request.formData()).get('invokeCode'));
    final List users = await supabase.from('PLAYERS').select().limit(10);
    return Response.json(users);
  });
}
