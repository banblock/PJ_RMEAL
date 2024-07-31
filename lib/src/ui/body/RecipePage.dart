import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:pj_rmeal/src/dto/recipe.dart';
import 'package:pj_rmeal/src/dto/recipes.dart';
import 'package:pj_rmeal/src/ui/body/RecipeDetailPage.dart'; // RecipeDetailPage 임포트

class RecipePage extends StatefulWidget {
  final Box<Recipes> recipesBox;

  const RecipePage({Key? key, required this.recipesBox}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  void initState() {
    super.initState();
    // Ensure that we are using the box properly in the state
  }

  void _navigateToRecipeDetailPage(Recipes recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailPage(
          recipe: recipe,
          //recipeBox: widget.recipeBox,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Recipes> recipes = widget.recipesBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe List'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to DataPage
          },
        ),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text('need csv file..', style: Theme.of(context).textTheme.titleMedium),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${recipe.id}', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              onTap: () => _navigateToRecipeDetailPage(recipe), // Navigate to RecipeDetailPage on tap
            ),
          );
        },
      ),
    );
  }
}
