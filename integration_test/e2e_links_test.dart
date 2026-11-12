// E2E: the About sheet opens and its web links can be opened by the system.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('About links can be opened', (tester) async {
    await bootApp(tester);

    await tester.tap(find.byIcon(Icons.info_rounded));
    await pumpUntilFound(tester, find.text('https://github.com/p32929/mathfinity'),
        timeout: const Duration(seconds: 10),
        reason: 'the About sheet with its links');

    final ok =
        await canLaunchUrl(Uri.parse('https://github.com/p32929/mathfinity'));
    expect(ok, isTrue, reason: 'a browser should be available for links');
  });
}
