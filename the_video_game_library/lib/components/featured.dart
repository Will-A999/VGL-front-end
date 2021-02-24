import 'package:flutter/material.dart';
import '../components/featured-row.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/game.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  List<Game> bestRatedGames = [];
  List<Game> upcomingGames = [];
  List<Game> popularGames = [];
  List<Game> newReleaseGames = [];

  @override
  void initState(){
    super.initState();

    fetchData('best-rated', 0);
    fetchData('popular', 1);
    fetchData('upcoming', 2);
    fetchData('new-releases', 3);
  }

  fetchData(route, option) async{
    List<Game> games = [];
    final response = await http.get('https://the-video-game-library.herokuapp.com/featured/${route}');

    if(response.statusCode == 200){
      final extractedData = json.decode(response.body);
      List retrievedGames = extractedData['data'];
      for(var game in retrievedGames) {
        games.add(Game(
          id: game["id"],
          name: game['name'],
          cover: game['cover']
        ));
      }

      this.setState(() {
        switch(option) {
          case 0: {bestRatedGames = games;}
          break;
          case 1: {popularGames = games;}
          break;
          case 2: {upcomingGames = games;}
          break;
          case 3: {newReleaseGames = games;}
          break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Center(
        child: ListView(
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,

          scrollDirection: Axis.vertical,
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
            FeaturedRow(
              games: bestRatedGames,
              title: 'Best Rated',
            ),
            FeaturedRow(
              games: popularGames,
              title: 'Popular',
            ),
            FeaturedRow(
              games: upcomingGames,
              title: 'Upcoming',
            ),
            FeaturedRow(
              games: newReleaseGames,
              title: 'New Releases',
            )
          ],
        ),
      )
    );
  }
}



