import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../database/dog_database.dart';

class DogListScreen extends StatefulWidget {
  const DogListScreen({super.key});

  @override
  State<DogListScreen> createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  
  List<Dog> _dogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadDogs() async {
    setState(() => _isLoading = true);
    final dogs = await DogDatabase.instance.getDogs();
    setState(() {
      _dogs = dogs;
      _isLoading = false;
    });
  }

  Future<void> _addDog() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final age = int.parse(_ageController.text);
      
      final dog = Dog(name: name, age: age);
      await DogDatabase.instance.insertDog(dog);
      
      _nameController.clear();
      _ageController.clear();
      
      await _loadDogs();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dog added successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dogs Database'),
      ),
      body: Column(
        children: [
          // Add dog form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Age must be a number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addDog,
                    child: const Text('Add Dog'),
                  ),
                ],
              ),
            ),
          ),
          
          // Divider
          const Divider(thickness: 1),
          
          // Dog list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _dogs.isEmpty
                    ? const Center(child: Text('No dogs added yet'))
                    : ListView.builder(
                        itemCount: _dogs.length,
                        itemBuilder: (context, index) {
                          final dog = _dogs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(dog.id.toString()),
                            ),
                            title: Text(dog.name),
                            subtitle: Text('Age: ${dog.age}'),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
