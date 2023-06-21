import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/models/notification.dart' as notifModel;
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';

class NotificationPage extends StatelessWidget {
  List<notifModel.Notification> notification = [
    notifModel.Notification(
        title: 'Вас выбрали исполнителем', date: '12.09.2022'),
    notifModel.Notification(title: 'У Вас новый отклик', date: '22.02.2022'),
    notifModel.Notification(title: 'У Вас новый отклик', date: '14:32'),
  ];

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ListView.builder(
                  itemCount: notification.length,
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
                              Text(
                                notification[index].title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyle.black_14_w400_171716,
                              ),
                              const Spacer(),
                              Text(
                                notification[index].date,
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
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  onTap: () {},
                  btnColor: ColorStyles.greyE0E6EE,
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
}
