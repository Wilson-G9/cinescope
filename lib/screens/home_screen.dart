import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/category_chip.dart';

/// Màn hình 2: HOME SCREEN
///
/// Kỹ thuật Navigation:
///   - await Navigator.pushNamed('/detail', arguments: movie)
///     → Truyền Movie object sang Detail, đợi kết quả trả về
///   - Nhận result (bool) từ MovieDetailScreen để cập nhật UI
///   - Navigator.pushNamed('/favorites') và Navigator.pushNamed('/profile')
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomIndex = 0;
  String _selectedGenre = 'Tất cả';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Movie> get _filteredMovies {
    List<Movie> result = MovieData.movies;
    if (_selectedGenre != 'Tất cả') {
      result = result.where((m) => m.genre == _selectedGenre).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((m) =>
              m.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              m.director.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  // ─── ĐIỀU HƯỚNG ─────────────────────────────────────────────────────────────
  // Dùng await để đợi kết quả trả về từ MovieDetailScreen.
  // result == true nghĩa là trạng thái yêu thích đã thay đổi → setState để render lại.
  // ────────────────────────────────────────────────────────────────────────────
  Future<void> _navigateToDetail(Movie movie) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: movie,
    );

    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF141414),
              floating: true,
              snap: true,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE50914),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.movie_filter_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'CineScope',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm phim, đạo diễn...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Banner nổi bật
                    _buildFeaturedBanner(),

                    const SizedBox(height: 28),

                    // Thể loại
                    const Text(
                      'Thể loại',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: MovieData.genres.length,
                        itemBuilder: (context, index) {
                          final genre = MovieData.genres[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CategoryChip(
                              label: genre,
                              isSelected: _selectedGenre == genre,
                              onTap: () =>
                                  setState(() => _selectedGenre = genre),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      _searchQuery.isNotEmpty
                          ? 'Kết quả tìm kiếm (${_filteredMovies.length})'
                          : _selectedGenre == 'Tất cả'
                              ? 'Tất cả phim'
                              : 'Thể loại: $_selectedGenre',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Grid phim
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: _filteredMovies.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Text('Không tìm thấy phim',
                              style: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final movie = _filteredMovies[index];
                          return MovieCard(
                            movie: movie,
                            onTap: () => _navigateToDetail(movie),
                          );
                        },
                        childCount: _filteredMovies.length,
                      ),
                    ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF1E1E1E),
          indicatorColor: const Color(0xFFE50914).withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedBottomIndex,
          backgroundColor: const Color(0xFF1E1E1E),
          onDestinationSelected: (index) {
            setState(() => _selectedBottomIndex = index);
            if (index == 1) {
              // ─── ĐIỀU HƯỚNG đến FavoritesScreen ──────────────────────────
              Navigator.pushNamed(context, '/favorites');
            } else if (index == 2) {
              // ─── ĐIỀU HƯỚNG đến ProfileScreen ────────────────────────────
              Navigator.pushNamed(context, '/profile');
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.home, color: Color(0xFFE50914)),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline, color: Colors.grey),
              selectedIcon: Icon(Icons.favorite, color: Color(0xFFE50914)),
              label: 'Yêu thích',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.grey),
              selectedIcon: Icon(Icons.person, color: Color(0xFFE50914)),
              label: 'Hồ sơ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    final featured = MovieData.movies[0];
    return GestureDetector(
      onTap: () => _navigateToDetail(featured),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Color(int.parse(featured.posterColor, radix: 16)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE50914),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '🔥 NỔI BẬT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    featured.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${featured.rating}  •  ${featured.year}  •  ${featured.genre}',
                        style:
                            TextStyle(color: Colors.grey[300], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 24,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white.withOpacity(0.3),
                  size: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}