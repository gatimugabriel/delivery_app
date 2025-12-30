## Development

### Android
- Physical devices: Use ADB reverse (adb reverse tcp:54321 tcp:54321) and keep 127.0.0.1 
exact command: adb -s <device_serial> reverse tcp:54321 tcp:54321
- Emulators: Use 10.0.2.2 to reach host machine
Note: For physical devices, run: adb reverse tcp:54321 tcp:54321
For now, we keep the URL as-is and rely on ADB reverse for physical devices.
Uncomment below if using an emulator and not using ADB reverse.

this happens in supabase_service.dart

```dart
if (Platform.isAndroid &&
    (supabaseUrl.contains('127.0.0.1') ||
        supabaseUrl.contains('localhost'))) {
  finalUrl = supabaseUrl
      .replaceAll('127.0.0.1', '10.0.2.2')
      .replaceAll('localhost', '10.0.2.2');
  _logger.d('Adjusted Supabase URL for Android emulator: $finalUrl');
}
```