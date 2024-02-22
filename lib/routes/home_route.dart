import 'package:flutter/material.dart';
import 'package:infmath/others/states.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      observe: () => states,
      builder: (context, _) => Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                  ),
                ),
                Text(
                  "InfiMath",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Text("0"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Text("0"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Text("0"),
                  ],
                ),
              ],
            ),
            Text("20 X 13"),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("11")),
                ElevatedButton(onPressed: () {}, child: Text("11")),
              ],
            ),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("11")),
                ElevatedButton(onPressed: () {}, child: Text("11")),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                //
              },
              child: Text("STOP"),
            ),
          ],
        ),
      ),
    );
  }
}
