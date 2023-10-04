import 'package:flutter/material.dart';
import 'package:just_do_it/feature/auth/view/auth_page.dart';
import 'package:just_do_it/feature/auth/view/confirm_phone_code.dart';
import 'package:just_do_it/feature/auth/view/confirm_phone_register.dart';
import 'package:just_do_it/feature/auth/view/sign_up.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/personal_chat.dart';
import 'package:just_do_it/feature/home/presentation/home_page.dart';
import 'package:just_do_it/feature/home/presentation/menu/about_project.dart';
import 'package:just_do_it/feature/home/presentation/menu/contact_us.dart';
import 'package:just_do_it/feature/home/presentation/menu/menu.dart';
import 'package:just_do_it/feature/home/presentation/menu/referal_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/notification/notification.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/personal_account/personal_account.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/profile/edit_basic_info.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/profile/edit_identity_info.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/profile/profile_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/rating_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/score/score_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/all_tasks/view/all_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/archive_tasks/view/archive_view.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/tasks_page.dart';

class AppRoute {
  static const home = '/';
  static const auth = '/auth';
  static const signUp = '/signUp';
  static const confirmPhoneCode = '/confirmPhoneCode';
  static const confirmCodeRegister = '/confirmCodeRegister';
  static const forgotPassword = '/forgotPassword';
  static const personalAccount = '/forgotPassword';
  static const profile = '/profile';
  static const editBasicInfo = '/profile/editBasicInfo';
  static const editIdentityInfo = '/profile/editIdentityInfo';
  static const rating = '/rating';
  static const personalChat = '/personalChat';
  static const notification = '/notification';
  static const menu = '/menu';
  static const referal = '/referal';
  static const contactus = '/contactus';
  static const about = '/about';
  static const score = '/score';
  static const tasks = '/tasks';
  static const allTasks = '/all_tasks';
  static const archiveTasks = '/archive_tasks';

  static Route<dynamic>? onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case allTasks:
        List<dynamic> arg = route.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => AllTasksView(asCustomer: arg[0]));
      case archiveTasks:
        List<dynamic> arg = route.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => ArchiveTasksView(asCustomer: arg[0]));
      case tasks:
        List<dynamic> arg = route.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (_) => TasksPage(
            onSelect: arg[0], customer: 0,
          ),
        );

      case contactus:
        List<String> arg = route.arguments as List<String>;
        return MaterialPageRoute(builder: (_) => ContactUs(name: arg[0], theme: arg[1],));
      case score:
        return MaterialPageRoute(builder: (_) => const ScorePage());
      case about:
        return MaterialPageRoute(builder: (_) => AboutProject());
      case menu:
        List<dynamic> arg = route.arguments as List<dynamic>;

        return MaterialPageRoute(
          builder: (_) => MenuPage(
            onBackPressed: arg[0],
            inTask: arg[1],
          ),
        );
      case referal:
        return MaterialPageRoute(builder: (_) => const ReferalPage());
      case notification:
        return MaterialPageRoute(builder: (_) => NotificationPage());
      case personalChat:
        List<dynamic> arg = route.arguments  as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => PersonalChat(arg[0], arg[1], arg[2], arg[3],categoryId:arg.length==5?arg[4]:null));
      case rating:
        return MaterialPageRoute(builder: (_) => const RatingPage());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case confirmPhoneCode:
        final list = route.arguments as List<dynamic>;
        String phone = list[0] as String;
        return MaterialPageRoute(
            builder: (_) => ConfirmCodePhonePage(phone: phone));
      case confirmCodeRegister:
        final list = route.arguments as List<dynamic>;
        String phone = list[0] as String;
        return MaterialPageRoute(
            builder: (_) => ConfirmCodeRegisterPage(phone: phone));
      case personalAccount:
        return MaterialPageRoute(builder: (_) => const PersonalAccountPage());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case editBasicInfo:
        return MaterialPageRoute(builder: (_) => const EditBasicInfo());
      case editIdentityInfo:
        return MaterialPageRoute(builder: (_) => const EditIdentityInfo());
      default:
        return null;
    }
  }
}
