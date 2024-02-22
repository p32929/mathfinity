import 'package:flutter/material.dart';
import 'package:infmath/others/states.dart';
import 'package:one_context/one_context.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

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
                style: TextStyle(
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
                style: TextStyle(
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
              style: TextStyle(
                fontSize: numberButtonSizePadding,
              ),
            ),
          ),
        ),
      );
    }

    return StateBuilder(
      observe: () => states,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            "MathFinity",
            style: TextStyle(
              color: Theme.of(OneContext.instance.context!).colorScheme.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                //
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
                ),
                getInfoWidgets(
                  icon: Icons.hourglass_top,
                  color:
                      Theme.of(OneContext.instance.context!).colorScheme.error,
                ),
                getInfoWidgets(
                  icon: Icons.cancel,
                  color:
                      Theme.of(OneContext.instance.context!).colorScheme.error,
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.all(rowPaddings)),
            Text(
              "20 x 13",
              style: TextStyle(
                fontSize: 36,
                color:
                    Theme.of(OneContext.instance.context!).colorScheme.primary,
                fontWeight: FontWeight.w500,
                letterSpacing: 12,
              ),
            ),
            Padding(padding: const EdgeInsets.all(rowPaddings)),
            Padding(
              padding: const EdgeInsets.all(rowPaddings),
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
              padding: const EdgeInsets.all(rowPaddings),
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
                          (states) {
                            return states.contains(MaterialState.pressed)
                                ? Colors.red
                                : null;
                          },
                        ),
                      ),
                      onPressed: () {
                        //
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "START",
                          style: TextStyle(
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
