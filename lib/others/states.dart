import 'package:mathfinity/others/constants.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class States {
  int minNumber = Constants.minNumber,
      maxNumber = Constants.maxNumber,
      maxTimer = 90;

  int firstNumber = 12,
      secondNumber = 34,
      currentTimer = 0,
      totalTrue = 0,
      totalFalse = 0;

  String currentOperator = "X";
  int correctAnsIndex = -1;

  bool isGameRunning = false;
  bool isChangingEquation = false;

  var results = [
    12,
    45,
    78,
    36,

    // 9980,
    // 9980,
    // 9980,
    // 9980,
  ];

  setMinNumber(int num) {
    minNumber = num;
    states.notify();
  }

  setMaxNumber(int num) {
    maxNumber = num;
    states.notify();
  }

  setMaxTimer(int num) {
    maxTimer = num;
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

  setChangingEquation(bool b) {
    isChangingEquation = b;
    states.notify();
  }

  setCorrectAnsIndex(int num) {
    correctAnsIndex = num;
    states.notify();
  }

  setResults(List<int> results) {
    this.results = results;
    states.notify();
  }
}

final states = RM.inject(() => States());
