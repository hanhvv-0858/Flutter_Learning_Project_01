# Music Explorer 🎵

Ứng dụng mobile học Flutter thực chiến, sử dụng **Spotify Web API** để khám phá và lưu trữ album âm nhạc. Dự án được xây dựng theo kiến trúc 3 tầng (Presentation → Provider → Data), bao gồm đầy đủ các kỹ thuật Flutter cơ bản đến nâng cao.

> **Branch**: `001-flutter-basics-app` | **Ngày tạo**: 2026-03-12 | **Nền tảng**: Android 6.0+ / iOS 13+

---

## Tính năng (User Stories)

| # | Màn hình | Mô tả | Độ ưu tiên |
|---|----------|-------|------------|
| US1 | Splash & Onboarding | Splash animation (fade-in + scale), tutorial 3 trang, lưu trạng thái bằng SharedPreferences | P1 🎯 MVP |
| US2 | Home — Khám phá âm nhạc | Danh sách New Releases từ Spotify API, loading/error/data states | P2 |
| US3 | Detail — Chi tiết album | Danh sách track, thời lượng, lưu/xóa yêu thích (Sqflite) | P3 |
| US4 | Favorites — Ngoại tuyến | Danh sách album đã lưu, hoạt động offline, vuốt để xóa | P4 |
| US5 | Settings — Cài đặt | Chuyển ngôn ngữ EN/VI ngay lập tức, lưu qua lần khởi động | P5 |
| US6 | Search — Tìm kiếm | Thanh tìm kiếm có animation mở rộng, kết quả fade-in từng item | P6 |

---

## Tech Stack

| Thành phần | Thư viện / Công nghệ |
|------------|----------------------|
| Ngôn ngữ | Dart 3.x |
| Framework | Flutter 3.x (stable) |
| State Management | `provider` ^6.1.0 (ChangeNotifier) |
| Navigation | `go_router` ^14.8.0 (ShellRoute + redirect guard) |
| Networking | `http` ^1.3.0 |
| Local DB | `sqflite` ^2.4.0 + `path` |
| Key-Value Storage | `shared_preferences` ^2.5.0 |
| Image Cache | `cached_network_image` ^3.4.0 |
| Internationalization | `flutter_localizations` + `intl` (EN / VI) |
| Linting | `flutter_lints` ^6.0.0 (zero-warning policy) |
| Testing | `mockito` ^5.4.0 + `build_runner` ^2.4.0 |
| API | Spotify Web API (Client Credentials flow) |

---

## Kiến trúc

```
Presentation  →  Provider  →  Data
  lib/ui/          lib/providers/      lib/data/
                               ├── repositories/
                               ├── sources/
                               └── database/
```

- **Presentation** (`lib/ui/`): StatelessWidget / StatefulWidget. `build()` thuần túy. Không import data layer trực tiếp.
- **Provider** (`lib/providers/`): ChangeNotifier per feature. Quản lý trạng thái loading / data / error.
- **Data** (`lib/data/`): Repository pattern che giấu nguồn dữ liệu (API, Sqflite, SharedPreferences).

---

## Cài đặt & Chạy ứng dụng

### Yêu cầu

