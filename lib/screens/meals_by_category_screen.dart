import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/meal_details.dart';
import '../services/api_service.dart';
import '../widgets/meal.card.dart';
import 'meal_details_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  static const String routeName = '/meals_by_category';

  const MealsByCategoryScreen({super.key});

  @override
  _MealsByCategoryScreenState createState() => _MealsByCategoryScreenState();

  static Widget openMealDetail(MealDetail meal) {
    return MealDetailScreen(meal: meal);
  }
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService api = ApiService();
  List<Meal> meals = [];
  bool loading = true;
  String? categoryName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (categoryName == null && args != null) {
      categoryName = args as String;
      load();
    }
  }

  Future<void> load() async {
    if (categoryName == null) return;
    setState(() => loading = true);
    try {
      final fetchedMeals = await api.fetchMealsByCategory(categoryName!);
      setState(() => meals = fetchedMeals);
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
        title: Text(categoryName ?? 'Meals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 4))
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: meals.length,
              itemBuilder: (ctx, i) {
                final meal = meals[i];
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
