import 'package:states_rebuilder/states_rebuilder.dart';

class States {
  int minNumber = 1, maxNumber = 999, timer = 30;
  int firstNumber = 12, secondNumber = 34;

  setMinNumber(int num) {
    print("setMinNumber: $num");
    minNumber = num;
    states.notify();
  }

  setMaxNumber(int num) {
    print("setMaxNumber: $num");
    maxNumber = num;
    states.notify();
  }

  setTimer(int num) {
    print("setTimer: $num");
    timer = num;
    states.notify();
  }
}

final states = RM.inject(() => States());
