# App Feature Patterns

This doc explains app-level patterns that show up across multiple screens. It is meant as a quick map for developers who already understand the Provider/Firebase data flow and the text controller lifecycle.

For deeper state and backend details, see `docs/provider-local-backend.md`. For form controller details, see `docs/text-editing-controllers.md`.

## Navigation

The app starts in `main.dart`. After Firebase initializes, `VoyageApp` uses `AuthGate` as its `home`.

`AuthGate` chooses the first visible screen from provider state:

```dart
final authStatus = context.watch<AuthProvider>().status;
final store = context.watch<AppStore>();
```

The routing decision is:

- show `SplashScreen` while Firebase Auth is unresolved
- show `SplashScreen` while the authenticated user's `AppStore` data is still loading
- show `LoginScreen` when the user is unauthenticated
- show `HomeScreen` when the user is authenticated and loaded

Most app screens use named routes from `MaterialApp.routes`:

```dart
routes: {
  '/register': (_) => const RegisterScreen(),
  '/budget': (_) => const BudgetScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/settings': (_) => const SettingsScreen(),
  '/browse_destinations': (_) => const BrowseDestinationsScreen(),
  '/add_expense': (_) => const AddExpenseScreen(),
}
```

Use `Navigator.pushNamed(context, routeName)` when moving between normal app screens. The bottom navigation bar follows that pattern:

```dart
final routes = ['/', '/budget', '/profile', '/settings'];
Navigator.pushNamed(context, routes[index]);
```

`/add_trip` is handled by `onGenerateRoute` because it can receive a destination title:

```dart
onGenerateRoute: (settings) {
  if (settings.name == '/add_trip') {
    return MaterialPageRoute<void>(
      builder: (_) => AddTripScreen(
        initialDestination: settings.arguments as String?,
      ),
    );
  }
  return null;
}
```

Browse Destinations uses that route argument when a destination card is tapped:

```dart
Navigator.pushNamed(
  context,
  '/add_trip',
  arguments: destination.title,
);
```

Edit Profile currently uses a direct `MaterialPageRoute` from `ProfileScreen`:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const EditProfileScreen(),
  ),
);
```

Sign out resets navigation back to the root route:

```dart
navigator.pushNamedAndRemoveUntil('/', (route) => false);
```

That clears the previous authenticated screens from the stack after Firebase Auth signs out.

## Theme And Colors

Theme setup lives in:

```text
lib/core/theme/app_theme.dart
lib/core/theme/app_theme_colors.dart
lib/core/constants/app_colors.dart
```

`AppTheme` builds the Material `ThemeData` for light and dark mode:

```dart
theme: AppTheme.lightTheme,
darkTheme: AppTheme.darkTheme,
themeMode: darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
```

The `darkModeEnabled` value comes from:

```dart
context.watch<AppStore>().preferences.darkModeEnabled
```

Screens usually do not read raw theme colors directly. They use the `context.appColors` extension:

```dart
backgroundColor: context.appColors.scaffoldBg
```

`context.appColors` checks the current Flutter theme brightness:

```dart
final brightness = Theme.of(this).brightness;
return brightness == Brightness.dark
    ? AppThemeColors.dark
    : AppThemeColors.light;
