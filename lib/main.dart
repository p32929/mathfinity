import 'package:flutter/material.dart';
import 'package:mathfinity/others/states.dart';
import 'package:mathfinity/others/utils.dart';
import 'package:mathfinity/routes/home_route.dart';
import 'package:one_context/one_context.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:dynamic_color/dynamic_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Utils.getSavedSettings();
  runApp(const MyApp());
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
  });

  final Color? danger;

  @override
  CustomColors copyWith({Color? danger}) {
    return CustomColors(
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t),
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(danger: danger!.harmonizeWith(dynamic.primary));
  }
}

// Fictitious brand color.
const _brandBlue = Colors.blue;

CustomColors lightCustomColors = const CustomColors(danger: Color(0xFFE53935));
CustomColors darkCustomColors = const CustomColors(danger: Color(0xFFEF9A9A));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      observe: () => states,
      builder: (context, model) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              // On Android S+ devices, use the provided dynamic color scheme.
              // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
              lightColorScheme = lightDynamic.harmonized();
              // (Optional) Customize the scheme as desired. For example, one might
              // want to use a brand color to override the dynamic [ColorScheme.secondary].
              lightColorScheme =
                  lightColorScheme.copyWith(secondary: _brandBlue);
              // (Optional) If applicable, harmonize custom colors.
              lightCustomColors =
                  lightCustomColors.harmonized(lightColorScheme);

              // Repeat for the dark color scheme.
              darkColorScheme = darkDynamic.harmonized();
              darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
              darkCustomColors = darkCustomColors.harmonized(darkColorScheme);
            } else {
              // Otherwise, use fallback schemes.
              lightColorScheme = ColorScheme.fromSeed(
                seedColor: _brandBlue,
              );
              darkColorScheme = ColorScheme.fromSeed(
                seedColor: _brandBlue,
                brightness: Brightness.dark,
              );
            }

            return MaterialApp(
              title: 'MathFinity',
              theme: ThemeData(
                colorScheme: lightColorScheme,
                extensions: [lightCustomColors],
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme,
                extensions: [darkCustomColors],
              ),
              // initialRoute: "/login",
              // routes: {
              //   "/login": (context) => LoginPage(),
              //   "/dashboard": (context) => DashboardPage(),
              // },
              home: HomeRoute(),
              builder: OneContext().builder,
              navigatorKey: OneContext().key,
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
            );
          },
        );
      },
    );

    // return StateBuilder(
    //   observe: () => states,
    //   builder: (context, model) {
    //     return MaterialApp(
    //       title: 'Megamind-v2',
    //       builder: OneContext().builder,
    //       navigatorKey: OneContext().key,
    //       theme: ThemeData(
    //         brightness: Brightness.dark,
    //         useMaterial3: true,
    //       ),
    //       darkTheme: ThemeData(
    //         brightness: Brightness.dark,
    //       ),
    //       themeMode: ThemeMode.dark,
    //       home: HomeRoute(),
    //     );
    //   },
    // );
  }
}
