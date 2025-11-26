import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';


class ApiService {
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final resp = await http.get(Uri.parse('$_base/categories.php'));
    if (resp.statusCode != 200) throw Exception('Failed to load categories');
    final data = json.decode(resp.body);
    final list = (data['categories'] as List).map((e) => Category.fromJson(e)).toList();
    return list;
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final resp = await http.get(Uri.parse('$_base/filter.php?c=$category'));
    if (resp.statusCode != 200) throw Exception('Failed to load meals');
    final data = json.decode(resp.body);
    final list = (data['meals'] as List).map((e) => Meal.fromJson(e)).toList();
    return list;
  }

  Future<List<Meal>> searchMeals(String query) async {
    final resp = await http.get(Uri.parse('$_base/search.php?s=$query'));
    if (resp.statusCode != 200) throw Exception('Failed to search meals');
    final data = json.decode(resp.body);
    if (data['meals'] == null) return [];
    final list = (data['meals'] as List).map((e) => Meal.fromJson(e)).toList();
    return list;
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final resp = await http.get(Uri.parse('$_base/lookup.php?i=$id'));
    if (resp.statusCode != 200) throw Exception('Failed to load meal detail');
    final data = json.decode(resp.body);
    final mealJson = (data['meals'] as List).first;
    return MealDetail.fromJson(mealJson);
  }

  Future<MealDetail> fetchRandomMeal() async {
    final resp = await http.get(Uri.parse('$_base/random.php'));
    if (resp.statusCode != 200) throw Exception('Failed to load random meal');
    final data = json.decode(resp.body);
    final mealJson = (data['meals'] as List).first;
    return MealDetail.fromJson(mealJson);
  }
}