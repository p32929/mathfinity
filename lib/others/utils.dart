import 'dart:math';

import 'package:mathfinity/others/constants.dart';
import 'package:mathfinity/others/states.dart';
import 'package:prefs/prefs.dart';

class Utils {
  static int getRandomNumber(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }

  static List<int> generateNumberArray(int start, int end,
      {bool shuffle = false}) {
    List<int> numbers = [];
    for (int i = start; i <= end; i++) {
      numbers.add(i);
    }

    if (shuffle) {
      numbers = Utils.shuffleArray<int>(numbers);
    }

    return numbers;
  }

  static List<T> shuffleArray<T>(List<T> array) {
    List<T> shuffledArray =
        List.from(array); // Make a copy of the original array
    shuffledArray.shuffle();
    return shuffledArray;
  }

  static getSavedSettings() async {
    await Prefs.init();
    int minNumber = Prefs.getInt(Constants.MIN_NUMBER_SP);
    int maxNumber = Prefs.getInt(Constants.MAX_NUMBER_SP);
    int maxTimer = Prefs.getInt(Constants.MAX_TIMER_SP);
    int gridRows = Prefs.getInt(Constants.NUM_OF_ROWS_SP);
    int gridColumns = Prefs.getInt(Constants.NUM_OF_COLS_SP);

    if (minNumber != 0) {
      states.state.setMinNumber(minNumber);
    }

    if (maxNumber != 0) {
      states.state.setMaxNumber(maxNumber);
    }

    if (maxTimer != 0) {
      states.state.setMaxTimer(maxTimer);
    }

    if (gridRows != 0) {
      states.state.setGridRows(gridRows);
    }

    if (gridColumns != 0) {
      states.state.setGridColumns(gridColumns);
    }

    states.state.setResults(
      getInitNumberList(
        states.state.gridColumns * states.state.gridRows,
      ),
    );
  }

  static saveSettings() {
    Prefs.setInt(Constants.MIN_NUMBER_SP, states.state.minNumber);
    Prefs.setInt(Constants.MAX_NUMBER_SP, states.state.maxNumber);
    Prefs.setInt(Constants.MAX_TIMER_SP, states.state.maxTimer);
    Prefs.setInt(Constants.NUM_OF_ROWS_SP, states.state.gridRows);
    Prefs.setInt(Constants.NUM_OF_COLS_SP, states.state.gridColumns);
  }

  static List<int> generateNumbersCloseTo(int answer, {int count = 4}) {
    List<int> numbers = [];
    int lastDigit = answer % 10;

    for (int i = 1; i <= count; i++) {
      int newNumber = answer + (i * 10);

      // Adjust the last digit to match `answer`
      newNumber = (newNumber ~/ 10) * 10 + lastDigit;

      numbers.add(newNumber);
    }

    return numbers;
  }

  static List<int> getInitNumberList(int count) {
    if (count <= 0) return [];

    // Static array with the desired sequence
    List<int> baseNumbers = [
      12,
      34,
      56,
      78,
      90,
      13,
      24,
      57,
      68,
      79,
      91,
      23,
      45,
      67,
      89,
      10
    ];

    // Get the first `count` numbers, cycling through if necessary
    List<int> result = List.generate(
        count, (index) => baseNumbers[index % baseNumbers.length]);

    return result;
  }
}
