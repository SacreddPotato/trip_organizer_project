# Text Editing Controllers In This App

This app uses Flutter's `TextEditingController` for form fields where the screen needs to read, seed, or dispose text input explicitly.

A controller is not the app's source of truth. It is temporary UI state for one screen. When the user submits a form, the screen reads the controller text, validates it, and passes clean values into `AuthProvider` or `AppStore`.

## Shared Text Field Pattern

Most controlled text fields go through:

```text
lib/presentation/widgets/labeled_text_field.dart
```

`LabeledTextField` accepts an optional `TextEditingController` and passes it directly to Flutter's `TextField`:

```dart
TextField(
  controller: controller,
  readOnly: readOnly,
  obscureText: obscureText,
  keyboardType: isNumber ? TextInputType.number : TextInputType.text,
  onTap: onTap,
)
```

That keeps the field styling reusable while each screen still owns its own controllers and submit logic.

## Controller Lifecycle

The standard lifecycle in this app is:

1. Create the controller in the `State` object.
2. Pass it to a `LabeledTextField`.
3. Read `controller.text` when the user taps the submit button.
4. Call `dispose()` in the screen's `dispose()` method.

Example:

```dart
final _tripNameController = TextEditingController();

@override
void dispose() {
  _tripNameController.dispose();
  super.dispose();
}
```

Disposing matters because controllers hold resources and listeners. Any controller created by a screen should be disposed by that same screen.

## Add Trip Controllers

File:

```text
lib/presentation/screens/add_trip_screen.dart
```

Controllers:

- `_destinationController`
- `_tripNameController`
- `_budgetController`

### `_destinationController`

This controls the `Destination` field.

It is initialized in `initState()` because the destination can be prefilled when the user taps a destination card:

```dart
_destinationController = TextEditingController(
  text: widget.initialDestination ?? '',
);
```

When the form is submitted, `_saveTrip()` reads and trims it:

```dart
final destination = _destinationController.text.trim();
```

The destination is required. If it is empty, the screen shows a snackbar and does not create a trip.

### `_tripNameController`

This controls the `Trip Name` field.

It starts empty:

```dart
final _tripNameController = TextEditingController();
```

When the form is submitted, `_saveTrip()` reads and trims it:

```dart
final title = _tripNameController.text.trim();
```

The trip name is also required.

### `_budgetController`

This controls the `Budget` field.

It is passed to a numeric `LabeledTextField`:

```dart
LabeledTextField(
  label: 'Budget',
  controller: _budgetController,
  isNumber: true,
)
```

`isNumber: true` changes the keyboard type, but it does not validate or parse the value by itself.

On submit, the raw text is parsed by `_parseMoney()`:

```dart
budget: _parseMoney(_budgetController.text),
```

`_parseMoney()` removes everything except digits and decimal points, then tries to parse a `double`. Invalid or empty input becomes `0`.

### Date Fields Are Not Controller-Based

`Start Date` and `End Date` do not use `TextEditingController`.

They use `DateTime` state:

```dart
DateTime _startDate = DateTime.now();
DateTime _endDate = DateTime.now().add(const Duration(days: 7));
```

The fields are read-only. Tapping them opens `showDatePicker()`, then `setState()` updates the date values.

## Login Controllers

File:

```text
lib/presentation/screens/auth/login_screen.dart
```

Controllers:

- `_emailController`
- `_passwordController`

`_signIn()` reads both values:

```dart
final email = _emailController.text.trim();
final password = _passwordController.text;
```

Email is trimmed because surrounding spaces are never meaningful. Password is not trimmed because spaces may be part of the password.

If either field is empty, the screen shows a snackbar. Otherwise it calls:

```dart
auth.signIn(email: email, password: password);
```

## Register Controllers

File:

```text
lib/presentation/screens/auth/register_screen.dart
```

Controllers:

- `_fullNameController`
- `_emailController`
- `_passwordController`
- `_confirmController`

`_register()` reads all four values:

```dart
final fullName = _fullNameController.text.trim();
final email = _emailController.text.trim();
final password = _passwordController.text;
final confirm = _confirmController.text;
```

Name and email are trimmed. Password and confirm are not trimmed.

Validation happens before calling the auth provider:

- full name, email, and password must be present
- password and confirm must match

After validation, the screen calls:

```dart
auth.register(email: email, password: password, fullName: fullName);
```

