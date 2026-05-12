# Provider And Firebase Backend Implementation

## What Changed

The app now uses Provider for UI state and Firebase for authentication and persistence.

- `provider` exposes auth and app state to the widget tree.
- `firebase_core` initializes Firebase before the app starts.
- `firebase_auth` handles sign in, registration, sign out, and auth state changes.
- `cloud_firestore` stores user profiles, preferences, trips, and transactions.

Provider still keeps the screens simple: widgets read state with `watch`, perform actions with `read`, and rebuild when a provider calls `notifyListeners()`. Firebase is the durable backend behind those provider methods.

## Current Architecture

The main runtime flow is:

```text
UI screens
  -> Provider
  -> AuthProvider / AppStore
  -> repository interfaces
  -> Firebase Auth / Cloud Firestore
```

The important app-level classes are:

- `AuthProvider`: listens to Firebase Auth state and exposes `unknown`, `authenticated`, or `unauthenticated`.
- `AppStore`: holds the loaded user profile, preferences, trips, active trip, and active trip transactions.
- `FirebaseAuthRepository`: wraps Firebase Auth and creates the initial Firestore user document during registration.
- `FirebaseUserRepository`: reads and writes `users/{uid}`.
- `FirebaseTripRepository`: reads and writes trips and transactions under each user.

`AppStore` is still the main UI-facing app state object, but it no longer owns persistence directly. It delegates persistence to repositories.

## Dependencies

`pubspec.yaml` currently includes:

```yaml
provider: ^6.1.5
firebase_core: ^3.13.1
firebase_auth: ^5.5.2
cloud_firestore: ^5.6.7
```

Provider handles state access and UI rebuilds. Firebase Auth and Firestore handle data that must survive app restarts and be tied to the signed-in user.

## Startup Flow

The app initializes Firebase before building the widget tree:

```dart
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

Then `main.dart` installs providers with `MultiProvider`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(authRepository: FirebaseAuthRepository()),
    ),
    ChangeNotifierProxyProvider<AuthProvider, AppStore>(
      create: (_) => AppStore(
        tripRepository: FirebaseTripRepository(),
        userRepository: FirebaseUserRepository(),
      ),
      update: (_, auth, store) {
        if (auth.status == AuthStatus.authenticated && !store!.isLoaded) {
          store.load(
            auth.uid!,
            fallbackName: auth.displayName,
            fallbackEmail: auth.email,
          );
        } else if (auth.status == AuthStatus.unauthenticated &&
            store!.isLoaded) {
          store.reset();
        }
        return store!;
      },
    ),
  ],
  child: const VoyageApp(),
)
```

The proxy provider is the bridge between auth and app data:

- when Firebase Auth reports an authenticated user, `AppStore.load()` fetches that user's Firestore data
- when the user signs out, `AppStore.reset()` clears user-specific state from memory

## Auth Gate

`AuthGate` decides which screen to show:

```dart
final authStatus = context.watch<AuthProvider>().status;
final store = context.watch<AppStore>();

if (authStatus == AuthStatus.unknown ||
    (authStatus == AuthStatus.authenticated && !store.isLoaded)) {
  return const SplashScreen();
}

if (authStatus == AuthStatus.unauthenticated) {
  return const LoginScreen();
}

return const HomeScreen();
```

This prevents the app from showing Home until Firebase Auth has resolved and the authenticated user's Firestore data has loaded.

## Firestore Data Shape

The current Firestore structure is:

```text
users/{uid}
  name: string
  email: string
  avatarUrl: string
  darkModeEnabled: boolean
  activeTripId: string | null

users/{uid}/trips/{tripId}
  destination: string
  title: string
  startDate: Timestamp
  endDate: Timestamp
  budget: number

users/{uid}/trips/{tripId}/transactions/{transactionId}
  tripId: string
  title: string
  amount: number
  date: Timestamp
  expenseType: string
  category: string
  iconAsset: string
```

User-level settings live directly on the user document. Trips are a subcollection of that user. Transactions are a subcollection of the trip they belong to.

## AppStore State

`AppStore` extends `ChangeNotifier`, so it can tell Provider when screens should rebuild.

Current state fields:

