# 🎬 CineScope — Ứng Dụng Xem Phim Flutter

> **Môn học:** Lập trình Di động  
> **Mục tiêu:** Hiểu và sử dụng thành thạo Navigator, MaterialPageRoute, Named Routes, truyền dữ liệu giữa các màn hình trong Flutter

---

## Mục lục

1. [Tổng quan dự án](#1-tổng-quan-dự-án)
2. [Cấu trúc thư mục](#2-cấu-trúc-thư-mục)
3. [Sơ đồ điều hướng](#3-sơ-đồ-điều-hướng)
4. [Giải thích các khái niệm Navigation](#4-giải-thích-các-khái-niệm-navigation)
5. [Mô tả từng màn hình](#5-mô-tả-từng-màn-hình)
6. [Luồng truyền dữ liệu](#6-luồng-truyền-dữ-liệu)
7. [Hướng dẫn chạy ứng dụng](#7-hướng-dẫn-chạy-ứng-dụng)
8. [Tổng kết kỹ thuật](#8-tổng-kết-kỹ-thuật)
9. [Hướng mở rộng](#9-hướng-mở-rộng)

---

## 1. Tổng quan dự án

**CineScope** là ứng dụng xem phim xây dựng bằng Flutter/Dart, mô phỏng giao diện một ứng dụng streaming hiện đại phong cách tối (dark theme). Ứng dụng bao gồm 5 màn hình được kết nối với nhau thông qua hệ thống Navigation đầy đủ.

### Danh sách màn hình

| # | Màn hình | Named Route | Mục đích |
|---|----------|-------------|----------|
| 1 | SplashScreen | `/` | Khởi động, hiển thị logo và animation |
| 2 | HomeScreen | `/home` | Danh sách phim, tìm kiếm, lọc danh mục |
| 3 | MovieDetailScreen | `/detail` | Chi tiết phim, nhận dữ liệu từ màn hình trước |
| 4 | FavoritesScreen | `/favorites` | Danh sách phim đã lưu yêu thích |
| 5 | ProfileScreen | `/profile` | Thông tin người dùng và cài đặt |

### Kỹ thuật Navigation sử dụng

| Kỹ thuật | Mục đích |
|----------|----------|
| Named Routes | Định nghĩa tập trung, dễ quản lý |
| MaterialPageRoute | Điều hướng linh hoạt, hỗ trợ custom transition |
| Navigator.pushNamed | Chuyển màn hình theo tên route |
| Navigator.pushReplacementNamed | Thay thế màn hình hiện tại, không Back lại được |
| Navigator.pushNamedAndRemoveUntil | Xóa toàn bộ navigation stack |
| Navigator.pop(context, result) | Quay lại và trả kết quả cho màn hình trước |
| arguments (ModalRoute) | Truyền dữ liệu object giữa các màn hình |
| await Navigator.push | Đợi nhận kết quả từ màn hình tiếp theo |

---

## 2. Cấu trúc thư mục

```
cinescope/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── movie.dart
│   ├── data/
│   │   └── movie_data.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── movie_detail_screen.dart
│   │   ├── favorites_screen.dart
│   │   └── profile_screen.dart
│   └── widgets/
│       ├── movie_card.dart
│       └── category_chip.dart
├── pubspec.yaml
└── README.md
```

### Vai trò từng thành phần

| File | Vai trò |
|------|---------|
| `main.dart` | Entry point, khai báo toàn bộ Named Routes |
| `models/movie.dart` | Class Movie — model dữ liệu |
| `data/movie_data.dart` | Danh sách phim mẫu và thể loại |
| `screens/*.dart` | 5 màn hình chính của ứng dụng |
| `widgets/movie_card.dart` | Widget thẻ phim hiển thị trong Grid |
| `widgets/category_chip.dart` | Widget chip chọn thể loại |

---

## 3. Sơ đồ điều hướng

```
┌─────────────────────────────────────────────────────────────┐
│                    NAVIGATION FLOW                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   SplashScreen (/)                                          │
│         │                                                   │
│         │  pushReplacementNamed('/home')                    │
│         │  [sau 3 giây — không Back lại được]               │
│         ▼                                                   │
│   HomeScreen (/home) ◄──────────────────────────────────┐  │
│         │                                               │  │
│         │  pushNamed('/detail', arguments: movie)       │  │
│         │  [truyền Movie object sang Detail]            │  │
│         ▼                                               │  │
│   MovieDetailScreen (/detail)                           │  │
│         │                                               │  │
│         │  pop(context, true/false)                     │  │
│         │  [trả kết quả isFavorited về Home]            │  │
│         └────────────────────────────────────────────── ┘  │
│                                                             │
│   HomeScreen (/home)                                        │
│         │                                                   │
│         ├── BottomNav [Yêu thích]                          │
│         │       └── pushNamed('/favorites')                │
│         │             FavoritesScreen (/favorites)         │
│         │                   │                              │
│         │                   │  pushNamed('/detail',        │
│         │                   │  arguments: movie)           │
│         │                   └──► MovieDetailScreen         │
│         │                                                   │
│         └── BottomNav [Hồ sơ]                              │
│                 └── pushNamed('/profile')                   │
│                       ProfileScreen (/profile)             │
│                             │                              │
│                             │  pushNamedAndRemoveUntil     │
│                             │  [Đăng xuất — clear stack]   │
│                             └──► HomeScreen (/home)        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Giải thích các khái niệm Navigation

### 4.1 Named Routes

Thay vì điều hướng trực tiếp bằng class, Named Routes cho phép đặt tên cho từng màn hình và điều hướng qua tên đó. Toàn bộ được khai báo một lần duy nhất trong `MaterialApp`.

**Ưu điểm:**
- Tập trung quản lý tất cả route ở một nơi
- Dễ đọc, dễ bảo trì
- Hỗ trợ deep linking

### 4.2 MaterialPageRoute

Là cách điều hướng linh hoạt hơn, phù hợp khi cần truyền dữ liệu phức tạp hoặc tùy chỉnh hiệu ứng chuyển cảnh. Kết hợp với `RouteSettings` để vẫn truyền được `arguments` như Named Routes.

### 4.3 Push vs Pop vs PushReplacement

| Phương thức | Hành vi | Stack thay đổi |
|-------------|---------|----------------|
| `push` | Thêm màn hình mới | A → A, B |
| `pop` | Quay lại màn hình trước | A, B → A |
| `pushReplacement` | Thay thế màn hình hiện tại | A, B → A, C |
| `pushAndRemoveUntil` | Xóa hết stack cũ, thêm màn mới | A, B, C → D |

### 4.4 Truyền dữ liệu — 2 cách

**Cách 1 — Named Route với arguments:**
Dùng khi đã khai báo Named Route. Dữ liệu được truyền qua tham số `arguments` và nhận lại qua `ModalRoute.of(context).settings.arguments`.

**Cách 2 — MaterialPageRoute với constructor:**
Dùng khi muốn type-safe hơn. Dữ liệu truyền thẳng vào constructor của màn hình đích.

### 4.5 Nhận kết quả trả về

Kết hợp `await Navigator.push(...)` ở màn hình gọi và `Navigator.pop(context, result)` ở màn hình được gọi để tạo luồng dữ liệu hai chiều giữa các màn hình.

---

## 5. Mô tả từng màn hình

### Màn hình 1 — SplashScreen

**Vai trò:** Màn hình khởi động, hiển thị trong 3 giây khi mở app.

**Kỹ thuật Navigation:**
- Sử dụng `Future.delayed` kết hợp `pushReplacementNamed('/home')`
- `pushReplacementNamed` đảm bảo người dùng không thể nhấn Back để quay lại Splash

**Giao diện:**
- Logo CineScope với hiệu ứng fade-in và scale animation
- CircularProgressIndicator khi đang tải
- Background màu tối `#141414`

---

### Màn hình 2 — HomeScreen

**Vai trò:** Màn hình chính, trung tâm điều hướng của ứng dụng.

**Kỹ thuật Navigation:**
- `await Navigator.pushNamed('/detail', arguments: movie)` — điều hướng đến Detail và đợi kết quả
- Nhận `result` trả về từ Detail để cập nhật UI (setState)
- `pushNamed('/favorites')` và `pushNamed('/profile')` qua BottomNavigationBar

**Tính năng giao diện:**
- Search bar tìm kiếm theo tên phim và đạo diễn
- Banner phim nổi bật
- CategoryChip lọc theo thể loại
- SliverGrid hiển thị danh sách phim

---

### Màn hình 3 — MovieDetailScreen

**Vai trò:** Hiển thị chi tiết phim, trung tâm của tương tác người dùng.

**Kỹ thuật Navigation:**
- **Nhận dữ liệu:** `ModalRoute.of(context)!.settings.arguments as Movie`
- **Trả kết quả:** `Navigator.pop(context, true)` — báo về HomeScreen đã thay đổi trạng thái yêu thích
- **Điều hướng phim liên quan:** dùng `MaterialPageRoute` với `RouteSettings(arguments: movie)` để demo cách điều hướng thứ hai

**Tính năng giao diện:**
- Poster màu đại diện với gradient overlay
- Nút Play, Yêu thích, Chia sẻ
- Thông tin đầy đủ: rating, năm, thời lượng, thể loại, mô tả, đạo diễn, diễn viên
- Danh sách phim liên quan cùng thể loại

---

### Màn hình 4 — FavoritesScreen

**Vai trò:** Quản lý danh sách phim yêu thích.

**Kỹ thuật Navigation:**
- `Navigator.pop(context)` để quay về HomeScreen
- `await Navigator.pushNamed('/detail', arguments: movie)` rồi `setState` khi quay lại

**Tính năng giao diện:**
- ListView danh sách phim đã yêu thích
- Empty state khi chưa có phim nào
- Nút xóa trực tiếp khỏi danh sách
- Badge đếm số phim yêu thích

---

### Màn hình 5 — ProfileScreen

**Vai trò:** Hiển thị thông tin người dùng và cài đặt ứng dụng.

**Kỹ thuật Navigation:**
- `Navigator.pop(context)` để quay về
- `Navigator.pushNamedAndRemoveUntil('/home', (route) => false)` khi đăng xuất — xóa toàn bộ navigation stack

**Tính năng giao diện:**
- Avatar với tên viết tắt
- Thống kê: phim đã xem, yêu thích, đánh giá
- Danh sách cài đặt theo nhóm
- Dialog xác nhận đăng xuất

---

## 6. Luồng truyền dữ liệu

### Truyền Movie từ Home → Detail

```
HomeScreen                         MovieDetailScreen
    │                                      │
    │  pushNamed('/detail',                │
    │    arguments: movieObject)           │
    │ ─────────────────────────────────► │
    │                              ModalRoute.of(context)
    │                              .settings.arguments as Movie
    │                                      │
    │                              Hiển thị thông tin phim
    │                                      │
    │  result = true/false                 │
    │ ◄──────────────────────────────────  │
    │  pop(context, isFavorited)           │
    │                                      
    setState() nếu result == true
```

### Đồng bộ trạng thái yêu thích

Vì Flutter không có global state manager trong project này, trạng thái `isFavorited` được đồng bộ trực tiếp vào danh sách gốc `MovieData.movies` bằng cách tìm theo `id` và cập nhật in-place. Khi quay lại màn hình trước, `setState()` được gọi để render lại UI.

---

## 7. Hướng dẫn chạy ứng dụng

### Yêu cầu môi trường

| Công cụ | Phiên bản tối thiểu |
|---------|---------------------|
| Flutter SDK | 3.0.0 |
| Dart SDK | 3.0.0 |
| Android Studio / VS Code | Bất kỳ |
| Android Emulator / iOS Simulator | API 21+ / iOS 11+ |

### Các bước thực hiện

**Bước 1 — Tạo project mới**

```
flutter create cinescope
cd cinescope
```

**Bước 2 — Tạo cấu trúc thư mục**

```
mkdir -p lib/models lib/data lib/screens lib/widgets
```

**Bước 3 — Copy các file source**

Lần lượt copy nội dung từng file Dart vào đúng đường dẫn theo cấu trúc thư mục ở mục 2.

**Bước 4 — Cài đặt dependencies và chạy**

```
flutter pub get
flutter run
```

**Bước 5 — Kiểm tra trên nhiều nền tảng (tuỳ chọn)**

```
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

### Kiểm thử Navigation

| Hành động | Kết quả mong đợi |
|-----------|-----------------|
| Mở app | SplashScreen xuất hiện, tự chuyển sang Home sau 3 giây |
| Nhấn vào thẻ phim | Chuyển sang MovieDetailScreen với đúng thông tin phim |
| Nhấn ♥ trong Detail | Toggle yêu thích, nút thay đổi màu |
| Nhấn Back từ Detail | Quay lại Home, thẻ phim cập nhật icon ♥ |
| Nhấn tab Yêu thích | FavoritesScreen hiển thị phim đã lưu |
| Nhấn tab Hồ sơ → Đăng xuất → Xác nhận | Quay về Home, không Back lại Profile được |

---

## 8. Tổng kết kỹ thuật

### Bảng tổng hợp Navigation theo từng file

| File | Kỹ thuật sử dụng | Ghi chú |
|------|-----------------|---------|
| `main.dart` | `initialRoute`, `routes: {}` | Khai báo toàn bộ Named Routes |
| `splash_screen.dart` | `pushReplacementNamed` | Không cho phép Back về Splash |
| `home_screen.dart` | `await pushNamed + arguments` | Truyền Movie, nhận result |
| `movie_detail_screen.dart` | `ModalRoute.settings.arguments`, `pop(result)`, `MaterialPageRoute` | Nhận data, trả kết quả, demo 2 cách điều hướng |
| `favorites_screen.dart` | `pushNamed`, `pop`, `setState` | Điều hướng + đồng bộ state |
| `profile_screen.dart` | `pop`, `pushNamedAndRemoveUntil` | Đăng xuất clear stack |

### So sánh 3 cách truyền dữ liệu

| Cách | Ưu điểm | Nhược điểm | Dùng khi |
|------|---------|------------|----------|
| Named Route + arguments | Gọn, nhất quán | Cần ép kiểu (as Movie) | Route đã khai báo trước |
| MaterialPageRoute + constructor | Type-safe, rõ ràng | Verbose hơn | Cần đảm bảo kiểu dữ liệu |
| MaterialPageRoute + settings | Kết hợp linh hoạt | Hơi phức tạp | Tái sử dụng widget Detail |

---

## 9. Hướng mở rộng

| Tính năng | Thư viện gợi ý | Mục đích |
|-----------|---------------|---------|
| Quản lý state toàn cục | Provider / Riverpod / GetX | Thay thế đồng bộ in-place |
| Routing hiện đại | go_router | Deep linking, web support |
| Lưu dữ liệu local | shared_preferences / Hive | Giữ danh sách yêu thích |
| Dữ liệu phim thật | TMDB API + http/dio | Thay dữ liệu mẫu |
| Animation chuyển màn hình | Hero widget | Transition mượt mà hơn |
| Xác thực người dùng | Firebase Auth | Đăng nhập thật sự |#   c i n e s c o p e  
 