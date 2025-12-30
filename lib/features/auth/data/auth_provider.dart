import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Session? build() {
    // Listen to auth state changes
    final subscription =
        SupabaseService().client.auth.onAuthStateChange.listen((data) {
      state = data.session;
    });

    // Dispose subscription when provider is disposed
    ref.onDispose(() {
      subscription.cancel();
    });

    return SupabaseService().client.auth.currentSession;
  }

  Future<void> signIn({required String email, required String password}) async {
    await SupabaseService().client.auth.signInWithPassword(
          email: email,
          password: password,
        );
  }

  Future<void> signUp({required String email, required String password}) async {
    await SupabaseService().client.auth.signUp(
          email: email,
          password: password,
        );
  }

  Future<void> signOut() async {
    await SupabaseService().client.auth.signOut();
  }
}
