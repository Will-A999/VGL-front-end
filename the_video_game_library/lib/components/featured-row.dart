import 'package:flutter/material.dart';
import '../constants/color-constants.dart';
import '../components/featured-card.dart';
import '../models/game.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FeaturedRow extends StatefulWidget {
  FeaturedRow({Key key, this.title, this.route}) : super(key: key);

  final String title;
  final String route;

  @override
  _FeaturedRowState createState() => _FeaturedRowState();
}

class _FeaturedRowState extends State<FeaturedRow> {
  static ColorConstants colorConstants = new ColorConstants();
  List<Game> _games = [];
  List<Widget> _gameCards = [];

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  fetchData() async{
    final response = await http.get('https://the-video-game-library.herokuapp.com/featured/${this.widget.route}');

    if(response.statusCode == 200){
      final extractedData = json.decode(response.body);
      List games = extractedData['data'];
      for(var game in games) {
        _games.add(Game(
          id: game["id"],
          name: game['name'],
          description: game['description'],
          cover: game['cover'],
          release_date: game['release_date'],
          likes: game['likes'],
          multiplayer: game['multiplayer'],
          review_score: game['review_score'],
          platforms: game['platforms'],
          genres: game['genres']
        ));
      }

      var index = 0;
      while(index<_games.length){
        _gameCards.add(
            Column(
              children: [
                FeaturedCard(game: _games[index]),
                index+1 < _games.length ? FeaturedCard(game: _games[++index]) : Container(),
              ],
            ),
        );
        ++index;
      }

      this.setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: TextStyle(color: colorConstants.tertiary, fontSize: 30, fontWeight: FontWeight.w500),
                )
            )
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _gameCards
                ),
              )
          )
        ],
      )
    );
  }
}

createGameCard(Game game){
  return Padding(
      padding: EdgeInsets.all(3),
      child: Card(
        color: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 125,
          width: 125,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage("https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover}.jpg"),
            ),
          ),
          // ),
        ),
      )
  );
}
}

// Column(
// children: [
// FeaturedCard(),
// FeaturedCard(),
// ],
// ),