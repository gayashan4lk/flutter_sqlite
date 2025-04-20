import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sqlite/views/dog_list_view.dart';
import 'package:flutter_sqlite/viewmodels/dog_view_model.dart';
import '../mocks.dart';

void main() {
  late MockDogRepository mockRepository;

  setUp(() {
    mockRepository = MockDogRepository();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => DogViewModel(repository: mockRepository),
        child: const DogListView(),
      ),
    );
  }

  group('DogListView widget tests', () {
    testWidgets('shows loading indicator when view model is loading', (WidgetTester tester) async {
      // Setup view model in loading state
      mockRepository.setupSuccess();
      
      // Build widget tree
      await tester.pumpWidget(createTestWidget());
      
      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Complete loading
      await tester.pump(const Duration(milliseconds: 300));
    });
    
    testWidgets('shows empty state message when no dogs exist', (WidgetTester tester) async {
      // Setup view model with empty dogs list
      mockRepository.setupSuccess();
      mockRepository.clearDogs(); // empty the dogs list
      
      // Build widget tree
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Wait for loading to complete
      
      // Verify empty state message is shown
      expect(find.text('No dogs added yet'), findsOneWidget);
    });
    
    testWidgets('shows list of dogs when dogs exist', (WidgetTester tester) async {
      // Setup view model with sample dogs
      mockRepository.setupSuccess();
      
      // Build widget tree
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Wait for loading to complete
      
      // Verify the dogs are listed
      expect(find.text('Buddy'), findsOneWidget);
      expect(find.text('Max'), findsOneWidget);
      expect(find.text('Bella'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
    });
    
    testWidgets('shows error message when loading fails', (WidgetTester tester) async {
      // Setup view model with error
      mockRepository.setupFailure();
      
      // Build widget tree
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      
      // Verify error message is shown
      expect(find.textContaining('Failed to load dogs'), findsOneWidget);
    });
  });
}
