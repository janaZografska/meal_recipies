import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import 'meals_by_category_screen.dart';
import 'meal_details_screen.dart';
import 'favorites_screen.dart';
import '../widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

@override
_CategoriesScreenState createState() => _CategoriesScreenState();
}


class _CategoriesScreenState extends State<CategoriesScreen> {
final ApiService api = ApiService();
List<Category> categories = [];
List<Category> filtered = [];
bool loading = true;


@override
void initState() {
super.initState();
load();
}


Future<void> load() async {
setState(() => loading = true);
try {
final cats = await api.fetchCategories();
setState(() {
categories = cats;
filtered = cats;
});
} catch (e) {
// handle
} finally {
setState(() => loading = false);
}
}


void _onSearch(String q) {
setState(() {
filtered = categories.where((c) => c.name.toLowerCase().contains(q.toLowerCase())).toList();
});
}

Future<void> _loadRandomMeal() async {
try {
final meal = await api.fetchRandomMeal();
if (mounted) {
Navigator.pushNamed(
context,
MealDetailScreen.routeName,
arguments: meal.id,
);
}
} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('Error loading random meal')),
);
}
}


@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
backgroundColor: Colors.black,
title: Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
),
body: loading
? Center(child: CircularProgressIndicator(color: Colors.black))
: Column(
children: [
// Search bar
Padding(
padding: EdgeInsets.all(8),
child: TextField(
decoration: InputDecoration(
hintText: 'Search categories',
hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
filled: true,
fillColor: Colors.grey[100],
prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
borderSide: BorderSide(color: Colors.grey[300]!, width: 1)
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
borderSide: BorderSide(color: Colors.black, width: 2)
)
),
style: TextStyle(color: Colors.black),
onChanged: _onSearch,
),
),
// Randomized Recipe button
Padding(
padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
child: SizedBox(
width: double.infinity,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.black,
padding: EdgeInsets.symmetric(vertical: 12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
),
onPressed: _loadRandomMeal,
child: Text(
'Randomized Recipe',
style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
),
),
),
),
// Favorite Recipes button
Padding(
padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
child: SizedBox(
width: double.infinity,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red[600],
padding: EdgeInsets.symmetric(vertical: 12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
),
onPressed: () => Navigator.pushNamed(context, FavoritesScreen.routeName),
child: Text(
'Favorite Recipes',
style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
),
),
),
),
// Categories list
Expanded(
child: ListView.builder(
padding: EdgeInsets.all(8),
itemCount: filtered.length,
itemBuilder: (ctx, i) {
final cat = filtered[i];
return GestureDetector(
onTap: () => Navigator.pushNamed(context, MealsByCategoryScreen.routeName, arguments: cat.name),
child: CategoryCard(category: cat, onTap: () => Navigator.pushNamed(context, MealsByCategoryScreen.routeName, arguments: cat.name)),
);
},
),
),
],
),
);
}
}