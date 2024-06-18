import 'package:just_do_it/feature/theme/theme_data_source.dart';

import 'app_theme.dart';

abstract class ThemeRepository {
  Future<AppTheme?> getTheme();
  Future<void> setTheme(AppTheme theme);
}

final class ThemeRepositoryImpl implements ThemeRepository {
  const ThemeRepositoryImpl({required ThemeDataSource themeDataSource})
      : _themeDataSource = themeDataSource;

  final ThemeDataSource _themeDataSource;

  @override
  Future<AppTheme?> getTheme() => _themeDataSource.getTheme();

  @override
  Future<void> setTheme(AppTheme theme) => _themeDataSource.setTheme(theme);
}