```

This keeps screen code readable and makes custom colors theme-aware. When adding UI, prefer `context.appColors` over hardcoded colors unless the color is intentionally fixed, like white text on a colored button.

## Budget And Expense Flow

Budget display is derived from the active trip and its transactions. The source state is in `AppStore`; the UI reads derived getters.

`activeTrip` returns the selected trip, falling back to the latest loaded trip if the stored active id is missing:

```dart
Trip? get activeTrip
```

`activeTripTransactions` filters loaded transactions to the active trip and sorts newest first:

```dart
List<Transaction> get activeTripTransactions
```

`activeBudget` builds a `Budget` value from the active trip budget and the sum of active trip transactions:

```dart
Budget get activeBudget
```

`BudgetScreen` reads those values with Provider:

```dart
final store = context.watch<AppStore>();
final transactions = _filteredTransactions(store.activeTripTransactions);
```

If there is no active trip, Budget shows a create-trip message. If a trip exists, it renders:

- `BudgetCard` for the total, spent, remaining, and progress bar
- `CategoryChip` filters for all expenses, dining, and transit
- `TransactionItem` rows for each filtered transaction

Filtering is local UI state:

```dart
String _selectedCategory = 'All';
```

Dining includes only `ExpenseType.dining`. Transit includes both `ExpenseType.transit` and `ExpenseType.transport`.

`BudgetCard` clamps the progress percentage before rendering:

```dart
final percent = budget.percentConsumed.clamp(0, 100);
```

That prevents an over-budget trip from drawing a progress bar wider than the card.

## Reusable Widgets

Shared widgets live in `lib/presentation/widgets`. They keep screen files focused on flow and state instead of repeating styling details.

`PrimaryButton` is the standard full-width action button. Use it for submit-style actions like sign in, register, create trip, save expense, and save profile.

`LabeledTextField` is the standard text input wrapper. It adds the label, icon, fill color, border style, keyboard type, read-only mode, and optional tap handler.

`LabeledDropdown<T>` is the standard dropdown wrapper for enum-like choices. Add a `labelFor` function so each value can control its display text.

`MenuCardTile` is used for profile/settings-style rows with an icon, title, optional subtitle, and optional trailing chevron.

`MyAppBar` is the shared Voyage top app bar used by main app sections.

`MyBottomNavBar` is the shared bottom navigation bar. Each screen passes its selected index so the active tab is highlighted.

`BudgetCard`, `CategoryChip`, and `TransactionItem` are budget-specific shared widgets. Keep budget display changes in these widgets when the behavior is visual rather than screen-level.

## Model Helpers

Several models include small display and Firestore helper methods. These keep repetitive formatting out of widgets.

`Budget` provides derived numbers and formatted strings:

```dart
double get remaining => totalBudget - spent;
double get percentConsumed;
String get formattedTotal;
String get formattedSpent;
String get formattedRemaining;
```

`percentConsumed` returns `0` when total budget is `0` or negative, avoiding divide-by-zero behavior.

`Transaction` provides display helpers:

```dart
String get formattedAmount;
String get categoryLabel;
String get expenseTypeLabel;
String get dateLabel;
```

`formattedAmount` currently displays expenses as negative dollar amounts. `categoryLabel` is uppercase for the small transaction tag. `expenseTypeLabel` is human-readable text for the expense type.

`dateLabel` compares the transaction date against today and yesterday:

- today renders as `Today, h:mm AM/PM`
- yesterday renders as `Yesterday • ExpenseType`
- older dates render as `Mon Day • ExpenseType`

Trip and transaction models convert between Dart objects and Firestore-friendly maps:

```dart
Map<String, dynamic> toFirestoreMap()
```

Date fields are stored as Firestore `Timestamp` values:

```dart
Timestamp.fromDate(startDate)
```

`fromJson()` accepts Firestore timestamps and converts them back to `DateTime`. This lets UI code work with normal Dart dates.

## Rules Of Thumb

- Prefer named routes for normal app screens.
- Use `onGenerateRoute` when a named route needs arguments, like `/add_trip`.
- Use direct `MaterialPageRoute` for one-off local flows when no shared route is needed.
- Use `context.appColors` for theme-aware color choices.
- Keep persistent state changes in `AuthProvider` or `AppStore`, not inside widgets.
- Keep form text details in controllers, but move submitted values into Provider methods.
- Use shared widgets before adding new one-off field, button, tile, or nav styling.
- Keep display formatting close to the model or specialized display widget that owns it.
- Keep Firestore path knowledge inside repositories and Firestore conversion helpers.
