# Task Completion Checklist

## Before Completing Any Task
1. Run `flutter analyze` to check for static analysis issues
2. Run `dart format .` to ensure consistent code formatting
3. Test the app with `flutter run` to ensure functionality works
4. Verify UI looks correct on different screen sizes

## For UI/Design Changes
1. Test both light and dark themes
2. Verify Material You dynamic colors work properly
3. Check accessibility (contrast, touch targets)
4. Test on different grid sizes (2x2 to 4x4)

## For Feature Changes
1. Test all user flows (start game, settings, credits)
2. Verify state management works correctly
3. Test edge cases (timer expiry, rapid button presses)
4. Ensure settings persistence works

## Before Committing
1. Ensure no debug prints or commented code
2. Update version in pubspec.yaml if needed
3. Verify no breaking changes to existing functionality