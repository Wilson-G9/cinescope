import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/movie_data.dart';

/// Màn hình 3: MOVIE DETAIL SCREEN
///
/// Kỹ thuật Navigation:
///   - Nhận dữ liệu: ModalRoute.of(context)!.settings.arguments as Movie
///   - Trả kết quả: Navigator.pop(context, true) → HomeScreen đang await
///   - Phim liên quan: MaterialPageRoute + RouteSettings(arguments: movie)
///     → Demo cách điều hướng thứ 2 bên cạnh Named Routes
class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Movie _movie;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // ─── NHẬN DỮ LIỆU ────────────────────────────────────────────────────
      // ModalRoute.of(context).settings.arguments chứa object được truyền sang
      // từ màn hình trước qua arguments: movie.
      // Ép kiểu về Movie để truy cập các thuộc tính.
      // ────────────────────────────────────────────────────────────────────
      _movie = ModalRoute.of(context)!.settings.arguments as Movie;
      _initialized = true;
    }
  }

  void _toggleFavorite() {
    setState(() {
      _movie.isFavorited = !_movie.isFavorited;
      // Đồng bộ vào danh sách gốc theo id
      final index = MovieData.movies.indexWhere((m) => m.id == _movie.id);
      if (index != -1) {
        MovieData.movies[index].isFavorited = _movie.isFavorited;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final posterColor = Color(int.parse(_movie.posterColor, radix: 16));

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // ─── ĐIỀU HƯỚNG QUAY LẠI + Trả kết quả ─────────────────────────
            // Navigator.pop(context, result) trả giá trị về cho màn hình đang
            // await. HomeScreen nhận result này để quyết định có setState() không.
            // ────────────────────────────────────────────────────────────────
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _movie.isFavorited ? Icons.favorite : Icons.favorite_outline,
              color: _movie.isFavorited
                  ? const Color(0xFFE50914)
                  : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Container(
              height: 260,
              width: double.infinity,
              color: posterColor,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, const Color(0xFF141414)],
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(Icons.movie_rounded,
                        color: Colors.white.withOpacity(0.15), size: 120),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50914),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE50914).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🎬 Đang phát phim...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 40),
                        iconSize: 40,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    _movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Metadata
                  Row(
                    children: [
                      _buildBadge(
                          Icons.star, _movie.rating.toString(), const Color(0xFFFFC107)),
                      const SizedBox(width: 10),
                      _buildBadge(Icons.calendar_today, _movie.year, Colors.blue),
                      const SizedBox(width: 10),
                      _buildBadge(Icons.timer, _movie.duration, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Genre
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFFE50914)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_movie.genre,
                        style: const TextStyle(
                            color: Color(0xFFE50914), fontSize: 13)),
                  ),
                  const SizedBox(height: 20),

                  // Nút hành động
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE50914),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                          label: const Text('Xem ngay',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _toggleFavorite,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          side: BorderSide(
                            color: _movie.isFavorited
                                ? const Color(0xFFE50914)
                                : Colors.grey,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: Icon(
                          _movie.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: _movie.isFavorited
                              ? const Color(0xFFE50914)
                              : Colors.grey,
                        ),
                        label: Text(
                          _movie.isFavorited ? 'Đã lưu' : 'Yêu thích',
                          style: TextStyle(
                              color: _movie.isFavorited
                                  ? const Color(0xFFE50914)
                                  : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mô tả
                  const Text('Nội dung',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(_movie.description,
                      style: TextStyle(
                          color: Colors.grey[400], fontSize: 15, height: 1.6)),
                  const SizedBox(height: 24),

                  // Đạo diễn
                  _buildInfoRow('Đạo diễn', _movie.director),
                  const SizedBox(height: 16),

                  // Diễn viên
                  const Text('Diễn viên',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ..._movie.cast.map((actor) => _buildActorRow(actor)),

                  const SizedBox(height: 32),

                  // Phim liên quan
                  _buildRelatedMovies(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildActorRow(String actor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF2A2A2A),
            child: Text(actor[0],
                style:
                    const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Text(actor,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildRelatedMovies(BuildContext context) {
    final related = MovieData.movies
        .where((m) => m.id != _movie.id && m.genre == _movie.genre)
        .take(3)
        .toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Phim liên quan',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...related.map((movie) {
          return GestureDetector(
            onTap: () {
              // ─── ĐIỀU HƯỚNG bằng MaterialPageRoute ─────────────────────
              // Cách thứ 2: dùng MaterialPageRoute kết hợp RouteSettings
              // để vẫn truyền arguments như Named Route nhưng linh hoạt hơn.
              // ────────────────────────────────────────────────────────────
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MovieDetailScreen(),
                  settings: RouteSettings(
                    name: '/detail',
                    arguments: movie,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(int.parse(movie.posterColor, radix: 16)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.movie, color: Colors.white30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('${movie.year} • ${movie.duration}',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFFFFC107), size: 14),
                            const SizedBox(width: 4),
                            Text(movie.rating.toString(),
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}