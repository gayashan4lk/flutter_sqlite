import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sqlite/repositories/dog_repository.dart';
import 'package:flutter_sqlite/models/dog.dart';
import '../mocks.dart';

void main() {
  late MockDatabaseService mockDatabaseService;
  late DogRepository dogRepository;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    dogRepository = DogRepository(dbService: mockDatabaseService);
  });

  group('getDogs', () {
    test('should return list of dogs from the database service', () async {
      // Arrange
      mockDatabaseService.setupWithSampleDogs();
      
      // Act
      final result = await dogRepository.getDogs();
      
      // Assert
      expect(result, isA<List<Dog>>());
      expect(result.length, equals(3));
      expect(result[0].name, equals('Buddy'));
      expect(result[1].name, equals('Max'));
      expect(result[2].name, equals('Bella'));
    });
    
    test('should return empty list when no dogs exist', () async {
      // Arrange - no setup to keep empty list
      
      // Act
      final result = await dogRepository.getDogs();
      
      // Assert
      expect(result, isA<List<Dog>>());
      expect(result.length, equals(0));
    });
  });
}
