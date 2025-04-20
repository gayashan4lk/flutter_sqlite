import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../repositories/dog_repository.dart';

class DogViewModel extends ChangeNotifier {
  final DogRepository _repository;
  
  List<Dog> _dogs = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters for UI
  List<Dog> get dogs => _dogs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  DogViewModel({required DogRepository repository}) : _repository = repository {
    loadDogs();
  }
  
  // Load all dogs from repository
  Future<void> loadDogs() async {
    _setLoading(true);
    try {
      _dogs = await _repository.getDogs();
      _error = null;
    } catch (e) {
      _error = 'Failed to load dogs: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }
  
  // Add a new dog
  Future<void> addDog(String name, int age) async {
    _setLoading(true);
    try {
      final dog = Dog(name: name, age: age);
      await _repository.insertDog(dog);
      await loadDogs(); // Reload the list
      _error = null;
    } catch (e) {
      _error = 'Failed to add dog: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> deleteDog(int id) async {
    _setLoading(true);
    try {
      final success = await _repository.deleteDog(id);
      if (success) {
        await loadDogs(); // Reload the list after successful deletion
      } else {
        _error = 'Failed to delete dog with ID: $id';
      }
      return success;
    } catch (e) {
      _error = 'Error deleting dog: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
