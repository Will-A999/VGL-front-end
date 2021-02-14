import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import '../constants/color-constants.dart';

class AppContainer extends StatefulWidget {
  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  static ColorConstants colorConstants = new ColorConstants();
  static TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: colorConstants.primary);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Featured',
      style: optionStyle,
    ),
    Text(
      'Discover',
      style: optionStyle,
    ),
    Text(
      'Suggestions',
      style: optionStyle,
    ),
    Text(
      'Favorites',
      style: optionStyle,
    ),
  ];

  int _selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.secondary,
      appBar: AppBar(
        elevation: 20,
        title: const Text('The Video Game Library'),
        backgroundColor: colorConstants.primary,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedItemPosition),
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.pinned,
        snakeShape: SnakeShape.indicator,
        padding: EdgeInsets.all(0),
        backgroundColor: colorConstants.secondary,
        snakeViewColor: colorConstants.primary,
        selectedItemColor: colorConstants.primary,
        unselectedItemColor: colorConstants.primary,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        items: [
          BottomNavigationBarItem(icon: _selectedItemPosition==0 ? Icon(Icons.home) : Icon(Icons.home_outlined), label: 'Featured'),
          BottomNavigationBarItem(icon: _selectedItemPosition==1 ? Icon(Icons.search) : Icon(Icons.search_outlined), label: 'Discover'),
          BottomNavigationBarItem(icon: _selectedItemPosition==2 ? Icon(Icons.star) : Icon(Icons.star_border), label: 'Suggestions'),
          BottomNavigationBarItem(icon: _selectedItemPosition==3 ? Icon(Icons.favorite) : Icon(Icons.favorite_border), label: 'Favorites'),
        ],
      )
    );
  }
}