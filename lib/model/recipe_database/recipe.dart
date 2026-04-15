import 'package:flutter/material.dart';
import 'package:json_schema/json_schema.dart';
import 'package:lab2/model/recipe_database/ingredient.dart';

class Recipe {
  final String name;
  final int servings;
  final String difficulty;
  final int time;
  final String cuisine;
  final int price;
  final String mainIngredient;
  final String instruction;
  final String description;
  final String imagePath;
  final List<Ingredient> ingredients;

  static const Map schemaMap = {
    "type": "object",
    "properties": {
      "name": {"type": "string"},
      "servings": {"type": "integer"},
      "difficulty": {
        "type": "string",
        "enum": ["easy", "medium", "hard"],
      },
      "time": {"type": "integer"},
      "cuisine": {"type": "string"},
      "price": {"type": "integer"},
      "mainIngredient": {"type": "string"},
      "instruction": {"type": "string"},
      "description": {"type": "string"},
      "imagePath": {"type": "string"},

      "ingredients": {"type": "array", "items": Ingredient.schemaMap},
    },
    "required": [
      "name",
      "servings",
      "difficulty",
      "time",
      "cuisine",
      "price",
      "mainIngredient",
      "instruction",
      "description",
      "imagePath",
      "ingredients",
    ],
  };

  int get difficultyIndex => ["easy", "medium", "hard"].indexOf(difficulty);

  static final schema = JsonSchema.create(schemaMap);

  Image? _image;

  Recipe(
    this.name,
    this.servings,
    this.difficulty,
    this.time,
    this.cuisine,
    this.price,
    this.mainIngredient,
    this.instruction,
    this.description,
    this.imagePath,
    this.ingredients,
  );

  factory Recipe.fromJson(Map<String, dynamic> json) {
    ValidationResults validationResults = schema.validate(json);

    if (!validationResults.isValid) {
      throw FormatException(
        "Invalid Recipe JSON:\n${validationResults.errors.join("\n")}",
      );
    }

    return Recipe(
      json["name"] as String,
      json["servings"] as int,
      json["difficulty"] as String,
      json["time"] as int,
      json["cuisine"] as String,
      json["price"] as int,
      json["mainIngredient"] as String,
      json["instruction"] as String,
      json["description"] as String,
      json["imagePath"] as String,
      (json["ingredients"] as List)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Image get image {
    String path = 'assets/recipes/';

    if (_image == null) {
      path = path + imagePath;
      _image = Image.asset(path);
    }
    return _image!;
  }

  Image customImage({double width = 56, height = 56, BoxFit? fit}) {
    String path = 'assets/recipes/';

    path = path + imagePath;
    return Image.asset(path, width: width, height: height, fit: fit);
  }
}
