import 'package:flutter/material.dart';
import 'package:pj_rmeal/src/dto/user.dart';
import 'package:pj_rmeal/src/dto/data_control.dart';

class UserPage extends StatefulWidget {
  final DataControl dataControl;

  const UserPage({Key? key, required this.dataControl}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User? user;
  final userIdController = TextEditingController();
  final excludedIngredientsController = TextEditingController();
  final healthConditionController = TextEditingController();
  bool isLoading = true;
  String? editingField;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await widget.dataControl.init();
      await _loadUser();
    } catch (e) {
      print("Error initializing data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUser() async {
    try {
      final loadedUser = widget.dataControl.getUser();
      setState(() {
        user = loadedUser;
        if (user != null) {
          userIdController.text = user!.userId;
          excludedIngredientsController.text = user!.excludedIngredients.join(', ');
          healthConditionController.text = user!.healthCondition;
        }
      });
    } catch (e) {
      print("Error loading user: $e");
    }
  }

  Future<void> _saveUser() async {
    final userId = userIdController.text.trim();
    final excludedIngredients = excludedIngredientsController.text.split(',').map((e) => e.trim()).toList();
    final healthCondition = healthConditionController.text.trim();

    if (userId.length > 20) {
      _showError('User ID cannot be more than 20 characters');
      return;
    }

    if (healthCondition.length > 100) {
      _showError('Health Condition cannot be more than 100 characters');
      return;
    }

    try {
      final updatedUser = User(
        userId: userId.isNotEmpty ? userId : user!.userId,
        excludedIngredients: excludedIngredients,
        healthCondition: healthCondition,
      );

      if (user == null) {
        throw Exception('No user data available to update');
      } else {
        await widget.dataControl.updateUser(updatedUser);
      }

      await _loadUser();
    } catch (e) {
      await _showError(e.toString());
    }
  }

  Future<void> _showError(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("User Information"),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("User Information"),
          centerTitle: true,
        ),
        body: const Center(child: Text('No user data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Information"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await widget.dataControl.deleteUser();
                setState(() {
                  user = null;
                  userIdController.clear();
                  excludedIngredientsController.clear();
                  healthConditionController.clear();
                });
              } catch (e) {
                await _showError(e.toString());
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoCard("User ID", userIdController, "User ID (leave empty for auto)", 'userId'),
            _buildUserInfoCard("Health Condition", healthConditionController, "Health Condition", 'healthCondition'),
            _buildUserInfoCard("Excluded Ingredients", excludedIngredientsController, "Excluded Ingredients (comma-separated)", 'excludedIngredients'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(String title, TextEditingController controller, String hint, String field) {
    return InkWell(
      onTap: () {
        setState(() {
          editingField = field;
        });
      },
      child: Card(
        color: editingField == field ? Colors.grey[200] : Colors.white,
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: title,
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                  enabled: editingField == field,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              if (editingField == field)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.save, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        editingField = null;
                      });
                      _saveUser();
                    },
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
