import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';
import 'package:trip_organizer_project/data/models/trip_model.dart';
import 'package:trip_organizer_project/data/repositories/interfaces/trip_repository.dart';
import 'package:trip_organizer_project/data/repositories/interfaces/user_repository.dart';
import 'package:trip_organizer_project/presentation/screens/add_trip_screen.dart';
import 'package:trip_organizer_project/presentation/screens/browse_destinations_screen.dart';

void main() {
  testWidgets(
    'tapping a destination opens trip planning with destination selected',
    (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppStore(
            tripRepository: _FakeTripRepository(),
            userRepository: _FakeUserRepository(),
          ),
          child: MaterialApp(
            home: const BrowseDestinationsScreen(),
            onGenerateRoute: (settings) {
              if (settings.name == '/add_trip') {
                return MaterialPageRoute<void>(
                  builder: (_) => AddTripScreen(
                    initialDestination: settings.arguments as String?,
                  ),
                );
              }
              return null;
            },
          ),
        ),
      );

      await tester.tap(find.text('Kyoto, Japan'));
      await tester.pumpAndSettle();

      expect(find.text('Plan a Trip'), findsOneWidget);

      final destinationField = tester.widget<TextField>(
        find.byType(TextField).first,
      );
      expect(destinationField.controller?.text, 'Kyoto, Japan');
    },
  );
}

class _FakeTripRepository implements TripRepository {
  @override
  Future<String> addTransaction(
    String uid,
    String tripId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<String> createTrip(String uid, Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<List<Transaction>> fetchTransactions(String uid, String tripId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Trip>> fetchTrips(String uid) async => [];
}

class _FakeUserRepository implements UserRepository {
  @override
  Future<Map<String, dynamic>?> fetchUserDocument(String uid) async => null;

  @override
  Future<void> saveActiveTripId(String uid, String? tripId) {
    throw UnimplementedError();
  }

  @override
  Future<void> savePreferences(String uid, Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveProfile(String uid, Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}
