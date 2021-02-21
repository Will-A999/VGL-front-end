class Game {
  final int id;
  final String name;
  final String description;
  final String cover;
  final int release_date;
  final int likes;
  final bool multiplayer;
  final int review_score;
  final platforms;
  final genres;

  Game({
    this.id,
    this.name,
    this.description = "",
    this.cover = "",
    this.release_date = 0,
    this.likes = 0,
    this.multiplayer = false,
    this.review_score = 0,
    this.platforms = 0,
    this.genres = 0,
  });
}
