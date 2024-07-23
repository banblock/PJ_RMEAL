import 'package:flutter/material.dart';
import 'dto/user.dart';
import 'dto/data_control.dart';

class UserPage extends StatefulWidget {
  final DataControl dataControl;

  const UserPage({Key? key, required this.dataControl}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> users = [];
  final excludedIngredientsController = TextEditingController();
  final healthConditionController = TextEditingController();
  User? selectedUser; // Track the user being edited

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await widget.dataControl.init(); // Ensure that DataControl is initialized
    _loadUsers(); // Load users after initialization
  }

  Future<void> _loadUsers() async {
    setState(() {
      users = widget.dataControl.getAllUsers();
    });
  }

  void _startEditing(User user) {
    // Set the selected user for editing
    selectedUser = user;
    excludedIngredientsController.text = user.excludedIngredients.join(', ');
    healthConditionController.text = user.healthCondition;
  }

  Future<void> _addOrUpdateUser() async {
    final excludedIngredients = excludedIngredientsController.text.split(',');
    final healthCondition = healthConditionController.text;

    if (selectedUser == null) {
      // Add new user
      await widget.dataControl.addUser(
        excludedIngredients: excludedIngredients,
        healthCondition: healthCondition,
      );
    } else {
      // Update existing user
      final user = User(
        userId: selectedUser!.userId, // Use the ID of the selected user
        excludedIngredients: excludedIngredients,
        healthCondition: healthCondition,
      );
      await widget.dataControl.updateUser(users.indexOf(selectedUser!), user);
    }

    // Clear selection and reload users after adding/updating
    selectedUser = null;
    excludedIngredientsController.clear();
    healthConditionController.clear();
    await _loadUsers();
  }

  Future<void> _deleteUser(int index) async {
    if (index < 0 || index >= users.length) {
      print("Error: Index out of range.");
      return;
    }

    await widget.dataControl.deleteUser(index);
    await _loadUsers(); // Reload users after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: excludedIngredientsController,
              decoration: const InputDecoration(labelText: 'Excluded Ingredients (comma-separated)'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: healthConditionController,
              decoration: const InputDecoration(labelText: 'Health Condition'),
            ),
          ),
          ElevatedButton(
            onPressed: _addOrUpdateUser,
            child: Text(selectedUser == null ? 'Add User' : 'Update User'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text('User ID: ${user.userId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Excluded Ingredients: ${user.excludedIngredients.join(', ')}'),
                      Text('Health Condition: ${user.healthCondition}'),
                    ],
                  ),
                  onTap: () => _startEditing(user), // Start editing the selected user
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteUser(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
