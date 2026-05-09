# Provider Local Backend Implementation

## What Changed

The app now uses a minimal local backend built around two packages:

- `provider`: exposes app state to the widget tree and rebuilds screens when state changes.
- `shared_preferences`: saves the app state locally so trips, expenses, profile data, and preferences survive app restarts.

The previous service-heavy idea was replaced with one central store:

```text
lib/core/app_store.dart
```

The implementation intentionally keeps the data model small. It only supports the frontend flows that currently exist:

- create trips
- show trips on Home
- add expenses
- calculate active trip budget totals
- edit profile
- persist dark mode and push notification preferences

No API layer, repository layer, Firebase, database package, itinerary backend, reservations, attachments, reminders, members, or notification delivery system was added.

## Dependencies Added

`pubspec.yaml` now includes:

```yaml
provider: ^6.1.5
shared_preferences: ^2.5.3
```

Provider handles state access and UI rebuilds. Shared Preferences handles local persistence.

Provider alone would not save data after the app closes. It only keeps state alive while the app process is running.

## New And Updated Files

### New Files

- `lib/core/app_store.dart`
  The single app-wide store.
- `lib/data/models/trip_model.dart`
  Minimal `Trip` model.
- `lib/data/models/user_profile_model.dart`
  Minimal `UserProfile` and `UserPreferences` models.
- `test/app_store_test.dart`
  Unit tests for the store.

### Updated Files

- `lib/main.dart`
  Wraps the app with `ChangeNotifierProvider`.
- `lib/data/models/transaction_model.dart`
  Adds `tripId`, `fromJson`, and `toJson`.
- `lib/data/models/budget_model.dart`
  Guards against division by zero in `percentConsumed`.
- Current screens now read/write state through Provider:
  `HomeScreen`, `AddTripScreen`, `BudgetScreen`, `AddExpenseScreen`, `ProfileScreen`, `EditProfileScreen`, `SettingsScreen`, and `NotificationsScreen`.

## The Central Store

`AppStore` is the local backend. It extends Flutter's `ChangeNotifier`, which means it can tell Provider when something changed.

Current state fields:

```dart
class AppStore extends ChangeNotifier {
  static const _storageKey = 'voyage_minimal_state_v1';

  UserProfile profile = const UserProfile(
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=32',
  );
  UserPreferences preferences = const UserPreferences(
    darkModeEnabled: false,
    pushNotificationsEnabled: true,
  );
  List<Trip> trips = [];
  List<Transaction> transactions = [];
  String? activeTripId;
  bool isLoaded = false;
}
```

This replaces separate service classes. For the current app size, one store is easier to read and maintain.

## Derived State

The store does not persist budget summaries separately. It calculates them from trips and transactions.

```dart
Trip? get activeTrip {
  if (trips.isEmpty) return null;
  return trips.firstWhere(
    (trip) => trip.id == activeTripId,
    orElse: () => trips.last,
  );
}
```

`activeTrip` returns the selected trip. If no selected trip exists, it falls back to the latest trip.

```dart
List<Transaction> get activeTripTransactions {
  final trip = activeTrip;
  if (trip == null) return [];
  return transactions
      .where((transaction) => transaction.tripId == trip.id)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
}
```

`activeTripTransactions` filters all expenses down to the active trip and sorts newest first.

```dart
Budget get activeBudget {
  final trip = activeTrip;
  final spent = activeTripTransactions.fold<double>(
    0,
    (total, transaction) => total + transaction.amount,
  );
  return Budget(totalBudget: trip?.budget ?? 0, spent: spent);
}
```

`activeBudget` calculates spent and remaining values from transactions. This prevents duplicated budget state from getting out of sync.

## Persistence

The whole app state is saved as one JSON object in Shared Preferences.

```dart
Future<void> load() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_storageKey);
  if (raw != null) {
    _readJson(jsonDecode(raw) as Map<String, dynamic>);
  }
  isLoaded = true;
  notifyListeners();
}
```

`load()` reads saved JSON on startup. If no JSON exists yet, the default profile/preferences and empty lists remain in memory.

```dart
Future<void> _save() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_storageKey, jsonEncode(_toJson()));
  notifyListeners();
}
```

`_save()` writes the latest state and calls `notifyListeners()`.

That call is what makes Provider rebuild screens that are watching the store.

The persisted data shape is compact:

```dart
Map<String, dynamic> _toJson() {
  return {
    'profile': profile.toJson(),
    'preferences': preferences.toJson(),
    'trips': trips.map((trip) => trip.toJson()).toList(),
    'transactions': transactions
        .map((transaction) => transaction.toJson())
        .toList(),
    'activeTripId': activeTripId,
  };
}
```

## How Provider Is Set Up

Provider is installed at the root of the app in `main.dart`:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppStore()..load(),
      child: const VoyageApp(),
    ),
  );
}
```

This does three important things:

1. Creates one `AppStore`.
2. Calls `load()` immediately so saved local data is restored.
3. Makes the store available to every screen under `VoyageApp`.

Because the provider wraps the whole app, screens do not need to manually pass state through constructors.

## How Screens Read State

Screens that display store data use:

```dart
context.watch<AppStore>()
```

`watch` means:

- get the current store
- subscribe this widget to changes
- rebuild this widget when `notifyListeners()` is called

Example from `HomeScreen`:

```dart
final store = context.watch<AppStore>();

