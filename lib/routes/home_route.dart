import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infmath/others/states.dart';
import 'package:one_context/one_context.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:google_fonts/google_fonts.dart';

Timer? gameTimer;

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    const double rowPaddings = 8;
    const double numberButtonSizePadding = 48;

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

    getNumberWidget({String text = "0"}) {
      return Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.pressed)
                    ? Colors.red
                    : null;
              },
            ),
          ),
          onPressed: () {},
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: numberButtonSizePadding),
            child: Text(
              text,
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
                      min: 1,
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
                      max: 999,
                      value: states.state.maxNumber.toDouble(),
                      onChanged: (value) {
                        states.state.setMaxNumber(value.toInt());
                      },
                    ),
                    Padding(padding: const EdgeInsets.all(rowPaddings)),
                    Text(
                      "Timer: ${states.state.timer}",
                      style: GoogleFonts.varelaRound(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Slider(
                      min: 1,
                      max: 120,
                      value: states.state.timer.toDouble(),
                      onChanged: (value) {
                        states.state.setTimer(value.toInt());
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        OneContext.instance.popAllDialogs();
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.varelaRound(),
                      )),
                  TextButton(
                      onPressed: () {
                        OneContext.instance.popAllDialogs();
                      },
                      child: Text(
                        "OK",
                        style: GoogleFonts.varelaRound(),
                      )),
                ],
              );
            },
          );
        },
      );
    }

    startGame() {
      if (states.state.isGameRunning) {
        states.state.setGameRunning(!states.state.isGameRunning);
        states.state.setCurrentTimer(0);
        gameTimer?.cancel();
        //
      } else {
        states.state.setGameRunning(!states.state.isGameRunning);
        gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          int timeLeft = states.state.timer - timer.tick;
          states.state.setCurrentTimer(timeLeft);
          if (timeLeft <= 0) {
            timer.cancel();
            states.state.setGameRunning(!states.state.isGameRunning);
          }
        });
      }
    }

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
                  getNumberWidget(text: "999"),
                  Padding(padding: const EdgeInsets.all(rowPaddings)),
                  getNumberWidget(text: "999"),
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
                  getNumberWidget(text: "999"),
                  Padding(padding: const EdgeInsets.all(rowPaddings)),
                  getNumberWidget(text: "999"),
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
                                return Theme.of(OneContext.instance.context!)
                                    .colorScheme
                                    .error;
                              } else {
                                return Theme.of(OneContext.instance.context!)
                                    .colorScheme
                                    .primary;
                              }
                            }

                            return buttonState.contains(MaterialState.pressed)
                                ? getColor()
                                : null;
                          },
                        ),
                      ),
                      onPressed: () {
                        startGame();
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
