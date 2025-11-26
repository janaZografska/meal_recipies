class Meal {
  final String id;
  final String name;
  final String thumbnail;

  Meal({required this.id, required this.name, required this.thumbnail});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
    );
  }
}

class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtube;
  final List<Map<String, String>> ingredients; // [{ingredient: measure}]

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    // extract ingredients and measures (the API uses strIngredient1..20)
    List<Map<String, String>> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingKey = 'strIngredient\$i';
      final measKey = 'strMeasure\$i';
      final ing = (json[ingKey] ?? '').toString().trim();
      final meas = (json[measKey] ?? '').toString().trim();
      if (ing.isNotEmpty) {
        ingredients.add({"ingredient": ing, "measure": meas});
      }
    }

    return MealDetail(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      youtube: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}