```dart
String? _currentUid;
UserProfile profile = const UserProfile(name: '', email: '', avatarUrl: '');
UserPreferences preferences = const UserPreferences(darkModeEnabled: false);
List<Trip> trips = [];
List<Transaction> transactions = [];
String? activeTripId;
bool isLoaded = false;
String? errorMessage;
```

The store keeps only the data the current UI needs. It also exposes hardcoded popular destinations for the browse screen:

```dart
List<PopularDestination> get popularDestinations => _popularDestinations;
```

Those popular destination cards are not Firestore-backed right now.

## Loading User Data

`AppStore.load(uid, fallbackName, fallbackEmail)` is called after authentication.

The load sequence is:

1. Store the current `uid`.
2. Set `isLoaded` to `false` and notify listeners.
3. Fetch `users/{uid}` through `FirebaseUserRepository.fetchUserDocument()`.
4. If the user document exists, load `UserProfile`, `UserPreferences`, and `activeTripId`.
5. If the user document does not exist but Firebase Auth has fallback name or email values, create a basic profile document.
6. Fetch `users/{uid}/trips`.
7. If `activeTripId` exists, fetch that trip's transactions.
8. Set `isLoaded` to `true` and notify listeners.

The user sees `SplashScreen` while this is happening.

## Derived State

The store does not save budget summaries. It calculates them from the active trip and its loaded transactions.

```dart
Trip? get activeTrip {
  if (trips.isEmpty) return null;
  return trips.firstWhere(
    (trip) => trip.id == activeTripId,
    orElse: () => trips.last,
  );
}
```

`activeTrip` returns the selected trip. If the saved active trip id does not match a loaded trip, it falls back to the latest trip.

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

`activeTripTransactions` filters transactions to the active trip and sorts newest first.

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

`activeBudget` calculates the current budget totals from the active trip and transactions.

## Write Flows

### Registration

`FirebaseAuthRepository.register()` creates the Firebase Auth user, updates the Firebase Auth display name, then creates `users/{uid}`:

```dart
await _db.collection('users').doc(user.uid).set({
  'name': fullName,
  'email': email,
  'avatarUrl': '',
});
```

After Firebase Auth emits the authenticated user, `AuthProvider` notifies listeners and `AppStore.load()` loads the user's Firestore data.

### Sign In

`FirebaseAuthRepository.signIn()` signs in with Firebase Auth:

```dart
await _auth.signInWithEmailAndPassword(
  email: email,
  password: password,
);
```

The auth state listener updates `AuthProvider.status`, and the proxy provider loads user data into `AppStore`.

### Create Trip

`AppStore.createTrip()` builds a `Trip`, writes it to `users/{uid}/trips`, stores the generated Firestore document id, makes it active, clears the transaction list, and saves `activeTripId` on the user document.

```dart
final docId = await _tripRepository.createTrip(
  uid,
  tempTrip.toFirestoreMap(),
);

activeTripId = trip.id;
transactions = [];
await _userRepository.saveActiveTripId(uid, trip.id);
```

The UI is updated with the new in-memory trip immediately after the write succeeds.

### Add Expense

`AppStore.addExpense()` requires a current user and an active trip. It writes the transaction under:

```text
users/{uid}/trips/{tripId}/transactions/{transactionId}
```

Then it appends the created transaction to `transactions` and notifies listeners.

### Update Profile

`AppStore.updateProfile()` writes the new profile fields to `users/{uid}` with Firestore merge semantics:

```dart
await _userRepository.saveProfile(uid, {
  'name': name,
  'email': email,
  'avatarUrl': avatarUrl,
});
```

After the write succeeds, `profile` is updated in memory.

### Update Preferences

`AppStore.updatePreferences()` writes preference fields to `users/{uid}`:

```dart
await _userRepository.savePreferences(uid, updated.toJson());
```

The current model stores `darkModeEnabled`. `VoyageApp` watches that value and switches `ThemeMode`.

## How Screens Read State

Screens that display provider state use:

```dart
context.watch<AppStore>()
```

`watch` means:

- get the current store
- subscribe this widget to changes
- rebuild this widget when `notifyListeners()` is called

Example from Home:

```dart
final store = context.watch<AppStore>();
```

Home uses `store.trips` to render the trip list.

Example from Budget:

```dart
final store = context.watch<AppStore>();
final transactions = _filteredTransactions(store.activeTripTransactions);
```

