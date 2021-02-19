import 'package:flutter/material.dart';
import '../models/game.dart';


class FeaturedCard extends StatefulWidget {
  FeaturedCard({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {

  @override
  Widget build(BuildContext context) {
    return  Padding(
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
              image: NetworkImage("https://images.igdb.com/igdb/image/upload/t_cover_big/${this.widget.game.cover}.jpg"),
            ),
          ),
        ),
      )
    );
  }
}