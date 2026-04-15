import '../models/movie.dart';

/// Dữ liệu mẫu cho ứng dụng
class MovieData {
  static List<Movie> movies = [
    Movie(
      id: 1,
      title: 'Interstellar',
      genre: 'Sci-Fi',
      rating: 8.6,
      year: '2014',
      duration: '2h 49m',
      description:
          'Khi Trái Đất trở nên không còn có thể ở được, một nhóm phi hành gia '
          'dũng cảm thực hiện chuyến hành trình xuyên qua lỗ sâu đục trong không gian '
          'để tìm kiếm ngôi nhà mới cho nhân loại.',
      posterColor: 'FF1A237E',
      cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
      director: 'Christopher Nolan',
    ),
    Movie(
      id: 2,
      title: 'The Dark Knight',
      genre: 'Action',
      rating: 9.0,
      year: '2008',
      duration: '2h 32m',
      description:
          'Batman đối mặt với kẻ thù nguy hiểm nhất — Joker, một tên tội phạm '
          'hỗn loạn muốn đẩy Gotham City vào tình trạng vô chính phủ.',
      posterColor: 'FF212121',
      cast: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'],
      director: 'Christopher Nolan',
    ),
    Movie(
      id: 3,
      title: 'Inception',
      genre: 'Sci-Fi',
      rating: 8.8,
      year: '2010',
      duration: '2h 28m',
      description:
          'Một tên trộm với khả năng đặc biệt — đi vào giấc mơ của người khác '
          'để lấy cắp bí mật — được giao nhiệm vụ cài ý tưởng vào tâm trí mục tiêu.',
      posterColor: 'FF37474F',
      cast: ['Leonardo DiCaprio', 'Joseph Gordon-Levitt', 'Elliot Page'],
      director: 'Christopher Nolan',
    ),
    Movie(
      id: 4,
      title: 'Parasite',
      genre: 'Thriller',
      rating: 8.5,
      year: '2019',
      duration: '2h 12m',
      description:
          'Một gia đình nghèo từng bước xâm nhập vào cuộc sống của gia đình '
          'giàu có, dẫn đến những tình huống bất ngờ và hậu quả không thể lường trước.',
      posterColor: 'FF1B5E20',
      cast: ['Song Kang-ho', 'Lee Sun-kyun', 'Cho Yeo-jeong'],
      director: 'Bong Joon-ho',
    ),
    Movie(
      id: 5,
      title: 'Avengers: Endgame',
      genre: 'Action',
      rating: 8.4,
      year: '2019',
      duration: '3h 1m',
      description:
          'Sau thất bại thảm khốc, các Avengers còn lại tập hợp lần cuối cùng '
          'để đảo ngược hành động của Thanos và khôi phục vũ trụ.',
      posterColor: 'FF880E4F',
      cast: ['Robert Downey Jr.', 'Chris Evans', 'Mark Ruffalo'],
      director: 'Anthony & Joe Russo',
    ),
    Movie(
      id: 6,
      title: 'Your Name',
      genre: 'Romance',
      rating: 8.4,
      year: '2016',
      duration: '1h 46m',
      description:
          'Hai học sinh trung học ở vùng nông thôn và thành thị bỗng nhiên '
          'hoán đổi thân xác cho nhau, tạo ra mối liên kết vượt qua không gian và thời gian.',
      posterColor: 'FF4A148C',
      cast: ['Ryûnosuke Kamiki', 'Mone Kamishiraishi'],
      director: 'Makoto Shinkai',
    ),
  ];

  static List<String> genres = [
    'Tất cả',
    'Action',
    'Sci-Fi',
    'Thriller',
    'Romance',
    'Drama',
  ];
}