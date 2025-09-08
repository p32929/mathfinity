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
                color: states.state.isGameRunning
                    ? Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3)
                    : null,
              ),
            ),
            IconButton(
              onPressed: states.state.isGameRunning ? null : _showSettings,
              icon: Icon(
                Icons.settings_rounded,
                color: states.state.isGameRunning
                    ? Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3)
                    : null,
              ),
            ),
            IconButton(
              onPressed: states.state.isGameRunning ? null : _showAbout,
              icon: Icon(
                Icons.info_rounded,
                color: states.state.isGameRunning
                    ? Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3)
                    : null,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Stats Row
                _buildStatsRow(context),
                const SizedBox(height: 20),

                // Equation
                _buildEquation(context),
                const SizedBox(height: 20),

                // Numbers Grid (This will take most space)
                Expanded(
                  child: _buildNumbersGrid(context),
                ),
                const SizedBox(height: 20),

                // Start Button
                _buildStartButton(context),
              ],
            ),
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

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: states.state.gridColumns,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: states.state.gridRows * states.state.gridColumns,
          itemBuilder: (context, index) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _onNumberTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      states.state.results[index].toString(),
                      style: GoogleFonts.varelaRound(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: _onStartStop,
        style: FilledButton.styleFrom(
          backgroundColor: states.state.isGameRunning
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          states.state.isGameRunning ? "STOP GAME" : "START GAME",
          style: GoogleFonts.varelaRound(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Game Logic
  void _onNumberTap(int index) async {
    if (states.state.isGameRunning && !states.state.isChangingEquation) {
      states.state.setChangingEquation(true);

      if (states.state.correctAnsIndex == index) {
        states.state.setTotalTrue(states.state.totalTrue + 1);
      } else {
        states.state.setTotalFalse(states.state.totalFalse + 1);
      }

      await Future.delayed(const Duration(milliseconds: 300));
      _generateNewQuestion();
      states.state.setChangingEquation(false);
    }
  }

  void _generateNewQuestion() {
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
    var op = operators[0];
    states.state.setCurrentOperator(op);

    if (op == "/") {
      int mod = num1 % num2;
      num1 -= mod;
    }

    var answer = _calculateAnswer(num1, num2, op);

    if (num1 == num2 || answer < 3) {
      return _generateNewQuestion();
    }

    states.state.setFirstNumber(num1);
    states.state.setSecondNumber(num2);

    int totalOptions = states.state.gridRows * states.state.gridColumns;
    List<int> results =
        Utils.generateNumbersCloseTo(answer, count: totalOptions);

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
    states.state.setCurrentTimer(states.state.maxTimer);

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
      isDismissible: false,
      enableDrag: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_score_rounded,
                size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text("Game Over!",
                style: GoogleFonts.varelaRound(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    child: _buildResultStat("Correct",
                        states.state.totalTrue.toString(), Colors.green)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildResultStat("Wrong",
                        states.state.totalFalse.toString(), Colors.red)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildResultStat(
                        "Time",
                        "${states.state.maxTimer - states.state.currentTimer}s",
                        Colors.blue)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildResultStat("Accuracy",
                        "${accuracy.toStringAsFixed(1)}%", Colors.orange)),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  states.state.setTotalTrue(0);
                  states.state.setTotalFalse(0);
                  states.state.setCurrentTimer(0);
                  Navigator.pop(context);
                },
                child: Text("Play Again",
                    style:
                        GoogleFonts.varelaRound(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
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
          Text(value,
              style: GoogleFonts.varelaRound(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(title,
              style: GoogleFonts.varelaRound(
                  fontSize: 12, color: color.withValues(alpha: 0.8))),
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
    return StateBuilder(
      observe: () => states,
      builder: (context, _) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Game Settings",
                style: GoogleFonts.varelaRound(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildSlider(
                "Min Number",
                states.state.minNumber.toDouble(),
                Constants.minNumber.toDouble(),
                (states.state.maxNumber - 1).toDouble(),
                (v) => states.state.setMinNumber(v.toInt())),
            _buildSlider(
                "Max Number",
                states.state.maxNumber.toDouble(),
                (states.state.minNumber + 1).toDouble(),
                Constants.maxNumber.toDouble(),
                (v) => states.state.setMaxNumber(v.toInt())),
            _buildSlider(
                "Timer",
                states.state.maxTimer.toDouble(),
                Constants.minTimer.toDouble(),
                Constants.maxTimer.toDouble(),
                (v) => states.state.setMaxTimer(v.toInt())),
            _buildSlider("Rows", states.state.gridRows.toDouble(), 2, 4,
                (v) => states.state.setGridRows(v.toInt()),
                divisions: 2),
            _buildSlider("Columns", states.state.gridColumns.toDouble(), 2, 4,
                (v) => states.state.setGridColumns(v.toInt()),
                divisions: 2),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Utils.saveSettings();
                  Navigator.pop(context);
                },
                child: Text("Save Settings",
                    style:
                        GoogleFonts.varelaRound(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      Function(double) onChanged,
      {int? divisions}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ${value.toInt()}",
              style: GoogleFonts.varelaRound(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged),
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
    return StateBuilder(
      observe: () => states,
      builder: (context, _) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Theme Settings",
                style: GoogleFonts.varelaRound(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Currently using ${_getThemeModeText()} theme",
                style: GoogleFonts.varelaRound(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),

            // Theme Mode
            Text("Theme Mode",
                style: GoogleFonts.varelaRound(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildThemeModeButton(context, Icons.settings_rounded, 'System',
                    ThemeMode.system),
                const SizedBox(width: 8),
                _buildThemeModeButton(
                    context, Icons.wb_sunny_rounded, 'Light', ThemeMode.light),
                const SizedBox(width: 8),
                _buildThemeModeButton(
                    context, Icons.nightlight_round, 'Dark', ThemeMode.dark),
              ],
            ),

            const SizedBox(height: 24),

            // Theme Colors
            Text("Theme Color",
                style: GoogleFonts.varelaRound(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _buildColorOptions(context),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Utils.saveSettings();
                  Navigator.pop(context);
                },
                child: Text("Apply Theme",
                    style:
                        GoogleFonts.varelaRound(fontWeight: FontWeight.bold)),
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

  Widget _buildThemeModeButton(
      BuildContext context, IconData icon, String label, ThemeMode mode) {
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
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    size: 20),
                const SizedBox(height: 4),
                Text(label,
                    style: GoogleFonts.varelaRound(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
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
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.outline, width: 3)
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : null,
          ),
        ),
      );
    }).toList();
  }

  void _showAbout() {
    showModalBottomSheet(
      context: OneContext().context!,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About MathFinity",
                style: GoogleFonts.varelaRound(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("Created by Fayaz Bin Salam",
                style: GoogleFonts.varelaRound(fontSize: 16)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () =>
                  launchUrl(Uri.parse("https://github.com/p32929/mathfinity")),
              child: Text("GitHub Repository",
                  style: GoogleFonts.varelaRound(
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => launchUrl(Uri.parse("https://p32929.github.io/")),
              child: Text("Developer Portfolio",
                  style: GoogleFonts.varelaRound(
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close",
                    style:
                        GoogleFonts.varelaRound(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
