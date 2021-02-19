import 'package:flutter/material.dart';
import '../components/featured-row.dart';

class Featured extends StatelessWidget {
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
            Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
            FeaturedRow(
              title: "Best Rated",
              route: "best-rated"
            ),
            FeaturedRow(
              title: "Popular",
              route: "popular"
            ),
            FeaturedRow(
              title: "Upcoming",
              route: "upcoming"
            ),
            FeaturedRow(
                title: "New Releases",
                route: "new-releases"
            )
          ],
        ),
      )
    );
  }
}


