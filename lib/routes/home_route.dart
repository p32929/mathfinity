import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mathfinity/others/constants.dart';
import 'package:mathfinity/others/states.dart';
import 'package:mathfinity/others/utils.dart';
import 'package:one_context/one_context.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Timer? gameTimer;

// Smoothly pulses its child (scale) while [pulse] is true, to draw the
// user's eye to the start button. Uses a repeating AnimationController
// instead of a one-shot tween so the motion stays continuous and settles
// gently when [pulse] turns off.
class _PulsingButton extends StatefulWidget {
  final bool pulse;
  final Widget child;

  const _PulsingButton({required this.pulse, required this.child});

  @override
  State<_PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<_PulsingButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _scale = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ).drive(Tween(begin: 1.0, end: 1.06));

  @override
  void initState() {
    super.initState();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant _PulsingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.pulse) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else if (_controller.isAnimating || _controller.value != 0) {
      _controller.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
      child: widget.child,
    );
  }
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      observe: () => states,
      builder: (context, _) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "MathFinity",
            style: GoogleFonts.varelaRound(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: states.state.isGameRunning ? null : _showThemeSettings,
              icon: Icon(
                Icons.palette_rounded,
                color: states.state.isGameRunning ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3) : null,
              ),
            ),
            IconButton(
              onPressed: states.state.isGameRunning ? null : _showSettings,
              icon: Icon(
                Icons.settings_rounded,
                color: states.state.isGameRunning ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3) : null,
              ),
            ),
            IconButton(
              onPressed: states.state.isGameRunning ? null : _showAbout,
              icon: Icon(
                Icons.info_rounded,
                color: states.state.isGameRunning ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3) : null,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Stats Row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildStatsRow(context),
              ),
              const SizedBox(height: 12),

              // Equation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildEquation(context),
              ),
              const SizedBox(height: 12),

              // Numbers Grid - Expanded to fill available space
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildNumbersGrid(context),
                ),
              ),
              const SizedBox(height: 12),

              // Start Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildStartButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Correct',
            states.state.totalTrue.toString(),
            Icons.check_circle_rounded,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Timer',
            states.state.currentTimer.toString(),
            Icons.timer_rounded,
            Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Wrong',
            states.state.totalFalse.toString(),
            Icons.cancel_rounded,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.varelaRound(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.varelaRound(
              fontSize: 10,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquation(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          "${states.state.firstNumber} ${states.state.currentOperator} ${states.state.secondNumber} = ?",
          style: GoogleFonts.varelaRound(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildNumbersGrid(BuildContext context) {
    int columns = states.state.gridColumns;
    int rows = states.state.gridRows;
    int totalItems = rows * columns;

    // Ensure results array has enough items
    List<int> displayNumbers = [];
    if (states.state.results.length < totalItems) {
      // If not enough results, generate sequential numbers
      for (int i = 0; i < totalItems; i++) {
        displayNumbers.add(i + 1);
      }
    } else {
      displayNumbers = List<int>.from(states.state.results.take(totalItems));
    }

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Expanded(
          child: Row(
            children: List.generate(columns, (colIndex) {
              int index = rowIndex * columns + colIndex;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _onNumberTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getGridItemColor(context, index),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getGridItemBorderColor(context, index),
                            width: 2,
                          ),
                          boxShadow: _getGridItemGlow(context, index),
                        ),
                        child: Center(
                          child: Text(
                            displayNumbers[index].toString(),
                            style: GoogleFonts.varelaRound(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    bool guiding = states.state.shouldAnimateStartButton;

    return _PulsingButton(
      pulse: guiding,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: guiding
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ]
              : [],
        ),
        child: FilledButton(
          onPressed: _onStartStop,
          style: FilledButton.styleFrom(
            backgroundColor: states.state.isGameRunning
                ? Theme.of(context).colorScheme.error
                : guiding
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.9)
                    : Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: guiding
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow_rounded, size: 24, color: Colors.white),
                          const SizedBox(width: 8),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              Text(
                states.state.isGameRunning ? "STOP GAME" : "START GAME",
                style: GoogleFonts.varelaRound(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Game Logic
  void _onNumberTap(int index) async {
    if (states.state.isGameRunning && !states.state.isChangingEquation) {
      states.state.setLastClickedIndex(index);
      states.state.setChangingEquation(true);

      bool isCorrect = states.state.correctAnsIndex == index;
      String equation = "${states.state.firstNumber} ${states.state.currentOperator} ${states.state.secondNumber}";
      int userAnswer = states.state.results[index];
      int correctAnswer = states.state.results[states.state.correctAnsIndex];
      states.state.recordQuestionResult(equation, isCorrect, userAnswer, correctAnswer);

      if (isCorrect) {
        states.state.setTotalTrue(states.state.totalTrue + 1);
      } else {
        states.state.setTotalFalse(states.state.totalFalse + 1);
      }

      await Future.delayed(const Duration(milliseconds: 600));
      states.state.setLastClickedIndex(null);
      _generateNewQuestion();
      states.state.setChangingEquation(false);
    } else if (!states.state.isGameRunning) {
      // User clicked grid before starting game - animate start button to guide them
      _animateStartButtonToGuideUser();
    }
  }

  void _animateStartButtonToGuideUser() async {
    // Trigger animation for 2 seconds to guide user
    states.state.setShouldAnimateStartButton(true);
    await Future.delayed(const Duration(seconds: 2));
    states.state.setShouldAnimateStartButton(false);
  }

  // Enumerates every valid (num1, num2) pair for this operator within range,
  // then picks randomly among the ones not used yet this game. Falls back to
  // the full pool (allowing a repeat) only once every combo has been used.
  // Returns null if the operator has no valid combination at all in range.
  (int, int)? _findPairForOperator(String op, int minNum, int maxNum) {
    List<(int, int)> pairs = [];
    for (int a = minNum; a <= maxNum; a++) {
      for (int b = minNum; b < a; b++) {
        int answer;
        switch (op) {
          case '+':
            answer = a + b;
            break;
          case '-':
            answer = a - b;
            break;
          case 'X':
            answer = a * b;
            break;
          case '/':
            if (a % b != 0) continue;
            answer = a ~/ b;
            if (answer <= 1 || answer > 20) continue;
            break;
          default:
            continue;
        }
        if (answer < 1 || answer > 500) continue;
        pairs.add((a, b));
      }
    }
    if (pairs.isEmpty) return null;

    var fresh = pairs.where((p) {
      String key = "${p.$1}$op${p.$2}";
      int answer = _calculateAnswer(p.$1, p.$2, op);
      return !states.state.usedQuestions.contains(key) && !states.state.usedAnswers.contains(answer);
    }).toList();

    var pool = fresh.isNotEmpty ? fresh : pairs;
    return pool[Utils.getRandomNumber(0, pool.length - 1)];
  }

  void _generateNewQuestion([int attempts = 0]) {
    // Every operator in the pool has been tried with no valid combination -
    // the range is too tight for any question. Reset and retry once.
    if (attempts > 4) {
      states.state.resetUsedQuestions();
      attempts = 0;
    }

    var op = states.state.getNextOperator();
    var pair = _findPairForOperator(op, states.state.minNumber, states.state.maxNumber);

    if (pair == null) {
      // No valid combination exists for this operator at this range - try another
      states.state.putBackOperator(op);
      return _generateNewQuestion(attempts + 1);
    }

    int num1 = pair.$1;
    int num2 = pair.$2;
    var answer = _calculateAnswer(num1, num2, op);
    String questionKey = "$num1$op$num2";

    states.state.setCurrentOperator(op);
    states.state.setFirstNumber(num1);
    states.state.setSecondNumber(num2);

    int totalOptions = states.state.gridRows * states.state.gridColumns;
    List<int> results = Utils.generateNumbersCloseTo(answer, count: totalOptions);

    int correctIndex = Utils.getRandomNumber(0, totalOptions - 1);
    results[correctIndex] = answer;
    states.state.setCorrectAnsIndex(correctIndex);
    states.state.setResults(results);
    states.state.recordUsedQuestion(questionKey, answer);
    states.state.startQuestionTimer();
  }

  int _calculateAnswer(int num1, int num2, String operator) {
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

  void _onStartStop() {
    if (states.state.isGameRunning) {
      _stopGame();
    } else {
      _startGame();
    }
  }

  void _startGame() {
    states.state.setGameRunning(true);
    states.state.setShouldAnimateStartButton(false); // Stop animation when game starts
    states.state.setCurrentTimer(states.state.maxTimer);
    states.state.clearQuestionHistory();
    states.state.resetUsedQuestions();

    // Initialize the operator pool for a new game
    states.state.initializeOperatorPool();

    _generateNewQuestion();

    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int timeLeft = states.state.maxTimer - timer.tick;
      states.state.setCurrentTimer(timeLeft);

      if (timeLeft <= 0) {
        _stopGame();
      }
    });
  }

  void _stopGame() {
    states.state.setGameRunning(false);
    gameTimer?.cancel();
    _showGameResults();
  }

  // Bottom Sheets
  void _showGameResults() {
    double accuracy = 0;
    int total = states.state.totalTrue + states.state.totalFalse;
    if (total > 0) {
      accuracy = (states.state.totalTrue / total) * 100;
    }

    showModalBottomSheet(
      context: OneContext().context!,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => PopScope(
        onPopInvokedWithResult: (didPop, result) {
          // Reset scores whenever dialog is dismissed in any way
          if (didPop) {
            states.state.setTotalTrue(0);
            states.state.setTotalFalse(0);
            states.state.setCurrentTimer(0);
          }
        },
        child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Icon(Icons.sports_score_rounded, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text("Game Over!", style: GoogleFonts.varelaRound(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildResultStat("Correct", states.state.totalTrue.toString(), Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildResultStat("Wrong", states.state.totalFalse.toString(), Colors.red)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildResultStat("Time", "${states.state.maxTimer - states.state.currentTimer}s", Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildResultStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Colors.orange)),
              ],
            ),
            if (states.state.questionHistory.isNotEmpty) ...[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Breakdown", style: GoogleFonts.varelaRound(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Column(
                children: List.generate(states.state.questionHistory.length, (i) {
                  final record = states.state.questionHistory[i];
                  final color = record.correct ? Colors.green : Colors.red;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          record.correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: color,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${record.equation} = ${record.correctAnswer}",
                                style: GoogleFonts.varelaRound(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              if (!record.correct)
                                Text(
                                  "You answered: ${record.userAnswer}",
                                  style: GoogleFonts.varelaRound(fontSize: 12, color: color),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          "${(record.timeMs / 1000).toStringAsFixed(1)}s",
                          style: GoogleFonts.varelaRound(fontSize: 13, color: color, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text("Dismiss", style: GoogleFonts.varelaRound(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildResultStat(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.varelaRound(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: GoogleFonts.varelaRound(fontSize: 12, color: color.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: OneContext().context!,
      isScrollControlled: true,
      builder: (context) => _buildSettingsSheet(context),
    );
  }

  Widget _buildSettingsSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return StateBuilder(
      observe: () => states,
      builder: (context, _) => Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
        padding: EdgeInsets.only(
          left: (screenWidth * 0.05).clamp(16.0, 24.0),
          right: (screenWidth * 0.05).clamp(16.0, 24.0),
          top: (screenWidth * 0.05).clamp(16.0, 24.0),
          bottom: MediaQuery.of(context).viewInsets.bottom + (screenWidth * 0.05).clamp(16.0, 24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Game Settings", style: GoogleFonts.varelaRound(
              fontSize: (screenWidth * 0.06).clamp(20.0, 24.0), 
              fontWeight: FontWeight.bold
            )),
            SizedBox(height: (screenHeight * 0.02).clamp(16.0, 24.0)),
            
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            _buildSlider("Min Value", states.state.minNumber.toDouble(), Constants.minNumber.toDouble(), (states.state.maxNumber - 1).toDouble(), (v) => states.state.setMinNumber(v.toInt())),
            _buildSlider("Max Value", states.state.maxNumber.toDouble(), (states.state.minNumber + 1).toDouble(), Constants.maxNumber.toDouble(), (v) => states.state.setMaxNumber(v.toInt())),
            _buildSlider("Timer", states.state.maxTimer.toDouble(), Constants.minTimer.toDouble(), Constants.maxTimer.toDouble(), (v) => states.state.setMaxTimer(v.toInt())),
            _buildSlider("Rows", states.state.gridRows.toDouble(), 2, 4, (v) => states.state.setGridRows(v.toInt()), divisions: 2),
                    _buildSlider("Columns", states.state.gridColumns.toDouble(), 2, 4, (v) => states.state.setGridColumns(v.toInt()), divisions: 2),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: (screenHeight * 0.02).clamp(16.0, 24.0)),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  Utils.saveSettings();
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text("Save Settings", style: GoogleFonts.varelaRound(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged, {int? divisions}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ${value.toInt()}", style: GoogleFonts.varelaRound(fontSize: 16, fontWeight: FontWeight.w600)),
          Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
        ],
      ),
    );
  }

  void _showThemeSettings() {
    showModalBottomSheet(
      context: OneContext().context!,
      isScrollControlled: true,
      builder: (context) => _buildThemeSheet(context),
    );
  }

  Widget _buildThemeSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return StateBuilder(
      observe: () => states,
      builder: (context, _) => Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
        padding: EdgeInsets.only(
          left: (screenWidth * 0.05).clamp(16.0, 24.0),
          right: (screenWidth * 0.05).clamp(16.0, 24.0),
          top: (screenWidth * 0.05).clamp(16.0, 24.0),
          bottom: MediaQuery.of(context).viewInsets.bottom + (screenWidth * 0.05).clamp(16.0, 24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Theme Settings", style: GoogleFonts.varelaRound(
              fontSize: (screenWidth * 0.06).clamp(20.0, 24.0), 
              fontWeight: FontWeight.bold
            )),
            SizedBox(height: (screenHeight * 0.01).clamp(8.0, 12.0)),
            Text("Currently using ${_getThemeModeText()} theme", style: GoogleFonts.varelaRound(
              fontSize: (screenWidth * 0.035).clamp(12.0, 14.0), 
              color: Theme.of(context).colorScheme.onSurfaceVariant
            )),
            SizedBox(height: (screenHeight * 0.02).clamp(16.0, 24.0)),
            
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Theme Mode
                    Text("Theme Mode", style: GoogleFonts.varelaRound(
                      fontSize: (screenWidth * 0.045).clamp(16.0, 18.0), 
                      fontWeight: FontWeight.w600
                    )),
                    SizedBox(height: (screenHeight * 0.01).clamp(8.0, 12.0)),
                    Row(
                      children: [
                        _buildThemeModeButton(context, Icons.settings_rounded, 'System', ThemeMode.system),
                        SizedBox(width: (screenWidth * 0.02).clamp(6.0, 8.0)),
                        _buildThemeModeButton(context, Icons.wb_sunny_rounded, 'Light', ThemeMode.light),
                        SizedBox(width: (screenWidth * 0.02).clamp(6.0, 8.0)),
                        _buildThemeModeButton(context, Icons.nightlight_round, 'Dark', ThemeMode.dark),
                      ],
                    ),

                    SizedBox(height: (screenHeight * 0.025).clamp(16.0, 24.0)),

                    // Theme Colors
                    Text("Theme Color", style: GoogleFonts.varelaRound(
                      fontSize: (screenWidth * 0.045).clamp(16.0, 18.0), 
                      fontWeight: FontWeight.w600
                    )),
                    SizedBox(height: (screenHeight * 0.01).clamp(8.0, 12.0)),
                    Wrap(
                      spacing: (screenWidth * 0.03).clamp(8.0, 12.0),
                      runSpacing: (screenWidth * 0.03).clamp(8.0, 12.0),
                      children: _buildColorOptions(context),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: (screenHeight * 0.025).clamp(16.0, 32.0)),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  Utils.saveSettings();
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text("Apply Theme", style: GoogleFonts.varelaRound(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeText() {
    switch (states.state.themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  Widget _buildThemeModeButton(BuildContext context, IconData icon, String label, ThemeMode mode) {
    final isSelected = states.state.themeMode == mode;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => states.state.setThemeMode(mode),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface, size: 20),
                const SizedBox(height: 4),
                Text(label,
                    style: GoogleFonts.varelaRound(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildColorOptions(BuildContext context) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.pink
    ];

    return colors.map((color) {
      final isSelected = states.state.seedColor == color;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => states.state.setSeedColor(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Theme.of(context).colorScheme.outline, width: 3) : null,
            ),
            child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 20) : null,
          ),
        ),
      );
    }).toList();
  }

  void _showAbout() {
    showModalBottomSheet(
      context: OneContext().context!,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        
        return Container(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
          padding: EdgeInsets.all((screenWidth * 0.05).clamp(16.0, 24.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("About MathFinity", style: GoogleFonts.varelaRound(
                fontSize: (screenWidth * 0.06).clamp(20.0, 24.0), 
                fontWeight: FontWeight.bold
              )),
              SizedBox(height: (screenHeight * 0.02).clamp(16.0, 20.0)),
              
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Created by Fayaz Bin Salam", style: GoogleFonts.varelaRound(
                        fontSize: (screenWidth * 0.04).clamp(14.0, 16.0)
                      )),
                      SizedBox(height: (screenHeight * 0.02).clamp(12.0, 16.0)),
                      Text("GitHub Repository:", style: GoogleFonts.varelaRound(
                        fontSize: (screenWidth * 0.035).clamp(12.0, 14.0), 
                        fontWeight: FontWeight.w600
                      )),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => launchUrl(Uri.parse("https://github.com/p32929/mathfinity")),
                        child: Text("https://github.com/p32929/mathfinity", style: GoogleFonts.varelaRound(
                          color: Theme.of(context).colorScheme.primary, 
                          decoration: TextDecoration.underline, 
                          fontSize: (screenWidth * 0.032).clamp(11.0, 13.0)
                        )),
                      ),
                      SizedBox(height: (screenHeight * 0.02).clamp(12.0, 16.0)),
                      Text("Developer Portfolio:", style: GoogleFonts.varelaRound(
                        fontSize: (screenWidth * 0.035).clamp(12.0, 14.0), 
                        fontWeight: FontWeight.w600
                      )),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => launchUrl(Uri.parse("https://p32929.github.io")),
                        child: Text("https://p32929.github.io", style: GoogleFonts.varelaRound(
                          color: Theme.of(context).colorScheme.primary, 
                          decoration: TextDecoration.underline, 
                          fontSize: (screenWidth * 0.032).clamp(11.0, 13.0)
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: (screenHeight * 0.025).clamp(16.0, 24.0)),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text("Close", style: GoogleFonts.varelaRound(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Grid item styling methods
  Color _getGridItemColor(BuildContext context, int index) {
    // Show feedback during answer selection
    if (states.state.isChangingEquation && states.state.lastClickedIndex == index) {
      if (index == states.state.correctAnsIndex) {
        return Colors.green.shade400; // Clean bright green
      } else {
        return Colors.red.shade400; // Clean bright red
      }
    }

    // Show correct answer during feedback phase
    if (states.state.isChangingEquation && index == states.state.correctAnsIndex && states.state.lastClickedIndex != index) {
      return Colors.green.shade300.withValues(alpha: 0.6); // Subtle correct answer indication
    }

    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }

  Color _getGridItemBorderColor(BuildContext context, int index) {
    // Show feedback during answer selection
    if (states.state.isChangingEquation && states.state.lastClickedIndex == index) {
      if (index == states.state.correctAnsIndex) {
        return Colors.green.shade600; // Clean green border
      } else {
        return Colors.red.shade600; // Clean red border
      }
    }

    // Show correct answer during feedback phase
    if (states.state.isChangingEquation && index == states.state.correctAnsIndex && states.state.lastClickedIndex != index) {
      return Colors.green.shade500; // Clean green for correct answer
    }

    return Theme.of(context).colorScheme.outline.withValues(alpha: 0.2);
  }

  List<BoxShadow> _getGridItemGlow(BuildContext context, int index) {
    // Clean elegant glow during feedback
    if (states.state.isChangingEquation && states.state.lastClickedIndex == index) {
      if (index == states.state.correctAnsIndex) {
        return [
          // Clean green glow - elegant and bright
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ];
      } else {
        return [
          // Clean red glow - elegant and bright
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ];
      }
    }

    // Subtle glow for correct answer indicator
    if (states.state.isChangingEquation && index == states.state.correctAnsIndex && states.state.lastClickedIndex != index) {
      return [
        BoxShadow(
          color: Colors.green.withValues(alpha: 0.4),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ];
    }

    return []; // No glow for normal state
  }
}
