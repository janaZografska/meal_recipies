import 'package:flutter/material.dart';
import 'screens/categories_screen.dart.dart';
import 'screens/meals_by_category_screen.dart';
import 'screens/meal_details_screen.dart';


void main() => runApp(MealApp());


class MealApp extends StatelessWidget {
  const MealApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Meal Recipes',
theme: ThemeData(
primaryColor: Colors.black,
scaffoldBackgroundColor: Colors.white,
appBarTheme: AppBarTheme(
backgroundColor: Colors.black,
foregroundColor: Colors.white,
),
),
home: CategoriesScreen(),
routes: {
MealsByCategoryScreen.routeName: (_) => MealsByCategoryScreen(),
MealDetailScreen.routeName: (_) => MealDetailScreen(),
},
);
}
}