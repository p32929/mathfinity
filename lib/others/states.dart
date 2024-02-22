import 'package:states_rebuilder/states_rebuilder.dart';

class States {
  int minNumber = 1, maxNumber = 250;
}

final states = RM.inject(() => States());
