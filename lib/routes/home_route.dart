import 'package:flutter/material.dart';
import 'package:infmath/others/states.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}
