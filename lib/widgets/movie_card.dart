import 'package:flutter/material.dart';
import '../models/movie.dart';

/// Widget thẻ phim hiển thị trong SliverGrid ở HomeScreen
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final posterColor = Color(int.parse(movie.posterColor, radix: 16));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: posterColor,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(Icons.movie_rounded,
                          color: Colors.white.withOpacity(0.2), size: 50),
                    ),
                    if (movie.isFavorited)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE50914),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite,
                              color: Colors.white, size: 12),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFFFFC107), size: 11),
                            const SizedBox(width: 3),
                            Text(movie.rating.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Thông tin
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.genre,
                            style: const TextStyle(
                                color: Color(0xFFE50914), fontSize: 11)),
                        Text('${movie.year} • ${movie.duration}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}