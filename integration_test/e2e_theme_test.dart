// E2E: choosing the dark theme changes the app and is saved on the device.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mathfinity/others/constants.dart';
import 'package:mathfinity/others/states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('dark theme is applied and saved', (tester) async {
    await bootApp(tester);

    await tester.tap(find.byIcon(Icons.palette_rounded));
    await pumpUntilFound(tester, find.text('Apply Theme'),
        timeout: const Duration(seconds: 10));
    await tester.tap(find.text('Dark'));
    await tester.pump();
    await tester.tap(find.text('Apply Theme'));

    final dark = await pumpUntilTrue(
        tester,
        () =>
            Theme.of(tester.element(find.text('START GAME'))).brightness ==
            Brightness.dark);
    expect(dark, isTrue, reason: 'the app should turn dark');

    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    expect(prefs.getInt(Constants.THEME_MODE_SP), ThemeMode.dark.index,
        reason: 'the theme should be stored on the device');

    // back to the default
    states.state.setThemeMode(ThemeMode.system);
    await prefs.setInt(Constants.THEME_MODE_SP, ThemeMode.system.index);
  });
}
