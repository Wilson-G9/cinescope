/// Model đại diện cho một bộ phim
class Movie {
  final int id;
  final String title;
  final String genre;
  final double rating;
  final String year;
  final String duration;
  final String description;
  final String posterColor; // Mã hex màu đại diện poster
  final List<String> cast;
  final String director;
  bool isFavorited;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.year,
    required this.duration,
    required this.description,
    required this.posterColor,
    required this.cast,
    required this.director,
    this.isFavorited = false,
  });
}