- Flutter SDK 3.x (stable channel) — kiểm tra bằng `flutter --version`
- Dart SDK 3.x (đi kèm với Flutter)
- Android Studio hoặc Xcode (cho emulator/simulator)
- Tài khoản [Spotify Developer](https://developer.spotify.com/dashboard) để lấy `client_id` và `client_secret`

### 1. Clone và checkout branch

```bash
git clone <repo-url>
cd example_flutter
git checkout 001-flutter-basics-app
```

### 2. Cài đặt dependencies

```bash
flutter pub get
```

### 3. Cấu hình Spotify API

Tạo file `.env` tại thư mục gốc (đã được thêm vào `.gitignore`):

```
SPOTIFY_CLIENT_ID=your_client_id_here
SPOTIFY_CLIENT_SECRET=your_client_secret_here
```

Hoặc truyền trực tiếp khi chạy:

```bash
flutter run \
  --dart-define=SPOTIFY_CLIENT_ID=your_client_id \
  --dart-define=SPOTIFY_CLIENT_SECRET=your_client_secret
```

### 4. Sinh file localization

```bash
flutter gen-l10n
```

### 5. Chạy ứng dụng

```bash
# Android emulator
flutter run --dart-define=SPOTIFY_CLIENT_ID=xxx --dart-define=SPOTIFY_CLIENT_SECRET=yyy

# iOS simulator
flutter run -d iphone --dart-define=SPOTIFY_CLIENT_ID=xxx --dart-define=SPOTIFY_CLIENT_SECRET=yyy

# Xem danh sách thiết bị
flutter devices
```

---

## Cấu trúc thư mục

```
lib/
├── main.dart                   # Entry point — khởi tạo DI và runApp
├── app.dart                    # MaterialApp.router + l10n + theme
├── config/
│   └── app_config.dart         # Spotify API URLs, hằng số (từ --dart-define)
├── l10n/
│   ├── app_en.arb              # Chuỗi tiếng Anh
│   └── app_vi.arb              # Chuỗi tiếng Việt
├── models/
│   ├── album.dart              # Album.fromJson / toJson
│   ├── track.dart              # Track.fromJson / toJson
│   └── favorite.dart           # Favorite.fromMap / toMap / fromAlbum
├── data/
│   ├── database/
│   │   └── database_helper.dart        # Sqflite init + migration v1
│   ├── sources/
│   │   ├── spotify_remote_source.dart  # HTTP calls + auto-refresh token
│   │   ├── favorites_local_source.dart # Sqflite CRUD
│   │   └── preferences_local_source.dart # SharedPreferences wrapper
│   └── repositories/
│       ├── music_repository.dart       # Abstraction cho Spotify source
│       ├── favorites_repository.dart   # Abstraction cho favorites
│       └── settings_repository.dart    # Abstraction cho preferences
├── providers/
│   ├── onboarding_provider.dart  # Trạng thái onboarding
│   ├── settings_provider.dart    # Locale (ngôn ngữ)
│   ├── home_provider.dart        # New releases
│   ├── detail_provider.dart      # Album tracks + favorite toggle
│   ├── favorites_provider.dart   # Danh sách yêu thích
│   └── search_provider.dart      # Kết quả tìm kiếm
├── routes/
│   ├── route_names.dart          # Hằng số đường dẫn
│   └── app_router.dart           # GoRouter config + redirect guard
├── ui/
│   ├── splash/
│   │   └── splash_screen.dart        # AnimatedOpacity + AnimatedScale
│   ├── onboarding/
│   │   ├── onboarding_screen.dart    # PageView 3 trang + dots
│   │   └── onboarding_page.dart      # Widget 1 trang tutorial
│   ├── home/
│   │   ├── home_screen.dart          # Consumer<HomeProvider>
│   │   └── album_card.dart           # CachedNetworkImage card
│   ├── detail/
│   │   ├── detail_screen.dart        # Album info + track list + FAB
│   │   └── track_list_tile.dart      # Track row với thời lượng mm:ss
│   ├── favorites/
│   │   └── favorites_screen.dart     # Dismissible list (offline)
│   ├── search/
│   │   ├── search_screen.dart        # AnimatedContainer + stagger fade
│   │   └── search_result_tile.dart   # Kết quả tìm kiếm item
│   ├── settings/
│   │   └── settings_screen.dart      # Chọn ngôn ngữ EN/VI
│   └── widgets/
│       ├── bottom_nav_shell.dart     # StatefulShellRoute wrapper
│       ├── loading_view.dart         # CircularProgressIndicator
│       └── error_view.dart           # Error message + Retry button
└── utils/
    └── api_exception.dart            # Custom exception (statusCode, message)
```

---

## Luồng điều hướng

```
Launch → Splash (2 giây, fade-in + scale)
  ├── Lần đầu dùng → Onboarding (3 trang) → Home
  └── Đã dùng rồi  → Home (bỏ qua onboarding)

Home [tab 0]
  ├── Tap album → Detail (tracks + save favorite)
  └── Tap search icon → Search (animated + fade results)

Favorites [tab 1]
  ├── Album đã lưu (hoạt động offline)
  └── Swipe trái → xóa

Settings [tab 2]
  └── Chọn ngôn ngữ: English / Tiếng Việt
```

---

## Các lệnh thường dùng

| Lệnh | Mục đích |
|------|----------|
| `flutter pub get` | Cài / cập nhật dependencies |
| `flutter gen-l10n` | Tạo lại code localization từ .arb |
| `flutter analyze` | Kiểm tra lint (phải đạt zero warnings) |
| `dart format lib/` | Format toàn bộ code Dart |
| `flutter test` | Chạy tất cả unit + widget tests |
| `flutter build apk --debug` | Build Android debug APK |
| `flutter build ios --debug --no-codesign` | Build iOS debug |

---

## Tiến độ thực hiện

| Phase | Nội dung | Trạng thái |
|-------|----------|-----------|
| Phase 1 | Setup: project, pubspec, lint, l10n, config | ✅ Hoàn thành |
| Phase 2 | Foundation: models, data sources, repositories, widgets, l10n ARBs | ✅ Hoàn thành |
| Phase 3 | US1: Splash + Onboarding + GoRouter + main.dart | ✅ Hoàn thành |
| Phase 4 | US2: Home screen + HomeProvider + AlbumCard | 🔄 Đang làm |
| Phase 5 | US3: Detail screen + tracks + favorite toggle | ⏳ Chờ |
| Phase 6 | US4: Favorites screen + offline | ⏳ Chờ |
| Phase 7 | US5: Settings + language switching | ⏳ Chờ |
| Phase 8 | US6: Search + animations | ⏳ Chờ |
| Phase 9 | Polish: format, analyze, build validation | ⏳ Chờ |

---

## Tài liệu kỹ thuật

Xem thêm trong thư mục `specs/001-flutter-basics-app/`:

- [`spec.md`](specs/001-flutter-basics-app/spec.md) — User stories và acceptance criteria
- [`plan.md`](specs/001-flutter-basics-app/plan.md) — Kế hoạch kỹ thuật & kiến trúc
- [`data-model.md`](specs/001-flutter-basics-app/data-model.md) — Mô hình dữ liệu (Album, Track, Favorite, UserPreference)
- [`contracts/spotify-api.md`](specs/001-flutter-basics-app/contracts/spotify-api.md) — Spotify API endpoints & response schemas
- [`quickstart.md`](specs/001-flutter-basics-app/quickstart.md) — Hướng dẫn cài đặt chi tiết
- [`tasks.md`](specs/001-flutter-basics-app/tasks.md) — Danh sách 62 tasks theo phase
