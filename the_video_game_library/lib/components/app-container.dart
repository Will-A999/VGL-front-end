import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/color-constants.dart';
import '../components/featured.dart';
import '../components/suggestions.dart';
import '../components/favorites.dart';

class AppContainer extends StatefulWidget {
  @override
  _AppContainerState createState() => _AppContainerState();

}

class _AppContainerState extends State<AppContainer> {
  static ColorConstants colorConstants = new ColorConstants();
  static TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: colorConstants.primary);
  static List<Widget> _widgetOptions = <Widget>[
    Featured(),
    Text(
      'Discover',
      style: optionStyle,
    ),
    Suggestions(),
    Favorites(),
  ];
  int _selectedItemPosition = 1;

  logout() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: colorConstants.secondary,
          appBar: AppBar(
              backgroundColor: colorConstants.secondary,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container()
                  ),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Image.asset(
                          'lib/assets/logo4.png',
                          fit: BoxFit.fitWidth,
                        ),
                      )

                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.settings, color: colorConstants.tertiary, size: 30),
                        onPressed: logout
                      )
                  ),
                ],
              )
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedItemPosition),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: SnakeNavigationBar.color(
              behaviour: SnakeBarBehaviour.pinned,
              snakeShape: SnakeShape.indicator,
              padding: EdgeInsets.all(0),
              backgroundColor: colorConstants.secondary,
              snakeViewColor: colorConstants.primary,
              selectedItemColor: colorConstants.primary,
              unselectedItemColor: Colors.white,
              showUnselectedLabels: false,
              showSelectedLabels: true,
              currentIndex: _selectedItemPosition,
              onTap: (index) => setState(() => _selectedItemPosition = index),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Featured'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
                BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Suggestions'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
              ],
            ),
          )
      ),
    );
  }
}