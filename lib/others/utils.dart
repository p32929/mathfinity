import 'package:mathfinity/others/constants.dart';
import 'package:mathfinity/others/states.dart';
import 'package:prefs/prefs.dart';

class Utils {
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

    if (minNumber != 0) {
      states.state.setMinNumber(minNumber);
    }

    if (maxNumber != 0) {
      states.state.setMaxNumber(maxNumber);
    }

    if (maxTimer != 0) {
      states.state.setMaxTimer(maxTimer);
    }
  }

  static saveSettings() {
    Prefs.setInt(Constants.MIN_NUMBER_SP, states.state.minNumber);
    Prefs.setInt(Constants.MAX_NUMBER_SP, states.state.maxNumber);
    Prefs.setInt(Constants.MAX_TIMER_SP, states.state.maxTimer);
  }

  static List<int> generateNumbersCloseTo(int number) {
    List<int> numbers = [];
    int delta = Utils.generateNumberArray(1, 7, shuffle: true)[0];

    // Generate 4 numbers close to the given number
    for (int i = 1; i <= 4; i++) {
      int newNumber = number + delta * i;
      if (!numbers.contains(newNumber)) {
        numbers.add(newNumber);
      }
    }

    return numbers;
  }
}
