// Shared E2E helpers: boot the REAL app and wait for it.
// Not a *_test.dart file, so the test runner won't execute it directly.
import 'package:flutter_test/flutter_test.dart';
import 'package:mathfinity/main.dart' as app;

/// Pumps frames (real time) until [finder] matches something or we time out.
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 60),
  String? reason,
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure(
      'Timed out after ${timeout.inSeconds}s waiting for ${reason ?? finder.description}');
}

/// Polls [condition] (real time) until true or timeout. Returns whether it hit.
Future<bool> pumpUntilTrue(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (condition()) return true;
  }
  return false;
}

/// Launches the real app and waits for the start button.
Future<void> bootApp(WidgetTester tester) async {
  app.main();
  await pumpUntilFound(tester, find.text('START GAME'),
      reason: 'the START GAME button after the app starts');
}
