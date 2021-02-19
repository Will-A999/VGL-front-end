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
    this.description,
    this.cover,
    this.release_date,
    this.likes,
    this.multiplayer,
    this.review_score,
    this.platforms,
    this.genres
  });
}
