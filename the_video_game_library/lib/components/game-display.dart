import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'dart:convert';
import '../models/game.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:the_video_game_library/constants/color-constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameDisplay extends StatefulWidget {
  GameDisplay({Key key, this.gameId}) : super(key: key);

  final gameId;

  @override
  _GameDisplayState createState() => _GameDisplayState();
}

class _GameDisplayState extends State<GameDisplay> {
  Game _game;
  static ColorConstants colorConstants = new ColorConstants();
  bool likeToggled = false;
  Widget _loader = Center(
    child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(colorConstants.primary)
    )
  );

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  fetchData() async {
    Game game;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.get('authToken');

    final response = await http.get(
      'https://the-video-game-library.herokuapp.com/games/getGameById/${this.widget.gameId}',
      headers:{
        'Accept': 'application/json',
        'Authorization': token
      }
    );

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body);
      var retrievedGame = extractedData['data'];
      game = Game(
        id: retrievedGame["id"],
        name: retrievedGame['name'],
        cover: retrievedGame['cover'],
        likes: retrievedGame['likes'],
        review_score: retrievedGame['review_score'],
        genreData: retrievedGame['genres'],
        platformData: retrievedGame['platforms'],
        description: retrievedGame['description'],
        liked: retrievedGame['liked'] != null? retrievedGame['liked']: null
      );

      this.setState(() {
        _game = game;
      });
    }
  }

  navigateBack() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var index = preferences.get('index');

    if(likeToggled && index == '2'){
      Navigator.pushReplacementNamed(
        context,
        '/app',
        arguments: 2,
      );
    }

    else if(likeToggled && index == '3'){
      Navigator.pushReplacementNamed(
        context,
        '/app',
        arguments: 3,
      );
    }

    else{
      Navigator.pop(context);
    }
  }

  toggleLikedGame() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.get('authToken');

    if(!_game.liked){
      var response = await http.post(
        "https://the-video-game-library.herokuapp.com/favorite/like-game",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "gameId": _game.id.toString()
        })
      );

      if(response.statusCode == 200){
        this.setState(() {
          this._game.liked = true;
          this._game.likes++;
          this.likeToggled = true;
        });
      }
    }

    else{
      var response = await http.post(
          "https://the-video-game-library.herokuapp.com/favorite/unlike-game",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token
          },
          body: jsonEncode(<String, String>{
            "gameId": _game.id.toString()
          })
      );

      if(response.statusCode == 200){
        this.setState(() {
          this._game.liked = false;
          this._game.likes--;
          this.likeToggled = true;
        });
      }
    }
  }

  Widget getTitle(){
    return Padding(
      padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
      child: Container(
          constraints: BoxConstraints(minWidth: 300),
          decoration: BoxDecoration(
              border: Border.all(color: colorConstants.primary, width: 2),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: colorConstants.primary,
                    blurRadius: 10.0,
                    spreadRadius: 0.0, //extend the shadow
                    offset: Offset(2.0, 2.0)
                )
              ]
          ),
          child: Container(
            decoration: BoxDecoration(
                color: colorConstants.secondary,
                borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                _game.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorConstants.tertiary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
      ),
    );
  }

  Widget getImage(){
    return Padding(
        padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
        child: Container(
          height: 200,
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
                "https://images.igdb.com/igdb/image/upload/t_cover_big/${_game.cover}.jpg",
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _loader;
                }
            ),
          ),
        )
    );
  }

  Widget getFavoriteReview(){
    return WillPopScope(
      onWillPop: () => this.navigateBack(),
      child: Padding(
          padding: EdgeInsets.fromLTRB(50, 25, 50, 0),
          child: Container(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        _game.liked == null?
                        Icon(Icons.favorite, color: Colors.grey, size: 30):
                        IconButton(
                          icon: Icon(_game.liked? Icons.favorite: Icons.favorite_border, color: colorConstants.primary, size: 30),
                          onPressed: toggleLikedGame,
                        ),
                        Text(
                          " "+_game.likes.toString(),
                          style: TextStyle(color: colorConstants.primary, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.star, color: colorConstants.primary, size: 30),
                        Text(
                          ' ${((_game.review_score/100)*10).floor().toString()}/10',
                          style: TextStyle(color: colorConstants.primary, fontSize: 20),
                        )
                      ],
                    ),
                  )
                ],
              )
          )
      ),
    );
  }

  Widget getDescription(){
    return Padding(
      padding: EdgeInsets.fromLTRB(50, 25, 50, 0),
      child: Text(
        _game.description,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colorConstants.tertiary,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget getGenres(){
    List<Widget> genres = [];
    for(int count=0; count<_game.genres.length; count++){
      genres.add(
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Chip(
            label: Text(_game.genres[count]),
            backgroundColor: colorConstants.primary,
          ),
        )
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(50, 25, 50, 0),
      child: Column(
        children: [
          Text(
            'Genres',
            style: TextStyle(color: colorConstants.primary, fontSize: 20),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: genres,
          )
        ],
      ),
    );
  }

  Widget getPlatforms(){
    List<Widget> platforms = [];
    for(int count=0; count<_game.platforms.length; count++){
      platforms.add(
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Chip(
            label: Text(_game.platforms[count]),
            backgroundColor: colorConstants.primary,
          ),
        )
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(50, 25, 50, 0),
      child: Column(
        children: [
          Text(
            'Platforms',
            style: TextStyle(color: colorConstants.primary, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: platforms,
          )
        ],
      ),
    );
  }

  getMultiplayer(){
    if(_game.multiplayer){
      return Padding(
        padding: EdgeInsets.fromLTRB(50, 25, 50, 50),
        child: Container(),
      );
    }

    else{
      return Padding(
        padding: EdgeInsets.fromLTRB(50, 30, 50, 50),
        child: Text(
          'Multiplayer Enabled',
          style: TextStyle(color: colorConstants.primary, fontSize: 20),
        )
      );
    }
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
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: colorConstants.tertiary, size: 30),
                  onPressed: navigateBack,
                )
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
                  icon: Icon(Icons.settings, color: colorConstants.tertiary, size: 30)
                )
              ),
            ],
          )
        ),
        body: Center(
          child: SingleChildScrollView(
            child: _game == null?
            Loading(indicator: BallPulseIndicator(), size: 100.0,color: colorConstants.primary):
            Column(
              children: [
                getTitle(),
                getImage(),
                getFavoriteReview(),
                getDescription(),
                getGenres(),
                getPlatforms(),
                getMultiplayer()
              ],
            )
          ),
        ),
      ),
    );
  }
}