## Edit Profile Controllers

File:

```text
lib/presentation/screens/profile/edit_profile_screen.dart
```

Controllers:

- `_nameController`
- `_emailController`
- `_avatarController`

These are initialized in `initState()` from the current `AppStore` profile:

```dart
final profile = context.read<AppStore>().profile;
_nameController = TextEditingController(text: profile.name);
_emailController = TextEditingController(text: profile.email);
_avatarController = TextEditingController(text: profile.avatarUrl);
```

That makes the edit form open with the current saved profile values.

On save, the screen reads and validates name and email:

```dart
final name = _nameController.text.trim();
final email = _emailController.text.trim();
```

Then it updates the store:

```dart
context.read<AppStore>().updateProfile(
  name: name,
  email: email,
  avatarUrl: _avatarController.text.trim(),
);
```

### Avatar Preview Note

The avatar preview reads `_avatarController.text` during `build()`, but the screen does not currently listen to controller changes. That means typing a new avatar URL may not refresh the preview until something else triggers a rebuild.

If live preview becomes important, add a listener in `initState()`:

```dart
_avatarController.addListener(() => setState(() {}));
```

## Add Expense Controllers

File:

```text
lib/presentation/screens/budget/add_expense_screen.dart
```

Controllers:

- `_amountController`
- `_titleController`

### `_amountController`

This controls the `Amount` field.

Like trip budget, it uses `isNumber: true` for the keyboard type and `_parseMoney()` for parsing:

```dart
final amount = _parseMoney(_amountController.text);
```

The amount must be greater than `0`.

### `_titleController`

This controls the `Description` field.

On submit, the value is trimmed:

```dart
final title = _titleController.text.trim();
```

The title must not be empty.

### Dropdowns And Date Are Not Controllers

Expense type and category are controlled by enum state:

```dart
ExpenseType _expenseType = ExpenseType.dining;
TransactionCategory _category = TransactionCategory.travel;
```

Date is controlled by a `DateTime` value:

```dart
DateTime _date = DateTime.now();
```

Those values are updated with `setState()` instead of `TextEditingController`.

## Current Controller Inventory

| Screen | Controller | Field | Initial value | Submit destination |
| --- | --- | --- | --- | --- |
| Add Trip | `_destinationController` | Destination | `initialDestination` or empty | `AppStore.createTrip(destination: ...)` |
| Add Trip | `_tripNameController` | Trip Name | empty | `AppStore.createTrip(title: ...)` |
| Add Trip | `_budgetController` | Budget | empty | `AppStore.createTrip(budget: ...)` |
| Login | `_emailController` | Email | empty | `AuthProvider.signIn(email: ...)` |
| Login | `_passwordController` | Password | empty | `AuthProvider.signIn(password: ...)` |
| Register | `_fullNameController` | Full Name | empty | `AuthProvider.register(fullName: ...)` |
| Register | `_emailController` | Email | empty | `AuthProvider.register(email: ...)` |
| Register | `_passwordController` | Password | empty | `AuthProvider.register(password: ...)` |
| Register | `_confirmController` | Confirm Password | empty | compared with password only |
| Edit Profile | `_nameController` | Full Name | `AppStore.profile.name` | `AppStore.updateProfile(name: ...)` |
| Edit Profile | `_emailController` | Email Address | `AppStore.profile.email` | `AppStore.updateProfile(email: ...)` |
| Edit Profile | `_avatarController` | Avatar URL | `AppStore.profile.avatarUrl` | `AppStore.updateProfile(avatarUrl: ...)` |
| Add Expense | `_amountController` | Amount | empty | `AppStore.addExpense(amount: ...)` |
| Add Expense | `_titleController` | Description | empty | `AppStore.addExpense(title: ...)` |

## Rules Of Thumb For Adding New Controllers

- Use a controller when the screen needs to read text on submit, prefill a field, clear a field, or observe text changes.
- Keep controllers private to the screen state class.
- Initialize prefilled controllers in `initState()`.
- Trim human-entered labels like names, emails, destinations, titles, and descriptions.
- Do not trim passwords unless the product intentionally disallows leading or trailing spaces.
- Parse money at submit time, not inside the reusable text field.
- Always dispose controllers in `dispose()`.
- Use normal state variables for dates, dropdowns, toggles, and other non-text values.
