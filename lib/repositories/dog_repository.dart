import '../models/dog.dart';
import '../services/database_service.dart';

class DogRepository {
  final DatabaseService _dbService;

  DogRepository({required DatabaseService dbService}) : _dbService = dbService;

  Future<List<Dog>> getDogs() async {
    return _dbService.getDogs();
  }

  Future<void> insertDog(Dog dog) async {
    await _dbService.insertDog(dog);
  }
}
