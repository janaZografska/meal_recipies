import 'package:flutter/material.dart';
import '../models/meal_details.dart';
import '../services/api_service.dart';
import '../services/favorites_manager.dart';

class MealDetailScreen extends StatefulWidget {
  static const String routeName = '/meal_detail';
  final MealDetail? meal;

  const MealDetailScreen({super.key, this.meal});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService api = ApiService();
  MealDetail? meal;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.meal != null) {
      meal = widget.meal;
      setState(() => loading = false);
    } else {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (meal == null && args != null) {
        load(args as String);
      }
    }
  }

  Future<void> load(String mealId) async {
    setState(() => loading = true);
    try {
      final fetchedMeal = await api.fetchMealDetail(mealId);
      setState(() => meal = fetchedMeal);
    } catch (e) {
      // handle error
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = meal != null && favoritesManager.isFavorite(meal!.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(meal?.name ?? 'Meal Detail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (meal != null)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                favoritesManager.toggleFavorite(meal!.id);
                setState(() {});
              },
            ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 4))
          : meal == null
              ? Center(child: Text('No meal found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal image
                      Image.network(
                        meal!.thumbnail,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal!.name,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            Text('Category: ${meal!.category} | Area: ${meal!.area}',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            SizedBox(height: 16),
                            Text('Instructions',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            SizedBox(height: 8),
                            Text(meal!.instructions, style: TextStyle(color: Colors.grey[800])),
                            SizedBox(height: 16),
                            Text('Ingredients',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            SizedBox(height: 8),
                            ...meal!.ingredients
                                .map((ing) => Text('• ${ing['ingredient']} - ${ing['measure']}'))
                                ,
                            if (meal!.youtube.isNotEmpty) ...[
                              SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: () {
                                  // Open YouTube video
                                },
                                child: Text('Watch Video', style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
