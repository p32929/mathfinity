// E2E: play a real game. A right answer and a wrong answer are counted, and
// stopping the game shows the results.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mathfinity/others/states.dart';
import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('play a game: right and wrong answers are counted',
      (tester) async {
    await bootApp(tester);
    final s = states.state;

    await tester.tap(find.text('START GAME'));
    expect(
        await pumpUntilTrue(
            tester, () => s.isGameRunning && s.correctAnsIndex >= 0),
        isTrue,
        reason: 'the game should start with a question');

    // the right answer
    await tester.tap(find.byKey(ValueKey('answer_${s.correctAnsIndex}')));
    expect(await pumpUntilTrue(tester, () => s.totalTrue == 1), isTrue,
        reason: 'a right answer should be counted');
    await pumpUntilTrue(tester, () => !s.isChangingEquation);

    // a wrong answer
    final wrong = s.correctAnsIndex == 0 ? 1 : 0;
    await tester.tap(find.byKey(ValueKey('answer_$wrong')));
    expect(await pumpUntilTrue(tester, () => s.totalFalse == 1), isTrue,
        reason: 'a wrong answer should be counted');
    await pumpUntilTrue(tester, () => !s.isChangingEquation);

    await tester.tap(find.text('STOP GAME'));
    await pumpUntilFound(tester, find.text('Game Over!'),
        timeout: const Duration(seconds: 10),
        reason: 'the results after stopping');
    expect(s.isGameRunning, isFalse);
  });
}
