import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dto/recipe.dart';
import 'dto/data_control.dart';

class DataPage extends StatefulWidget {
  final DataControl dataControl;

  const DataPage({Key? key, required this.dataControl}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Box<Recipe> recipeBox;

  List<Recipe> recipes = [];

  final titleController = TextEditingController();
  final instructionController = TextEditingController();
  final ingredientsController = TextEditingController();
  final imageController = TextEditingController();
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    recipeBox = Hive.box<Recipe>('recipes'); // 데이터 컨트롤을 통해 접근
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      recipes = recipeBox.values.toList();
    });
  }

  void _addOrUpdateRecipe() async {
    if (editingIndex == null) {
      final recipe = Recipe(
        id: Uuid().v4(),
        title: titleController.text,
        instruction: instructionController.text,
        ingredients: ingredientsController.text.split(','),
        image: imageController.text,
      );

      await recipeBox.add(recipe);
    } else {
      final recipe = Recipe(
        id: recipes[editingIndex!].id, // 유지할 ID
        title: titleController.text,
        instruction: instructionController.text,
        ingredients: ingredientsController.text.split(','),
        image: imageController.text,
      );

      await recipeBox.putAt(editingIndex!, recipe);
    }

    _loadRecipes();
    _clearForm();
  }

  void _editRecipe(int index) {
    final recipe = recipes[index];
    titleController.text = recipe.title;
    instructionController.text = recipe.instruction;
    ingredientsController.text = recipe.ingredients.join(',');
    imageController.text = recipe.image;
    editingIndex = index;
  }

  void _deleteRecipe(int index) async {
    await recipeBox.deleteAt(index);
    _loadRecipes();
  }

  void _clearForm() {
    titleController.clear();
    instructionController.clear();
    ingredientsController.clear();
    imageController.clear();
    editingIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Database"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/userPage');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: instructionController,
              decoration: const InputDecoration(labelText: 'Instruction'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients (comma-separated)'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
          ),
          ElevatedButton(
            onPressed: _addOrUpdateRecipe,
            child: Text(editingIndex == null ? 'Add Recipe' : 'Update Recipe'),
          ),
          ElevatedButton(
            onPressed: _clearForm,
            child: const Text('Clear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  title: Text(recipe.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${recipe.id}'),
                      Text('Instruction: ${recipe.instruction}'),
                      Text('Ingredients: ${recipe.ingredients.join(', ')}'),
                      Text('Image URL: ${recipe.image}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editRecipe(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteRecipe(index),
                      ),
                    ],
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
