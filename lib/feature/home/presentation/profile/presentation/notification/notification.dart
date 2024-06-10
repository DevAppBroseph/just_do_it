import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/notification/notifications_bloc/notifications_bloc.dart';
import 'package:just_do_it/models/notofications.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationsOnDevice>? notifications;

  late String? access = BlocProvider.of<ProfileBloc>(context).access;

  bool proverka = true;
  @override
  void initState() {
    BlocProvider.of<NotificationsBloc>(context)
        .add(GetNotificationsEvent(access, () {
      context.read<ProfileBloc>().add(GetProfileEvent());
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final user = context.read<ProfileBloc>().user;
            if (user == null) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return BlocBuilder<NotificationsBloc, NotificationsState>(
                builder: (context, state) {
              if (state is NotificationsLoaded) {
                notifications = state.notifications;
                if (notifications!.isEmpty) {
                  proverka = true;
                } else {
                  proverka = false;
                }
                return SafeArea(
                  child: Stack(
                    children: [
                      Column(
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
                          BlocBuilder<NotificationsBloc, NotificationsState>(
                              builder: (context, state) {
                            return Scrollbar(
                              thumbVisibility: true,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: SizedBox(
                                  height: 630.h,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 32.h),
                                    child: ListView.builder(
                                      itemCount: notifications?.length,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ScaleButton(
                                          bound: 0.01,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 18.h),
                                              Row(
                                                children: [
                                                  const Icon(Icons
                                                      .format_overline_sharp),
                                                  SizedBox(width: 32.h),
                                                  SizedBox(
                                                    width: 190.w,
                                                    child: Text(
                                                      user.rus!
                                                          ? notifications![
                                                                      index]
                                                                  .text ??
                                                              '-'
                                                          : notifications?[
                                                                      index]
                                                                  .engMessage ??
                                                              '-',
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: CustomTextStyle
                                                          .black14w400171716,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    _textData(
                                                        notifications?[index]
                                                                .dateTime
                                                                ?.toUtc()
                                                                .toString()
                                                                .substring(
                                                                    0, 10) ??
                                                            '-'),
                                                    style: CustomTextStyle
                                                        .grey14w400,
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
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 32.h),
                            child: CustomButton(
                              onTap: () {
                                BlocProvider.of<NotificationsBloc>(context)
                                    .add(DeleteNotificationsEvent(access, () {
                                  context
                                      .read<ProfileBloc>()
                                      .add(GetProfileEvent());
                                }));
                              },
                              btnColor: proverka
                                  ? ColorStyles.greyE0E6EE
                                  : ColorStyles.yellowFFD70A,
                              textLabel: Text(
                                'clear'.tr(),
                                style: CustomTextStyle.black16w600515150,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            });
          },
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
