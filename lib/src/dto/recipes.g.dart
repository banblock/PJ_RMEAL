// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipesAdapter extends TypeAdapter<Recipes> {
  @override
  final int typeId = 1;

  @override
  Recipes read(BinaryReader reader) {
    final id = reader.readString();
    return Recipes(id: id);
  }

  @override
  void write(BinaryWriter writer, Recipes obj) {
    writer.writeString(obj.id);
  }
}
