import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/favorites_manager.dart';
import '../widgets/meal.card.dart';
import 'meal_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const String routeName = '/favorites';

  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ApiService api = ApiService();
  List<Meal> favoriteMeals = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteMeals();
  }

  Future<void> _loadFavoriteMeals() async {
    setState(() => loading = true);
    try {
      List<Meal> meals = [];
      for (String mealId in favoritesManager.favoriteIds) {
        try {
          final mealDetail = await api.fetchMealDetail(mealId);
          meals.add(Meal(
            id: mealDetail.id,
            name: mealDetail.name,
            thumbnail: mealDetail.thumbnail,
          ));
        } catch (e) {
          // Handle error loading individual meal
        }
      }
      setState(() => favoriteMeals = meals);
    } catch (e) {
      // handle error
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Favorite Recipes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 4))
          : favoriteMeals.isEmpty
              ? Center(
                  child: Text(
                    'No favorite recipes yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: favoriteMeals.length,
                  itemBuilder: (ctx, i) {
                    final meal = favoriteMeals[i];
                    return MealCard(
                      meal: meal,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MealDetailScreen.routeName,
                          arguments: meal.id,
                        );
                      },
                    );
                  },
                ),
    );
  }
}
