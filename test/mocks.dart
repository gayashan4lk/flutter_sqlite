import 'package:flutter_sqlite/models/dog.dart';
import 'package:flutter_sqlite/repositories/dog_repository.dart';
import 'package:flutter_sqlite/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

// Test data helpers
class TestDogs {
  static List<Dog> getSampleDogs() {
    return [
      const Dog(id: 1, name: 'Buddy', age: 3),
      const Dog(id: 2, name: 'Max', age: 5),
      const Dog(id: 3, name: 'Bella', age: 2),
    ];
  }
}

// Manual mock implementations
class MockDatabaseService implements DatabaseService {
  final List<Dog> _dogs = [];
  
  @override
  Future<List<Dog>> getDogs() async => _dogs;
  
  @override
  Future<void> insertDog(Dog dog) async {
    final nextId = _dogs.isEmpty ? 1 : (_dogs.map((d) => d.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    _dogs.add(Dog(id: nextId, name: dog.name, age: dog.age));
  }
  
  @override
  Future<int> deleteDog(int id) async {
    final initialLength = _dogs.length;
    _dogs.removeWhere((dog) => dog.id == id);
    return initialLength - _dogs.length;
  }
  
  void setupWithSampleDogs() {
    _dogs.clear();
    _dogs.addAll(TestDogs.getSampleDogs());
  }
  
  // Implement other required methods with stub implementation
  @override
  Future<Database> get database async => throw UnimplementedError();
  
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockDogRepository implements DogRepository {
  final List<Dog> _dogs = [];
  bool _shouldFailGetDogs = false;
  
  void setupSuccess() {
    _shouldFailGetDogs = false;
    _dogs.clear();
    _dogs.addAll(TestDogs.getSampleDogs());
  }
  
  void clearDogs() {
    _dogs.clear();
  }
  
  void setupFailure() {
    _shouldFailGetDogs = true;
  }
  
  @override
  Future<List<Dog>> getDogs() async {
    if (_shouldFailGetDogs) {
      throw Exception('Failed to get dogs');
    }
    return _dogs;
  }
  
  @override
  Future<void> insertDog(Dog dog) async {
    final nextId = _dogs.isEmpty ? 1 : (_dogs.map((d) => d.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    _dogs.add(Dog(id: nextId, name: dog.name, age: dog.age));
  }
  
  @override
  Future<bool> deleteDog(int id) async {
    final initialLength = _dogs.length;
    _dogs.removeWhere((dog) => dog.id == id);
    return initialLength > _dogs.length;
  }
}

