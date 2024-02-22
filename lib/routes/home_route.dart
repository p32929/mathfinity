import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infmath/others/constants.dart';
import 'package:infmath/others/states.dart';
import 'package:infmath/others/utils.dart';
import 'package:one_context/one_context.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:google_fonts/google_fonts.dart';

Timer? gameTimer;

const double rowPaddings = 8;
const double numberButtonSizePadding = 48;

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  getInfoWidgets(
      {String text = "0", IconData icon = Icons.menu, Color? color}) {
    const dividerText = '-:-';
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(rowPaddings),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              dividerText,
              style: GoogleFonts.varelaRound(
                color: Colors.blueGrey,
              ),
            ),
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            Text(
              text,
              style: GoogleFonts.varelaRound(
                fontSize: 24,
                color: color,
              ),
            ),
            Text(
              dividerText,
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getResultButtonRippleColor(int index) {
    if (index == states.state.correctAnsIndex) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  getNumberWidget({int index = 0}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? getResultButtonRippleColor(index)
                  : null;
            },
          ),
        ),
        onPressed: () {
          if (states.state.isGameRunning) {
            if (states.state.correctAnsIndex == index) {
              states.state.setTotalTrue(states.state.totalTrue + 1);
            } else {
              states.state.setTotalFalse(states.state.totalFalse + 1);
            }
            setNewEquationAndResults();
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: numberButtonSizePadding),
          child: Text(
            states.state.results[index].toString(),
            style: GoogleFonts.varelaRound(
              fontSize: numberButtonSizePadding,
            ),
          ),
        ),
      ),
    );
  }

  onSettingsClicked() {
    OneContext.instance.showDialog(
      barrierDismissible: false,
      builder: (p0) {
        return StateBuilder(
          observe: () => states,
          builder: (context, _) {
            return AlertDialog(
              title: Text(
                "Settings",
                style: GoogleFonts.varelaRound(),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smallest number: ${states.state.minNumber}",
                    style: GoogleFonts.varelaRound(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Slider(
                    min: Constants.minNumber.toDouble(),
                    max: states.state.maxNumber - 1,
                    value: states.state.minNumber.toDouble(),
                    onChanged: (value) {
                      states.state.setMinNumber(value.toInt());
                    },
                  ),
                  Padding(padding: const EdgeInsets.all(rowPaddings)),
                  Text(
                    "Biggest number: ${states.state.maxNumber}",
                    style: GoogleFonts.varelaRound(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Slider(
                    min: states.state.minNumber + 1,
                    max: Constants.maxNumber.toDouble(),
                    value: states.state.maxNumber.toDouble(),
                    onChanged: (value) {
                      states.state.setMaxNumber(value.toInt());
                    },
                  ),
                  Padding(padding: const EdgeInsets.all(rowPaddings)),
                  Text(
                    "Timer: ${states.state.maxTimer}",
                    style: GoogleFonts.varelaRound(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Slider(
                    min: Constants.minTimer.toDouble(),
                    max: Constants.maxTimer.toDouble(),
                    value: states.state.maxTimer.toDouble(),
                    onChanged: (value) {
                      states.state.setMaxTimer(value.toInt());
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Utils.saveSettings();
                    Navigator.pop(OneContext.instance.context!);
                  },
                  child: Text(
                    "OK",
                    style: GoogleFonts.varelaRound(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  stopGame() {
    states.state.setGameRunning(!states.state.isGameRunning);
    states.state.setCurrentTimer(0);
    gameTimer?.cancel();

    showResultDialog();
  }

  showResultDialog() {
    double accuracy;
    if (states.state.totalFalse != 0) {
      accuracy = (states.state.totalTrue /
              (states.state.totalTrue + states.state.totalFalse)) *
          100;
    } else {
      accuracy = 100.0; // If totalFalse is 0, accuracy is 100%
    }
    print("accuracy: $accuracy");

    OneContext.instance.showDialog(
      barrierDismissible: false,
      builder: (p0) {
        return AlertDialog(
          title: Text(
            "Game over",
            style: GoogleFonts.varelaRound(),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  states.state.setTotalTrue(0);
                  states.state.setTotalFalse(0);
                  // OneContext.instance.popAllDialogs();
                  Navigator.pop(OneContext.instance.context!);
                },
                child: Text(
                  "OK",
                  style: GoogleFonts.varelaRound(),
                )),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${states.state.totalTrue} Correct Answers",
                style: GoogleFonts.varelaRound(
                  fontSize: 16,
                ),
              ),
              Text(
                "${states.state.totalFalse} Wrong Answers",
                style: GoogleFonts.varelaRound(
                  fontSize: 16,
                ),
              ),
              Text(
                "Accuracy ${accuracy.toStringAsFixed(2)}%",
                style: GoogleFonts.varelaRound(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int getMathResult(int num1, int num2, String operator) {
    if (operator == '+') {
      return num1 + num2;
    } else if (operator == '-') {
      return num1 - num2;
    } else if (operator == 'X') {
      return num1 * num2;
    } else if (operator == '/') {
      return num1 ~/ num2;
    }

    return 0;
  }

  setNewEquationAndResults() {
    var numbersArray = Utils.generateNumberArray(
      states.state.minNumber,
      states.state.maxNumber,
      shuffle: true,
    );

    int num1 = numbersArray[0];
    int num2 = numbersArray[1];

    if (num2 > num1) {
      int temp = num1;
      num1 = num2;
      num2 = temp;
    }

    var operators = ["+", "-", "X", "/"];
    var operatorsRand = Utils.generateNumberArray(
      0,
      operators.length - 1,
      shuffle: true,
    );
    var op0 = operators[operatorsRand[0]];
    states.state.setCurrentOperator(op0);

    if (op0 == "/") {
      int mod = num1 % num2;
      num1 -= mod;
    }
    states.state.setFirstNumber(num1);
    states.state.setSecondNumber(num2);

    List<int> results = [];
    for (var i = 0; i < operators.length; i++) {
      var op = operators[operatorsRand[i]];
      var resultVal = getMathResult(num1, num2, op);
      results.add(resultVal);
    }

    results = Utils.shuffleArray(results);
    for (var i = 0; i < results.length; i++) {
      var mr = getMathResult(num1, num2, op0);
      if (results[i] == mr) {
        states.state.setCorrectAnsIndex(i);
      } else {
        if (results[i] < 20) {
          var newNum = Utils.generateNumberArray(21, 100, shuffle: true)[0];
          results[i] = newNum;
        }
      }
    }
    states.state.setResults(results);
  }

  startGame() {
    states.state.setGameRunning(!states.state.isGameRunning);
    setNewEquationAndResults();
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      int timeLeft = states.state.maxTimer - timer.tick;
      states.state.setCurrentTimer(timeLeft);

      if (timeLeft <= 0) {
        stopGame();
      }
    });
  }

  onStartStopClicked() {
    if (states.state.isGameRunning) {
      stopGame();
    } else {
      startGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      observe: () => states,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            "MathFinity",
            style: GoogleFonts.varelaRound(
              color: Theme.of(OneContext.instance.context!).colorScheme.primary,
              // fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                onSettingsClicked();
              },
              icon: Icon(
                Icons.settings,
                color:
                    Theme.of(OneContext.instance.context!).colorScheme.primary,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                getInfoWidgets(
                  icon: Icons.check_circle,
                  color: Theme.of(OneContext.instance.context!)
                      .colorScheme
                      .primary,
                  text: states.state.totalTrue.toString(),
                ),
                getInfoWidgets(
                  icon: Icons.hourglass_top,
                  color:
                      Theme.of(OneContext.instance.context!).colorScheme.error,
                  text: states.state.currentTimer.toString(),
                ),
                getInfoWidgets(
                  icon: Icons.cancel,
                  color:
                      Theme.of(OneContext.instance.context!).colorScheme.error,
                  text: states.state.totalFalse.toString(),
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.all(rowPaddings)),
            Text(
              "${states.state.firstNumber} ${states.state.currentOperator} ${states.state.secondNumber}",
              style: GoogleFonts.varelaRound(
                fontSize: 36,
                // color:
                //     Theme.of(OneContext.instance.context!).colorScheme.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 12,
              ),
            ),
            Padding(padding: const EdgeInsets.all(rowPaddings)),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: rowPaddings,
                horizontal: rowPaddings * 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getNumberWidget(index: 0),
                  Padding(padding: const EdgeInsets.all(rowPaddings)),
                  getNumberWidget(index: 1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: rowPaddings,
                horizontal: rowPaddings * 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getNumberWidget(index: 2),
                  Padding(padding: const EdgeInsets.all(rowPaddings)),
                  getNumberWidget(index: 3),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(rowPaddings)),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith(
                          (buttonState) {
                            getColor() {
                              if (states.state.isGameRunning) {
                                return Colors.red;
                              } else {
                                return Colors.green;
                              }
                            }

                            return buttonState.contains(MaterialState.pressed)
                                ? getColor()
                                : null;
                          },
                        ),
                      ),
                      onPressed: () {
                        onStartStopClicked();
                        // setEquationAndResults();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          states.state.isGameRunning ? "STOP" : "START",
                          style: GoogleFonts.varelaRound(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
