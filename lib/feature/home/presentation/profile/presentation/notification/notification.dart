import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/notification/notifications_bloc/notifications_bloc.dart';
import 'package:just_do_it/models/notification.dart' as notifModel;
import 'package:just_do_it/models/notofications.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';

class NotificationPage extends StatelessWidget {
  List<notifModel.Notification> notification = [
    notifModel.Notification(title: 'Вас выбрали исполнителем', date: '12.09.2022'),
    notifModel.Notification(title: 'У Вас новый отклик', date: '22.02.2022'),
    notifModel.Notification(title: 'У Вас новый отклик', date: '14:32'),
  ];

  List<NotificationsOnDevice>? notifications;
  late UserRegModel? user;
  NotificationPage({super.key});
  bool proverka = true;
  @override
  Widget build(BuildContext context) {
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    BlocProvider.of<NotificationsBloc>(context).add(GetNotificationsEvent(access));
    user = BlocProvider.of<ProfileBloc>(context).user;
    BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    CustomIconButton(
                      onBackPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: SvgImg.arrowRight,
                    ),
                    const Spacer(),
                    Text(
                      'notifications'.tr(),
                      style: CustomTextStyle.black_22_w700,
                    ),
                    const Spacer(),
                    SizedBox(width: 12.w)
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              BlocBuilder<NotificationsBloc, NotificationsState>(builder: (context, state) {
                if (state is NotificationsLoaded) {
                  notifications = state.notifications;
                  log(notifications.toString());
                  if (notifications == []) {
                    proverka = true;
                  } else {
                    proverka = false;
                  }
                  
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: ListView.builder(
                      itemCount: notifications?.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return ScaleButton(
                          bound: 0.01,
                          duration: const Duration(milliseconds: 200),
                          child: Column(
                            children: [
                              SizedBox(height: 18.h),
                              Row(
                                children: [
                                  const Icon(Icons.format_overline_sharp),
                                  SizedBox(width: 32.h),
                                  SizedBox(
                                    width: 190.w,
                                    child: Text(
                                      notifications?[index].text ?? '-',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: CustomTextStyle.black_14_w400_171716,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _textData(
                                        notifications?[index].dateTime?.toUtc().toString().substring(0, 10) ?? '-'),
                                    style: CustomTextStyle.grey_14_w400,
                                  ),
                                ],
                              ),
                              SizedBox(height: 21.h),
                              Container(
                                height: 1.h,
                                color: ColorStyles.greyF7F7F8,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              }),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  onTap: () {
                    BlocProvider.of<NotificationsBloc>(context).add(DeleteNotificationsEvent(access));
                  },
                  btnColor: proverka ? ColorStyles.greyE0E6EE : ColorStyles.yellowFFD70A,
                  textLabel: Text(
                    'clear'.tr(),
                    style: CustomTextStyle.black_16_w600_515150,
                  ),
                ),
              ),
              SizedBox(height: 52.h),
            ],
          ),
        ),
      ),
    );
  }

  String _textData(String data) {
    String text = '';
    String day = '';
    String month = '';
    String year = '';
    List<String> parts = [];
    parts = data.split('-');
    year = parts[0].trim();
    day = parts[2].trim();
    month = parts[1].trim();

    text = '$day.$month.$year';
    return text;
  }
}
