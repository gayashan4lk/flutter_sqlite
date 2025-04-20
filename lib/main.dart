import 'package:flutter/material.dart';
import 'models/dog.dart';
import 'database/dog_database.dart';
import 'screens/dog_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DogDatabase.instance.insertDog(const Dog(name: 'Buddy', age: 2));
  final dogs = await DogDatabase.instance.getDogs();
  print(dogs);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dog Database App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DogListScreen(),
    );
  }
}

