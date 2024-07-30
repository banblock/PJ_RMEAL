import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pj_rmeal/src/dto/recipe.dart';
import 'package:pj_rmeal/src/dto/data_control.dart';
import 'package:pj_rmeal/src/ui/body/RecipePage.dart'; // RecipePage 임포트
import 'package:uuid/uuid.dart';

class DataPage extends StatefulWidget {
  final DataControl dataControl;

  const DataPage({Key? key, required this.dataControl}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Box<Recipe> recipeBox;
  List<Recipe> recipes = [];

  final idController = TextEditingController();
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
    try {
      recipeBox = await Hive.openBox<Recipe>('recipes'); // Box 열기
      _loadRecipes(); // 데이터 로드
    } catch (e) {
      print('Error opening box: $e'); // 오류 메시지 출력
    }
  }

  void _loadRecipes() {
    setState(() {
      recipes = recipeBox.values.toList();
    });
  }

  void _addOrUpdateRecipe() async {
    try {
      if (titleController.text.isEmpty ||
          instructionController.text.isEmpty ||
          ingredientsController.text.isEmpty ||
          imageController.text.isEmpty) {
        throw Exception('Title, instruction, ingredients, and image cannot be empty');
      }

      final recipeId = idController.text.isNotEmpty ? idController.text : Uuid().v4();

      if (widget.dataControl.isRecipeIdDuplicate(recipeId)) {
        throw Exception('Recipe with id $recipeId already exists');
      }

      final recipe = Recipe(
        id: recipeId,
        title: titleController.text,
        instruction: instructionController.text,
        ingredients: ingredientsController.text.split(','),
        image: imageController.text,
      );

      if (editingIndex == null) {
        await recipeBox.add(recipe);
      } else {
        await recipeBox.putAt(editingIndex!, recipe);
      }

      _loadRecipes();
      _clearForm();
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearForm();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _editRecipe(int index) {
    final recipe = recipes[index];
    idController.text = recipe.id;
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
    idController.clear();
    titleController.clear();
    instructionController.clear();
    ingredientsController.clear();
    imageController.clear();
    editingIndex = null;
  }

  void _navigateToRecipePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipePage(recipeBox: recipeBox),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Database"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.save), // 메뉴 아이콘
          onPressed: _navigateToRecipePage, // RecipePage로 이동
        ),
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
              controller: idController,
              decoration: const InputDecoration(labelText: 'ID (leave empty for auto)'),
            ),
          ),
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
