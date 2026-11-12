// Checks the wrong-answer list for the grid: the right count, all different.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathfinity/others/utils.dart';

void main() {
  test('answer list has the requested number of different numbers', () {
    final list = Utils.generateNumbersCloseTo(276, count: 16);
    expect(list.length, 16);
    expect(list.toSet().length, 16);
  });

  // The app's text uses the bundled Varela Round font: it must be listed in
  // pubspec.yaml and the file must exist, or every screen silently falls back.
  test('the Varela Round font is bundled', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('family: VarelaRound'));
    expect(File('assets/fonts/VarelaRound-Regular.ttf').existsSync(), isTrue);
  });
}
