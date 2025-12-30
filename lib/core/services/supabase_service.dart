import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  final Logger _logger = Logger();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  Future<void> initialize() async {
    try {
      await dotenv.load(fileName: ".env");

      final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final String supabaseKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ??
          dotenv.env['SUPABASE_ANON_KEY'] ??
          '';

      if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
        throw Exception(
            'Supabase URL or Key (Anon/Publishable) is missing in .env');
      }

      String finalUrl = supabaseUrl;

      // For local development on Android:
      // - Physical devices: Use ADB reverse (adb reverse tcp:54321 tcp:54321) and keep 127.0.0.1
      // - Emulators: Use 10.0.2.2 to reach host machine
      // Note: For physical devices, run: adb reverse tcp:54321 tcp:54321
      // For now, we keep the URL as-is and rely on ADB reverse for physical devices.
      // Uncomment below if using an emulator and not using ADB reverse.
      /*
      if (Platform.isAndroid &&
          (supabaseUrl.contains('127.0.0.1') ||
              supabaseUrl.contains('localhost'))) {
        finalUrl = supabaseUrl
            .replaceAll('127.0.0.1', '10.0.2.2')
            .replaceAll('localhost', '10.0.2.2');
        _logger.d('Adjusted Supabase URL for Android emulator: $finalUrl');
      }
      */
      _logger.d('Using Supabase URL: $finalUrl');

      await Supabase.initialize(
        url: finalUrl,
        anonKey: supabaseKey,
        debug: dotenv.env['ENVIRONMENT'] == 'development',
      );

      _logger.i('Supabase initialized successfully');
    } catch (e) {
      _logger.e('Error initializing Supabase: $e');
      rethrow;
    }
  }
}