Budget reads derived state from the store:

- `store.activeTrip`
- `store.activeBudget`
- `store.activeTripTransactions`

Example from Profile:

```dart
final profile = context.watch<AppStore>().profile;
```

Profile rebuilds when the loaded or edited profile changes.

Example from Settings:

```dart
final preferences = context.watch<AppStore>().preferences;
```

Settings rebuilds when preferences change.

## How Screens Write State

Screens that perform actions use:

```dart
context.read<AppStore>()
```

`read` means:

- get the current store
- do not subscribe this particular call to changes
- useful inside button handlers, form submits, and callbacks

Example from Add Trip:

```dart
await context.read<AppStore>().createTrip(
  destination: destination,
  title: title,
  startDate: _startDate,
  endDate: _endDate,
  budget: _parseMoney(_budgetController.text),
);
```

Example from Add Expense:

```dart
await store.addExpense(
  title: title,
  amount: amount,
  expenseType: _expenseType,
  category: _category,
  date: _date,
);
```

Example from Edit Profile:

```dart
await context.read<AppStore>().updateProfile(
  name: name,
  email: email,
  avatarUrl: _avatarController.text.trim(),
);
```

Using `watch` inside event handlers is unnecessary because the handler does not need to rebuild. Using `read` in a widget that displays changing data would not rebuild when the data changes. That split keeps rebuilds predictable.

## Error Handling

Firebase repository classes catch Firebase exceptions and map them to app-level exceptions:

```dart
AppException _mapError(FirebaseException e) {
  if (e.code == 'unavailable' || e.code == 'network-request-failed') {
    return const NetworkException();
  }
  return const UnknownException();
}
```

`AppStore` catches `AppException`, stores `errorMessage`, and notifies listeners. Auth-specific errors are stored on `AuthProvider.error`.

## Models

### UserProfile

`UserProfile` stores:

- `name`
- `email`
- `avatarUrl`

It is created from the `users/{uid}` document.

### UserPreferences

`UserPreferences` currently stores:

- `darkModeEnabled`

The value is written to the user document and read by `VoyageApp` to choose light or dark theme.

### Trip

`Trip` stores:

- `id`
- `destination`
- `title`
- `startDate`
- `endDate`
- `budget`

Firestore stores dates as `Timestamp`. `Trip.fromJson()` accepts Firestore timestamps and converts them to `DateTime`.

### Transaction

`Transaction` stores:

- `id`
- `tripId`
- `title`
- `amount`
- `date`
- `expenseType`
- `category`
- `iconAsset`

`tripId` links a transaction to the active trip and lets Budget filter expenses correctly.

## Screen Behavior

### Login And Register

Login and Register call `AuthProvider`, which delegates to Firebase Auth. Registration also creates the first Firestore user document.

### Home

Home waits until `AuthGate` has allowed authenticated, loaded state. It then reads `store.trips`.

### Browse Destinations

Browse Destinations reads hardcoded popular destinations from `AppStore.popularDestinations`. Tapping a destination opens Add Trip with that destination prefilled.

### Add Trip

Add Trip writes a new trip to Firestore through `AppStore.createTrip()`. The new trip becomes the active trip.

### Budget

Budget reads the active trip, active budget, and active trip transactions from `AppStore`.

### Add Expense

Add Expense writes a transaction under the active trip. If no active trip exists, it asks the user to create a trip first.

### Profile And Edit Profile

Profile reads `store.profile`. Edit Profile writes profile changes back to the Firestore user document.

### Settings

Settings reads and writes `store.preferences.darkModeEnabled`.

## Tests

The current widget test covers Provider-backed navigation behavior:

- it builds `BrowseDestinationsScreen` inside a `ChangeNotifierProvider`
- it supplies `AppStore` with fake repository implementations
- it taps `Kyoto, Japan`
- it verifies that Add Trip opens with the destination field prefilled

The fake repositories keep the widget test independent from Firebase services.

## Why This Shape Works

The current structure keeps UI code readable without hiding the backend:

```text
screens -> Provider -> AppStore/AuthProvider -> repositories -> Firebase
```

Screens do not know Firestore collection paths. Repositories do not know widget state. `AppStore` coordinates app data for the UI and keeps derived values like active budget in one place.
