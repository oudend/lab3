import 'package:json_schema/json_schema.dart';

class Ingredient {
  final String name;
  final num amount;
  final String unit;

  static const Map schemaMap = {
    "type": "object",
    "properties": {
      "name": {"type": "string"},
      "amount": {"type": "number"},
      "unit": {"type": "string"},
    },
    "required": ["name", "amount", "unit"],
  };

  static final schema = JsonSchema.create(schemaMap);

  Ingredient(this.name, this.amount, this.unit);

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    ValidationResults validationResults = schema.validate(json);

    if (!validationResults.isValid) {
      throw FormatException(
        "Invalid Recipe JSON:\n${validationResults.errors.join("\n")}",
      );
    }

    return Ingredient(
      json["name"] as String,
      json["amount"] as num,
      json["unit"] as String,
    );
  }

  @override
  String toString() {
    return '$amount $unit $name';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final Ingredient otherIngredient = other as Ingredient;
    return name == otherIngredient.name;
  }

  @override
  int get hashCode {
    int hash = 5;
    hash = 59 * hash + name.hashCode;
    return hash;
  }
}
