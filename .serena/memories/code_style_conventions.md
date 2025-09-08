# Code Style and Conventions

## Dart/Flutter Conventions
- Uses Flutter's standard linting rules (`flutter_lints: ^5.0.0`)
- Follows Dart naming conventions (camelCase for variables, PascalCase for classes)
- Uses `const` constructors where possible
- Immutable widgets with `@immutable` annotation

## Typography
- Primary font: Google Fonts Varela Round
- Consistent use of GoogleFonts.varelaRound() throughout the app
- Font sizes: 16px for labels, 24px for buttons, 36px for main equation

## State Management
- Uses `states_rebuilder` package
- StateBuilder widgets for reactive UI updates
- Global state accessed via `states.state`

## Material Design
- Uses Material 3 design system
- Dynamic color theming with `dynamic_color` package
- Theme-aware color usage via `Theme.of(context).colorScheme`
- Custom colors extension for additional colors (danger color)

## Code Organization
- Clear separation of concerns (main.dart, routes, others)
- Utility functions in separate files
- Constants in dedicated constants file