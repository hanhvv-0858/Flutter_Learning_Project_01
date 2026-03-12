// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Khám Phá Âm Nhạc';

  @override
  String get splashLoading => 'Đang tải...';

  @override
  String get onboardingTitle1 => 'Khám Phá Âm Nhạc';

  @override
  String get onboardingDesc1 =>
      'Duyệt qua các album mới phát hành từ khắp nơi trên thế giới.';

  @override
  String get onboardingTitle2 => 'Tìm Kiếm & Khám Phá';

  @override
  String get onboardingDesc2 =>
      'Tìm album yêu thích của bạn và khám phá chi tiết bài hát.';

  @override
  String get onboardingTitle3 => 'Lưu Yêu Thích';

  @override
  String get onboardingDesc3 =>
      'Lưu album vào danh sách yêu thích để truy cập ngoại tuyến nhanh chóng.';

  @override
  String get onboardingNext => 'Tiếp';

  @override
  String get onboardingGetStarted => 'Bắt Đầu';

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get homeTitle => 'Album Mới';

  @override
  String get detailTitle => 'Chi Tiết Album';

  @override
  String get detailTracks => 'Danh sách bài hát';

  @override
  String detailReleaseDate(String date) {
    return 'Phát hành: $date';
  }

  @override
  String get detailSaveToFavorites => 'Lưu vào Yêu thích';

  @override
  String get detailRemoveFromFavorites => 'Xóa khỏi Yêu thích';

  @override
  String get detailSaved => 'Đã lưu vào yêu thích!';

  @override
  String get detailRemoved => 'Đã xóa khỏi yêu thích.';

  @override
  String get favoritesTitle => 'Yêu Thích';

  @override
  String get favoritesEmpty =>
      'Chưa có mục yêu thích. Lưu album từ màn hình chi tiết!';

  @override
  String get favoritesSwipeHint => 'Vuốt để xóa';

  @override
  String get settingsTitle => 'Cài Đặt';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsEnglish => 'English';

  @override
  String get settingsVietnamese => 'Tiếng Việt';

  @override
  String get searchTitle => 'Tìm Kiếm Album';

  @override
  String get searchHint => 'Tìm kiếm album...';

  @override
  String get searchNoResults => 'Không tìm thấy kết quả.';

  @override
  String get errorGeneric => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get errorNetwork =>
      'Không có kết nối mạng. Vui lòng kiểm tra mạng của bạn.';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navFavorites => 'Yêu thích';

  @override
  String get navSettings => 'Cài đặt';
}
