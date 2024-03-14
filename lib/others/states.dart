import 'package:flutter/material.dart';
import 'package:mathfinity/others/constants.dart';
import 'package:mathfinity/others/utils.dart';
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
  int? lastClickedIndex;
  int gridColumns = 4;
  int gridRows = 4;

  bool isGameRunning = false;
  bool isChangingEquation = false;
  bool shouldAnimateStartButton = false;

  var results = List.generate(16, (index) => index + 1);

  // Shuffled arithmetic signs pool
  List<String> operatorPool = [];
  
  // Theme settings
  ThemeMode themeMode = ThemeMode.system;
  Color seedColor = Colors.teal;

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

  setShouldAnimateStartButton(bool b) {
    shouldAnimateStartButton = b;
    states.notify();
  }

  setCorrectAnsIndex(int num) {
    correctAnsIndex = num;
    states.notify();
  }

  setLastClickedIndex(int? index) {
    lastClickedIndex = index;
    states.notify();
  }

  setGridColumns(int num) {
    gridColumns = num;
    var res = Utils.generateNumbersCloseTo(
      276,
      count: states.state.gridColumns * states.state.gridRows,
    );
    states.state.results = res;
    states.notify();
  }

  setGridRows(int num) {
    gridRows = num;
    var res = Utils.generateNumbersCloseTo(
      276,
      count: states.state.gridColumns * states.state.gridRows,
    );
    states.state.results = res;
    states.notify();
  }

  setResults(List<int> results) {
    this.results = results;
    states.notify();
  }

  setThemeMode(ThemeMode mode) {
    themeMode = mode;
    states.notify();
  }

  setSeedColor(Color color) {
    seedColor = color;
    states.notify();
  }

  // Operator pool management methods
  void _refillOperatorPool() {
    operatorPool = ["+", "-", "X", "/"];
    operatorPool.shuffle();
  }

  void initializeOperatorPool() {
    operatorPool.clear();
    _refillOperatorPool();
  }

  String getNextOperator() {
    if (operatorPool.isEmpty) {
      _refillOperatorPool();
    }
    return operatorPool.removeLast();
  }

  void putBackOperator(String operator) {
    operatorPool.add(operator);
  }
}

final states = RM.inject(() => States());
