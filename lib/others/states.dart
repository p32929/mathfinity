import 'package:states_rebuilder/states_rebuilder.dart';

class States {
  int minNumber = 1, maxNumber = 999, timer = 30;
  int firstNumber = 12,
      secondNumber = 34,
      currentTimer = 0,
      totalTrue = 0,
      totalFalse = 0;
  String currentOperator = "X";
  bool isGameRunning = false;

  setMinNumber(int num) {
    minNumber = num;
    states.notify();
  }

  setMaxNumber(int num) {
    maxNumber = num;
    states.notify();
  }

  setTimer(int num) {
    timer = num;
    states.notify();
  }

  setFirstNumber(int num) {
    firstNumber = num;
    states.notify();
  }

  setSecondNumber(int num) {
    secondNumber = num;
    states.notify();
  }

  setCurrentTimer(int num) {
    currentTimer = num;
    states.notify();
  }

  setTotalTrue(int num) {
    totalTrue = num;
    states.notify();
  }

  setTotalFalse(int num) {
    totalFalse = num;
    states.notify();
  }

  setCurrentOperator(String op) {
    currentOperator = op;
    states.notify();
  }

  setGameRunning(bool b) {
    isGameRunning = b;
    states.notify();
  }
}

final states = RM.inject(() => States());
