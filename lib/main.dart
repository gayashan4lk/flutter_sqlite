import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'repositories/dog_repository.dart';
import 'viewmodels/dog_view_model.dart';
import 'views/dog_list_view.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create services and repositories
    final dbService = DatabaseService.instance;
    final dogRepository = DogRepository(dbService: dbService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DogViewModel(repository: dogRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dog Database App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DogListView(),
      ),
    );
  }
}
