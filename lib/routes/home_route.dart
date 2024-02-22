import 'package:flutter/material.dart';
import 'package:infmath/others/states.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    const double numberButtonsPadding = 12;
    const double numberButtonsSize = 48;

    getInfoWidgets({String text = "0", IconData icon = Icons.menu}) {
      const dividerText = '-:-';
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(dividerText),
              Icon(icon),
              Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Text(dividerText),
            ],
          ),
        ),
      );
    }

    getNumberWidget() {
      return ElevatedButton(
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(numberButtonsSize),
          child: Text(
            "0",
            style: TextStyle(
              fontSize: numberButtonsSize,
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
            "InfiMath",
          ),
          actions: [
            IconButton(
              onPressed: () {
                //
              },
              icon: Icon(
                Icons.settings,
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
                getInfoWidgets(),
                getInfoWidgets(),
                getInfoWidgets(),
              ],
            ),
            Padding(padding: const EdgeInsets.all(16)),
            Padding(
              padding: const EdgeInsets.all(numberButtonsPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getNumberWidget(),
                  Padding(padding: const EdgeInsets.all(numberButtonsPadding)),
                  getNumberWidget(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(numberButtonsPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getNumberWidget(),
                  Padding(padding: const EdgeInsets.all(numberButtonsPadding)),
                  getNumberWidget(),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(16)),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "START",
                          style: TextStyle(
                            fontSize: 20,
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
