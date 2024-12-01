import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mathfinity/others/constants.dart';
import 'package:mathfinity/others/states.dart';
import 'package:mathfinity/others/utils.dart';
import 'package:one_context/one_context.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Timer? gameTimer;

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  Widget getInfoWidgets(
      {String text = "0", IconData icon = Icons.menu, Color? color}) {
    const dividerText = '-:-';
    return Expanded(
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
    );
  }

  Color getResultButtonRippleColor(int index) {
    if (index == states.state.correctAnsIndex) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Widget buildResultsGrid() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: states.state.gridColumns,
          childAspectRatio: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: states.state.gridRows * states.state.gridColumns,
        itemBuilder: (context, index) {
          return getNumberWidget(index: index);
        },
      ),
    );
  }

  Widget getNumberWidget({int index = 0}) {
    onNumberPressed() async {
      if (states.state.isGameRunning && !states.state.isChangingEquation) {
        states.state.setChangingEquation(true);
        if (states.state.correctAnsIndex == index) {
          states.state.setTotalTrue(states.state.totalTrue + 1);
        } else {
          states.state.setTotalFalse(states.state.totalFalse + 1);
        }
        await Future.delayed(Duration(milliseconds: 250));
        setNewEquationAndResults();
        states.state.setChangingEquation(false);
      }
    }

    return ElevatedButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) {
            return states.contains(WidgetState.pressed)
                ? getResultButtonRippleColor(index)
                : null;
          },
        ),
      ),
      onLongPress: onNumberPressed,
      onPressed: onNumberPressed,
      child: AutoSizeText(
        states.state.results[index].toString(),
        style: GoogleFonts.varelaRound(),
        minFontSize: 18,
        maxFontSize: 36,
      ),
    );
  }

  void onSettingsClicked() {
    OneContext().showDialog(
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
                  Text(
                    "Grid Rows: ${states.state.gridRows}",
                    style: GoogleFonts.varelaRound(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Slider(
                    min: 1,
                    max: 4,
                    divisions: 3,
                    value: states.state.gridRows.toDouble(),
                    onChanged: (value) {
                      states.state.setGridRows(value.toInt());
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Grid Columns: ${states.state.gridColumns}",
                    style: GoogleFonts.varelaRound(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Slider(
                    min: 1,
                    max: 4,
                    divisions: 3,
                    value: states.state.gridColumns.toDouble(),
                    onChanged: (value) {
                      states.state.setGridColumns(value.toInt());
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Utils.saveSettings();
                    OneContext().popDialog();
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

  void onPersonClicked() {
    var sourceCodeLink = "https://github.com/p32929/mathfinity";
    var portfolioLink = "https://p32929.github.io/";

    final Uri sourceCodeUri = Uri.parse(sourceCodeLink);
    final Uri portfolioUri = Uri.parse(portfolioLink);

    OneContext().showDialog(
      barrierDismissible: false,
      builder: (p0) {
        return AlertDialog(
          title: Text(
            "Credits",
            style: GoogleFonts.varelaRound(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Created by Fayaz Bin Salam"),
              Text(
                  "This is an Open Source project. Source code can be found at:  "),
              InkWell(
                onTap: () {
                  launchUrl(sourceCodeUri);
                },
                child: Text(
                  sourceCodeLink,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              Text("Here's my portfolio link:  "),
              InkWell(
                onTap: () {
                  launchUrl(portfolioUri);
                },
                child: Text(
                  portfolioLink,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              Text("Feel free to star, fork, watch. Thanks..."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                OneContext().popDialog();
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
  }

  void stopGame() {
    states.state.setGameRunning(false);
    gameTimer?.cancel();
    showResultDialog();
  }

  void showResultDialog() {
    double accuracy;
    if (states.state.totalFalse != 0) {
      accuracy = (states.state.totalTrue /
              (states.state.totalTrue + states.state.totalFalse)) *
          100;
    } else {
      accuracy =
          states.state.totalTrue + states.state.totalFalse == 0 ? 0 : 100.0;
    }

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
                states.state.setCurrentTimer(0);
                OneContext().popDialog();
              },
              child: Text(
                "OK",
                style: GoogleFonts.varelaRound(),
              ),
            ),
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
                "${states.state.maxTimer - states.state.currentTimer} Seconds Played",
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
    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case 'X':
        return num1 * num2;
      case '/':
        return num1 ~/ num2;
      default:
        return 0;
    }
  }

  void setNewEquationAndResults() {
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
    operators = Utils.shuffleArray<String>(operators);
    var op0 = operators[0];
    states.state.setCurrentOperator(op0);

    if (op0 == "/") {
      int mod = num1 % num2;
      num1 -= mod;
    }
    var answer = getMathResult(num1, num2, op0);

    if (num1 == num2 || answer < 3) {
      return setNewEquationAndResults();
    }

    states.state.setFirstNumber(num1);
    states.state.setSecondNumber(num2);

    int totalOptions = states.state.gridRows * states.state.gridColumns;
    List<int> results =
        Utils.generateNumbersCloseTo(answer, count: totalOptions);
    operators = Utils.shuffleArray<String>(operators);

    int correctIndex = Utils.getRandomNumber(0, totalOptions - 1);
    results[correctIndex] = answer;
    states.state.setCorrectAnsIndex(correctIndex);

    states.state.setResults(results);
  }

  void startGame() {
    states.state.setGameRunning(true);
    states.state.setCurrentTimer(states.state.maxTimer);

    setNewEquationAndResults();
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      int timeLeft = states.state.maxTimer - timer.tick;
      states.state.setCurrentTimer(timeLeft);

      if (timeLeft <= 0) {
        stopGame();
      }
    });
  }

  void onStartStopClicked() {
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
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: states.state.isGameRunning ? null : onPersonClicked,
              icon: Icon(
                Icons.account_circle,
                color: states.state.isGameRunning
                    ? Colors.grey
                    : Theme.of(OneContext.instance.context!)
                        .colorScheme
                        .primary,
              ),
            ),
            IconButton(
              onPressed: states.state.isGameRunning ? null : onSettingsClicked,
              icon: Icon(
                Icons.settings,
                color: states.state.isGameRunning
                    ? Colors.grey
                    : Theme.of(OneContext.instance.context!)
                        .colorScheme
                        .primary,
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
                  icon: states.state.currentTimer % 2 == 0
                      ? Icons.hourglass_bottom
                      : Icons.hourglass_top,
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
            SizedBox(height: 16),
            Text(
              "${states.state.firstNumber} ${states.state.currentOperator} ${states.state.secondNumber}",
              style: GoogleFonts.varelaRound(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                letterSpacing: 12,
              ),
            ),
            SizedBox(height: 16),
            buildResultsGrid(),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith(
                    (buttonState) {
                      return buttonState.contains(WidgetState.pressed)
                          ? (states.state.isGameRunning
                              ? Colors.red
                              : Colors.green)
                          : null;
                    },
                  ),
                ),
                onPressed: onStartStopClicked,
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
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
