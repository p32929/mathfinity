# MathFinity - Project Overview

## Purpose
MathFinity is an infinite math game Flutter app that challenges users to solve math problems (addition, subtraction, multiplication, division) within a time limit by selecting the correct answer from a grid of options.

## Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: states_rebuilder package
- **UI**: Material Design 3 with Material You theming
- **Color System**: dynamic_color package for adaptive theming
- **Typography**: Google Fonts (Varela Round)
- **Navigation**: one_context package
- **Storage**: prefs package for settings persistence

## Key Features
- Dynamic color theming that adapts to device colors (Material You)
- Customizable grid size (2x2 to 4x4)
- Adjustable timer and number ranges
- Statistics tracking (correct/wrong answers, accuracy)
- Animated start button with glowing effect
- Settings dialog with sliders for customization

## App Structure
- `lib/main.dart` - Main app entry with Material You theming setup
- `lib/routes/home_route.dart` - Main game screen with UI components
- `lib/others/states.dart` - State management
- `lib/others/utils.dart` - Utility functions
- `lib/others/constants.dart` - App constants