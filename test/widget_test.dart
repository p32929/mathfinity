// Checks the wrong-answer list for the grid: the right count, all different.
import 'package:flutter_test/flutter_test.dart';
import 'package:mathfinity/others/utils.dart';

void main() {
  test('answer list has the requested number of different numbers', () {
    final list = Utils.generateNumbersCloseTo(276, count: 16);
    expect(list.length, 16);
    expect(list.toSet().length, 16);
  });
}
