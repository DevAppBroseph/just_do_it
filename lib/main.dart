import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/currency_bloc/currency_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/notification/notifications_bloc/notifications_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/score/bloc_score/score_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply/reply_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply_from_favourite/reply_fav_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response/response_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response_from_favourite/response_fav_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/theme/app_theme.dart';
import 'package:just_do_it/feature/theme/settings_bloc.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:just_do_it/feature/theme/theme_data_source.dart';
import 'package:just_do_it/feature/theme/theme_repository.dart';
import 'package:just_do_it/firebaseApi.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/services/get_it/get_it_initializer.dart';
import 'package:just_do_it/services/language/main_config_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await EasyLocalization.ensureInitialized();

  try {
    await Firebase.initializeApp();

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseApi().initNotifications();
  } catch (e) {
    // Handle error
  }
  //String? token = await FirebaseMessaging.instance.getToken();

  await getItSetup();

  final themeRepository = ThemeRepositoryImpl(
    themeDataSource: ThemeDataSourceLocal(
      sharedPreferences: await SharedPreferences.getInstance(),
      codec: const ThemeModeCodec(),
    ),
  );
  final initialTheme =
      await themeRepository.getTheme() ?? AppTheme.defaultTheme;

  runApp(
    EasyLocalization(
      supportedLocales: MainConfigApp.languages
          .map((e) => Locale(e.langCode, e.langCountryCode))
          .toList(),
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      child: SettingsScope(
        settingsBloc: SettingsBloc(
          themeRepository: themeRepository,
          initialState: IdleSettingsState(appTheme: initialTheme),
        ),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context).theme;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<FavouritesBloc>(create: (context) => FavouritesBloc()),
            BlocProvider<NotificationsBloc>(
                create: (context) => NotificationsBloc()),
            BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
            BlocProvider<ReplyBloc>(create: (context) => ReplyBloc()),
            BlocProvider<ReplyFromFavBloc>(
                create: (context) => ReplyFromFavBloc()),
            BlocProvider<ResponseBloc>(create: (context) => ResponseBloc()),
            BlocProvider<ResponseBlocFromFav>(
                create: (context) => ResponseBlocFromFav()),
            BlocProvider<CountriesBloc>(create: (context) => CountriesBloc()),
            BlocProvider<CurrencyBloc>(create: (context) => CurrencyBloc()),
            BlocProvider<TasksBloc>(create: (context) => TasksBloc()),
            BlocProvider<ScoreBloc>(create: (context) => ScoreBloc()),
            BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
            BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
            BlocProvider<RatingBloc>(create: (context) => RatingBloc()),
            BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
          ],
          child: GestureDetector(
            onTap: () {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              themeMode: theme.mode,
              theme: theme.lightTheme,
              darkTheme: theme.darkTheme,
              builder: FlutterSmartDialog.init(),
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoute.home,
              onGenerateRoute: AppRoute.onGenerateRoute,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            ),
          ),
        );
      },
    );
  }
}
