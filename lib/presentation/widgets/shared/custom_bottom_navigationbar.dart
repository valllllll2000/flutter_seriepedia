import 'package:cinemapedia/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedPageIndex;

  const CustomBottomNavigation({super.key, required this.selectedPageIndex});

  void onItemTapped(BuildContext context, int index) {
    context.go('/home/$index');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 0,
        currentIndex: selectedPageIndex,
        onTap: (value) => onItemTapped(context, value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Start'),
          BottomNavigationBarItem(
              icon: Icon(Icons.label_outline), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Favorites'),
        ]);
  }
}
