import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/helpers/router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
            BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoute.auth,
            onGenerateRoute: AppRoute.onGenerateRoute,
          ),
        );
      },
    );
  }
}
