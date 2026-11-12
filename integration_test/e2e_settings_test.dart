// E2E: game settings are saved on the device and loaded again on the next
// start.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mathfinity/others/constants.dart';
import 'package:mathfinity/others/states.dart';
import 'package:mathfinity/others/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('saved settings survive a restart', (tester) async {
    await bootApp(tester);
    final s = states.state;

    await tester.tap(find.byIcon(Icons.settings_rounded));
    await pumpUntilFound(tester, find.text('Save Settings'),
        timeout: const Duration(seconds: 10));
    s.setMaxTimer(123);
    s.setGridRows(3);
    await tester.pump();
    await tester.tap(find.text('Save Settings'));

    // written to the device's storage
    final prefs = await SharedPreferences.getInstance();
    var saved = false;
    for (var i = 0; i < 50 && !saved; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      await prefs.reload();
      saved = prefs.getInt(Constants.MAX_TIMER_SP) == 123 &&
          prefs.getInt(Constants.NUM_OF_ROWS_SP) == 3;
    }
    expect(saved, isTrue, reason: 'settings should be stored on the device');

    // "restart": forget the values, then load them like the app does at start
    s.maxTimer = 90;
    s.gridRows = 4;
    await Utils.getSavedSettings();
    expect(s.maxTimer, 123);
    expect(s.gridRows, 3);

    // put the defaults back
    s.setMaxTimer(90);
    s.setGridRows(4);
    Utils.saveSettings();
  });
}
