import 'package:flutter/material.dart';
//import 'package:pj_rmeal/src/dto/recipe.dart';
import 'package:pj_rmeal/src/dto/recipes.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipes recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${recipe.id}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 8),
            // Text(
            //   'Title: ${recipe.title}',
            //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Instruction: ${recipe.instruction}',
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Ingredients: ${recipe.ingredients.join(', ')}',
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Image URL: ${recipe.image}',
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
          ],
        ),
      ),
    );
  }
}
