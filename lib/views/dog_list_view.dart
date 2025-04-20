import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dog_view_model.dart';
import '../models/dog.dart';

class DogListView extends StatefulWidget {
  const DogListView({super.key});

  @override
  State<DogListView> createState() => _DogListViewState();
}

class _DogListViewState extends State<DogListView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
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
                    onPressed: () => _addDog(context),
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
            child: Consumer<DogViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (viewModel.error != null) {
                  return Center(child: Text(viewModel.error!));
                }
                
                if (viewModel.dogs.isEmpty) {
                  return const Center(child: Text('No dogs added yet'));
                }
                
                return ListView.builder(
                  itemCount: viewModel.dogs.length,
                  itemBuilder: (context, index) {
                    final dog = viewModel.dogs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(dog.id.toString()),
                      ),
                      title: Text(dog.name),
                      subtitle: Text('Age: ${dog.age}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDeleteDog(context, dog),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addDog(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<DogViewModel>(context, listen: false);
      final name = _nameController.text;
      final age = int.parse(_ageController.text);
      
      viewModel.addDog(name, age).then((_) {
        _nameController.clear();
        _ageController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dog added successfully')),
        );
      });
    }
  }

  void _confirmDeleteDog(BuildContext context, Dog dog) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dog'),
        content: Text('Are you sure you want to delete ${dog.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Make sure dog.id is not null before proceeding
              if (dog.id != null) {
                Navigator.pop(context);
                
                final viewModel = Provider.of<DogViewModel>(context, listen: false);
                viewModel.deleteDog(dog.id!).then((success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? '${dog.name} was deleted successfully'
                            : 'Failed to delete ${dog.name}',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                });
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
