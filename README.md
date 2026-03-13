# Music Explorer 🎵

Ứng dụng mobile học Flutter, sử dụng **iTunes API** (miễn phí, không cần xác thực) để khám phá và lưu trữ album âm nhạc. Dự án được xây dựng theo kiến trúc 3 tầng (Presentation → Provider → Data), bao gồm đầy đủ các kỹ thuật Flutter cơ bản đến nâng cao.

**Nền tảng**: Android 6.0+ / iOS 13+

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
| API | iTunes RSS Feed + Search + Lookup API (free, no auth) |

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

> Ứng dụng sử dụng **iTunes API** — hoàn toàn miễn phí, **không cần API key hay tài khoản** nào.

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

### 3. Sinh file localization

```bash
flutter gen-l10n
```

### 4. Tạo lại mock cho tests (nếu cần)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Chạy ứng dụng

```bash
# Android emulator
flutter run

# iOS simulator
flutter run -d iphone

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
│   │   ├── itunes_remote_source.dart   # HTTP calls tới iTunes RSS/Search/Lookup
│   │   ├── favorites_local_source.dart # Sqflite CRUD
│   │   └── preferences_local_source.dart # SharedPreferences wrapper
│   └── repositories/
│       ├── music_repository.dart       # Abstraction cho iTunes source
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

## Unit Tests

73 tests — **0 failures** (`flutter test`).

```
test/
├── mocks.dart                          # @GenerateMocks annotations
├── mocks.mocks.dart                    # Auto-generated bởi build_runner
├── models/
│   ├── album_test.dart                 # fromItunesRss, fromItunesSearch, toJson, mặc định
│   ├── track_test.dart                 # fromItunesLookup, toJson, formattedDuration
│   └── favorite_test.dart              # fromAlbum, fromMap/toMap, toAlbum
├── utils/
│   └── api_exception_test.dart         # isUnauthorized/isForbidden/isRateLimited/isServerError
├── data/
│   ├── sources/
│   │   └── itunes_remote_source_test.dart  # Mock http.Client, 3 phương thức, ApiException
│   └── repositories/
│       ├── music_repository_test.dart      # Delegation sang ItunesRemoteSource
│       ├── favorites_repository_test.dart  # isFavorite bool, addFavorite, removeFavorite
│       └── settings_repository_test.dart   # Delegation sang PreferencesLocalSource
└── providers/
    ├── onboarding_provider_test.dart   # isCompleted, completeOnboarding
    ├── settings_provider_test.dart     # Locale khởi tạo, setLocale
    ├── home_provider_test.dart         # fetchNewReleases success/error/loading, retry
    ├── detail_provider_test.dart       # loadTracks, checkFavorite, toggleFavorite
    ├── favorites_provider_test.dart    # loadFavorites, removeFavorite
    └── search_provider_test.dart       # search/empty/error/trim/clear
```

Chạy toàn bộ tests:

```bash
flutter test
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
| `flutter test` | Chạy tất cả 73 unit tests |
| `flutter pub run build_runner build --delete-conflicting-outputs` | Tạo lại mock classes cho tests |
| `flutter build apk --debug` | Build Android debug APK |
| `flutter build ios --debug --no-codesign` | Build iOS debug |

## Screenshot apps
### Home
<img width="312" height="680" alt="Simulator Screenshot - iPhone 16e - 2026-03-13 at 00 17 30" src="https://github.com/user-attachments/assets/04a73596-80e9-4ac8-9145-5f4ba858f699" />

### Detail
<img width="312" height="680" alt="Simulator Screenshot - iPhone 16e - 2026-03-13 at 00 17 35" src="https://github.com/user-attachments/assets/b93580ec-aae6-4e9c-8274-d3c233a40451" />

### Favorite
<img width="312" height="680" alt="Simulator Screenshot - iPhone 16e - 2026-03-13 at 10 48 15" src="https://github.com/user-attachments/assets/6fe58cee-5905-49c7-8df3-185ff0284a2c" />

### Settings
<img width="312" height="680" alt="Simulator Screenshot - iPhone 16e - 2026-03-13 at 01 03 37" src="https://github.com/user-attachments/assets/cec561ca-34bb-455f-9fcf-9e50d6861b88" />
