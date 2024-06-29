import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/widgets/chat_card.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class ChatOverviewPage extends StatefulWidget {
  final Function()? onBackPressed;
  final Function(int) onSelect;

  const ChatOverviewPage(this.onBackPressed, this.onSelect, {super.key});
  @override
  State<ChatOverviewPage> createState() => _ChatOverviewPageState();
}

class _ChatOverviewPageState extends State<ChatOverviewPage> {
  @override
  void initState() {
    super.initState();
    final access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor:
            SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                ? DarkAppColors.whitePrimary
                : LightAppColors.whitePrimary,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 66.h),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 28.w),
              child: Row(
                children: [
                  if (widget.onBackPressed != null)
                    CustomIconButton(
                      onBackPressed: widget.onBackPressed!,
                      icon: SvgImg.arrowRight,
                    ),
                  if (widget.onBackPressed != null) SizedBox(width: 15.w),
                  const Spacer(),
                  Text(
                    'message'.tr(),
                    style:
                        CustomTextStyle.sf22w700(LightAppColors.blackSecondary),
                  ),
                  const Spacer(),
                  SizedBox(width: 23.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoute.menu,
                          arguments: [(page) {}, false]).then((value) {
                        if (value != null) {
                          if (value == 'create') {
                            widget.onSelect(0);
                          }
                          if (value == 'search') {
                            widget.onSelect(1);
                          } else if (value == 'tasks') {
                            widget.onSelect(2);
                          }
                          if (value == 'chat') {
                            widget.onSelect(3);
                          }
                        }
                      });
                    },
                    child: SvgPicture.asset('assets/icons/category.svg'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) {
                  if (current is UpdateListMessageState) return true;
                  return false;
                },
                builder: (context, snapshot) {
                  List<ChatList> listChat =
                      BlocProvider.of<ChatBloc>(context).chatList;
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: listChat.length,
                    itemBuilder: ((context, index) {
                      return ChatCard(chat: listChat[index]);
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
