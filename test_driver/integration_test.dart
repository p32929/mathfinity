// Driver entrypoint for running integration_test on web (chromedriver) via
// `flutter drive`. Native platforms use `flutter test integration_test/...`
// directly and do not need this file.
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
