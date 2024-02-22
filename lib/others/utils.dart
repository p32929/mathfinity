// ignore_for_file: constant_identifier_names

import 'package:infmath/others/states.dart';
import 'package:prefs/prefs.dart';

const String MIN_NUMBER_SP = "MIN_NUMBER_SP";
const String MAX_NUMBER_SP = "MAX_NUMBER_SP";
const String MAX_TIMER_SP = "MAX_TIMER_SP";

class Utils {
  static List<int> generateNumberArray(int start, int end,
      {bool shuffle = false}) {
    List<int> numbers = [];
    for (int i = start; i <= end; i++) {
      numbers.add(i);
    }

    if (shuffle) {
      numbers = Utils.shuffleArray(numbers);
    }

    return numbers;
  }

  static List<int> shuffleArray(List<int> array) {
    List<int> shuffledArray =
        List.from(array); // Make a copy of the original array
    shuffledArray.shuffle();
    return shuffledArray;
  }

  static getSavedSettings() async {
    await Prefs.init();
    int minNumber = Prefs.getInt(MIN_NUMBER_SP);
    int maxNumber = Prefs.getInt(MAX_NUMBER_SP);
    int maxTimer = Prefs.getInt(MAX_TIMER_SP);

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
    Prefs.setInt(MIN_NUMBER_SP, states.state.minNumber);
    Prefs.setInt(MAX_NUMBER_SP, states.state.maxNumber);
    Prefs.setInt(MAX_TIMER_SP, states.state.maxTimer);
  }
}
