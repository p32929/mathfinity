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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(
        begin: 1.0,
        end: states.state.shouldAnimateStartButton ? 1.1 : 1.0,
      ),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: states.state.shouldAnimateStartButton
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
                    : states.state.shouldAnimateStartButton
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.9)
                        : Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (states.state.shouldAnimateStartButton)
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      curve: Curves.bounceOut,
                      builder: (context, bounceValue, child) {
                        return Transform.scale(
                          scale: 0.8 + (bounceValue * 0.4),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  if (states.state.shouldAnimateStartButton) const SizedBox(width: 8),
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
      },
    );
  }

  // Game Logic
  void _onNumberTap(int index) async {
    if (states.state.isGameRunning && !states.state.isChangingEquation) {
      states.state.setLastClickedIndex(index);
      states.state.setChangingEquation(true);

      if (states.state.correctAnsIndex == index) {
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

  void _generateNewQuestion([int attempts = 0]) {
    // Prevent infinite recursion - use fallback after 10 attempts
    if (attempts > 10) {
      // Fallback: generate a valid question within the user's range
      int minNum = states.state.minNumber;
      int maxNum = states.state.maxNumber;
      
      // Find two numbers within range that work for division
      int num1 = minNum + ((maxNum - minNum) ~/ 2);
      int num2 = minNum;
      
      var op = states.state.getNextOperator();
      
      // Adjust numbers for division to ensure clean result > 1
      if (op == "/") {
        bool foundValidDivision = false;
        // Find a divisor within range that creates a clean division with result > 1
        for (int divisor = minNum; divisor <= maxNum && !foundValidDivision; divisor++) {
          if (divisor != 0) {
            for (int dividend = minNum; dividend <= maxNum && !foundValidDivision; dividend++) {
              if (dividend != divisor && dividend % divisor == 0) {
                int result = dividend ~/ divisor;
                if (result > 1 && result <= 10) {
                  num1 = dividend;
                  num2 = divisor;
                  foundValidDivision = true;
                }
              }
            }
          }
        }
        
        // If no valid division found, skip division for this attempt
        if (!foundValidDivision) {
          // Don't use division, let it fall through to use +, -, or * instead
          op = ['+', '-', 'X'][Utils.getRandomNumber(0, 2)];
        }
      }
      
      states.state.setCurrentOperator(op);
      states.state.setFirstNumber(num1);
      states.state.setSecondNumber(num2);
      
      int totalOptions = states.state.gridRows * states.state.gridColumns;
      var answer = _calculateAnswer(num1, num2, op);
      List<int> results = Utils.generateNumbersCloseTo(answer, count: totalOptions);
      int correctIndex = Utils.getRandomNumber(0, totalOptions - 1);
      results[correctIndex] = answer;
      states.state.setCorrectAnsIndex(correctIndex);
      states.state.setResults(results);
      return;
    }

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

    // Get an operator from the shuffled pool
    var op = states.state.getNextOperator();

    if (op == "/") {
      // For division, we need both numbers in range AND result > 1
      // Strategy: find two numbers in range where num1 = num2 * result (result > 1)
      bool foundValidDivision = false;
      
      // Try to find a valid division within the range
      // Look for combinations where both numbers are in range and result > 1
      for (int divisor = states.state.minNumber; divisor <= states.state.maxNumber && !foundValidDivision; divisor++) {
        if (divisor == 0) continue;
        
        for (int dividend = states.state.minNumber; dividend <= states.state.maxNumber && !foundValidDivision; dividend++) {
          if (dividend != divisor && dividend % divisor == 0) {
            int result = dividend ~/ divisor;
            if (result > 1 && result <= 20) { // Reasonable result range
              num1 = dividend;
              num2 = divisor;
              foundValidDivision = true;
            }
          }
        }
      }
      
      // If we couldn't find a valid division in range, fallback
      if (!foundValidDivision) {
        // Put the operator back and try again with a different operator
        states.state.putBackOperator(op);
        return _generateNewQuestion(attempts + 1);
      }
    }

    var answer = _calculateAnswer(num1, num2, op);

    // Validate that both numbers are within user's range and result is valid
    bool isValidQuestion = true;
    
    if (num1 == num2 || answer < 1 || answer > 500 || 
        num1 < states.state.minNumber || num1 > states.state.maxNumber ||
        num2 < states.state.minNumber || num2 > states.state.maxNumber) {
      isValidQuestion = false;
    }
    
    // For division, ensure result is > 1 and is a clean integer
    if (op == "/" && (answer <= 1 || num1 % num2 != 0)) {
      isValidQuestion = false;
    }
    
    if (!isValidQuestion) {
      // Put the operator back since we're not using this question
      states.state.putBackOperator(op);
      return _generateNewQuestion(attempts + 1);
    }

    // Only set the operator if we're keeping this question
    states.state.setCurrentOperator(op);

    states.state.setFirstNumber(num1);
    states.state.setSecondNumber(num2);

    int totalOptions = states.state.gridRows * states.state.gridColumns;
    List<int> results = Utils.generateNumbersCloseTo(answer, count: totalOptions);

    int correctIndex = Utils.getRandomNumber(0, totalOptions - 1);
    results[correctIndex] = answer;
    states.state.setCorrectAnsIndex(correctIndex);
    states.state.setResults(results);
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
