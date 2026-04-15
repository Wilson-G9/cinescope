import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../models/movie.dart';

/// Màn hình 4: FAVORITES SCREEN
///
/// Kỹ thuật Navigation:
///   - Navigator.pop(context) để quay về HomeScreen
///   - await Navigator.pushNamed('/detail', arguments: movie) rồi setState khi về
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Movie> get _favoriteMovies =>
      MovieData.movies.where((m) => m.isFavorited).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Text(
          'Phim yêu thích',
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_favoriteMovies.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50914),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_favoriteMovies.length}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _favoriteMovies.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoriteMovies.length,
              itemBuilder: (context, index) {
                return _buildFavoriteItem(context, _favoriteMovies[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, color: Colors.grey[700], size: 80),
          const SizedBox(height: 16),
          Text('Chưa có phim yêu thích',
              style: TextStyle(color: Colors.grey[500], fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Hãy thêm phim vào danh sách yêu thích\ncủa bạn từ trang chi tiết phim',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914)),
            child: const Text('Khám phá phim',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () async {
        // ─── ĐIỀU HƯỚNG đến Detail, đợi kết quả ─────────────────────────
        // Sau khi người dùng bỏ yêu thích trong Detail và quay về,
        // setState() sẽ cập nhật lại danh sách.
        // ────────────────────────────────────────────────────────────────
        await Navigator.pushNamed(context, '/detail', arguments: movie);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Poster
            Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: Color(int.parse(movie.posterColor, radix: 16)),
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14)),
              ),
              child: const Icon(Icons.movie,
                  color: Colors.white24, size: 40),
            ),

            // Thông tin
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('${movie.genre} • ${movie.year}',
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Color(0xFFFFC107), size: 15),
                        const SizedBox(width: 4),
                        Text(movie.rating.toString(),
                            style: TextStyle(
                                color: Colors.grey[300], fontSize: 13)),
                        const SizedBox(width: 10),
                        Text(movie.duration,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Nút xóa yêu thích
            IconButton(
              icon: const Icon(Icons.favorite, color: Color(0xFFE50914)),
              onPressed: () {
                setState(() {
                  movie.isFavorited = false;
                  final index =
                      MovieData.movies.indexWhere((m) => m.id == movie.id);
                  if (index != -1) {
                    MovieData.movies[index].isFavorited = false;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}