return Scaffold(
  body: store.trips.isEmpty
      ? const _EmptyTripsView()
      : ListView(
          children: [
            ...store.trips.map((trip) {
              return Text(trip.title);
            }),
          ],
        ),
);
```

This is why Home automatically changes from the empty state to the trip list after a trip is created.

Example from `BudgetScreen`:

```dart
final store = context.watch<AppStore>();
final transactions = _filteredTransactions(store.activeTripTransactions);
```

Budget reads derived state from the store:

- `store.activeTrip`
- `store.activeBudget`
- `store.activeTripTransactions`

When an expense is added, `_save()` calls `notifyListeners()`, and `BudgetScreen` rebuilds with the new transaction and recalculated budget.

Example from `ProfileScreen`:

```dart
final profile = context.watch<AppStore>().profile;
```

The profile screen now displays stored profile data instead of hardcoded text.

Example from `SettingsScreen`:

```dart
final preferences = context.watch<AppStore>().preferences;
```

The settings screen reads persisted preferences.

## How Screens Write State

Screens that perform actions use:

```dart
context.read<AppStore>()
```

`read` means:

- get the current store
- do not subscribe this widget to changes from that call
- useful inside button handlers, form submits, and callbacks

Example from `AddTripScreen`:

```dart
await context.read<AppStore>().createTrip(
  destination: destination,
  title: title,
  startDate: _startDate,
  endDate: _endDate,
  budget: _parseMoney(_budgetController.text),
);
```

This calls the store method:

```dart
Future<void> createTrip({
  required String destination,
  required String title,
  required DateTime startDate,
  required DateTime endDate,
  required double budget,
}) async {
  final trip = Trip(
    id: _createId('trip'),
    destination: destination,
    title: title,
    startDate: startDate,
    endDate: endDate,
    budget: budget,
  );
  trips = [...trips, trip];
  activeTripId = trip.id;
  await _save();
}
```

The method creates a trip, makes it active, saves everything locally, then notifies listeners.

Example from `AddExpenseScreen`:

```dart
await store.addExpense(
  title: title,
  amount: amount,
  expenseType: _expenseType,
  category: _category,
  date: _date,
);
```

The store attaches the expense to the active trip:

```dart
final transaction = Transaction(
  id: _createId('transaction'),
  tripId: trip.id,
  title: title,
  amount: amount,
  date: date,
  expenseType: expenseType,
  category: category,
  iconAsset: expenseType.name,
);
transactions = [...transactions, transaction];
await _save();
```

The important field is `tripId`. It is what lets Budget show only the expenses for the current active trip.

Example from `EditProfileScreen`:

```dart
await context.read<AppStore>().updateProfile(
  name: name,
  email: email,
  avatarUrl: _avatarController.text.trim(),
);
```

Example from `NotificationsScreen`:

```dart
(v) => context.read<AppStore>().updatePreferences(
  pushNotificationsEnabled: v,
)
```

Only the store decides how to save data. Screens only call intent-level methods.

## Why Both `watch` And `read` Are Used

Use `watch` when the widget needs to rebuild:

```dart
final store = context.watch<AppStore>();
```

Use `read` when handling an action:

```dart
await context.read<AppStore>().createTrip(...);
```

Using `watch` inside event handlers is unnecessary because the handler does not need to rebuild. Using `read` in a widget that displays changing data would not rebuild when the data changes.

That split keeps rebuilds predictable.

## Model Changes

### Trip

`Trip` is intentionally small:

```dart
class Trip {
  final String id;
  final String destination;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
}
```

It stores only what the current Add Trip and Home/Budget flows need.

### Transaction

`Transaction` now has `tripId`:

```dart
class Transaction {
  final String id;
  final String tripId;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseType expenseType;
  final TransactionCategory category;
  final String iconAsset;
}
```

This is the smallest relationship needed for trip-specific expenses.

### UserProfile And UserPreferences

`UserProfile` stores:

- name
- email
- avatar URL

`UserPreferences` stores:

- dark mode enabled
- push notifications enabled

Dark mode is persisted, but the app does not yet use it to switch `ThemeMode`. That was intentionally left out to keep this implementation minimal.

## Screen Behavior After The Change

### Home

Home starts with the existing empty state. After a trip is created, it renders a trip list from `store.trips`.

### Add Trip

The form now saves real local state. It creates a trip and returns to the previous screen.

### Budget

Budget shows:

- a message if no trip exists
- the active trip budget if a trip exists
- the active trip's expenses
- category filtering for Dining and Transit

### Add Expense

The form now saves an expense to the active trip. If no trip exists, it shows a message asking the user to create one first.

### Profile

Profile reads from `store.profile`.

### Edit Profile

Edit Profile updates and persists `store.profile`.

### Settings

The dark mode switch updates and persists `store.preferences.darkModeEnabled`.

### Notifications

Push notifications update and persist `store.preferences.pushNotificationsEnabled`.

Email notifications and app updates remain local screen state because they are not part of the minimal persisted model.

## Tests

`test/app_store_test.dart` covers the local backend behavior:

- default profile/preferences load
- trip creation
- active trip selection
- expense creation
- budget recalculation
- profile updates
- preference updates
- persistence across store instances

`test/widget_test.dart` covers Provider-backed UI behavior:

- app renders with Provider
- Home shows a created trip
- Budget shows an added expense

The tests use:

```dart
SharedPreferences.setMockInitialValues({});
```

That gives each test a clean in-memory Shared Preferences store.

Widget tests provide the store like this:

```dart
ChangeNotifierProvider<AppStore>.value(
  value: store,
  child: const VoyageApp(),
)
```

This mirrors the real app setup while allowing tests to inject a prepared store.

## Why This Is Minimal

This implementation keeps one state object instead of adding multiple layers:

```text
UI -> Provider -> AppStore -> shared_preferences
```

There are no separate services, repositories, API clients, database adapters, or diagram-only models.

The store is allowed to be a little more responsible because the app is small. If the project grows, the next natural split would be:

- keep Provider
- move JSON persistence into a small storage helper
- split trip/budget/profile logic only when the store becomes hard to understand

For now, one `AppStore` is the clearest tradeoff.
