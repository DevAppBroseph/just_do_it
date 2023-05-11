import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/services/firebase_dynamic_links/firebase_dynamic_links_service.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialMedia { whatsup, instagram, facebook, telegram }

class ReferalPage extends StatefulWidget {
  const ReferalPage({super.key});

  @override
  State<ReferalPage> createState() => _ReferalPageState();
}

class _ReferalPageState extends State<ReferalPage> {
  Future share(SocialMedia socialplatform) async {
    const text = 'Ваша реферальная ссылка';
    final urlShare = Uri.encodeComponent('${user?.link}');
    final urls = {
      SocialMedia.facebook:
          'https://www.facebook.com/sharer/sharer.php?t=$text&u=$urlShare',
      SocialMedia.instagram:
          'https://www.instagram.com/sharer.php?t=$text&u=$urlShare',
    };
    final url = urls[socialplatform]!;
    await launch(url);
  }

  late UserRegModel? user;

  @override
  void initState() {
    user = BlocProvider.of<ProfileBloc>(context).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80.h),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 28.w),
              child: SizedBox(
                height: 35.h,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    CustomIconButton(
                      onBackPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: SvgImg.arrowRight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Реферальная система',
                          style: CustomTextStyle.black_22_w700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Это Ваша реферальная ссылка',
                style: CustomTextStyle.black_16_w500_000000,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'За каждого нового пользователя, кто установит приложение по Вашей ссылке, Вы получите от 100 баллов.',
                style: CustomTextStyle.black_14_w400_515150,
              ),
            ),
            SizedBox(height: 50.h),
            Container(
              height: 130.h,
              decoration: BoxDecoration(
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Установите приложение JOBYFINE и получите\nдополнительно 200 баллов на свой счет!',
                    style: CustomTextStyle.black_14_w400_515150,
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ScaleButton(
                duration: const Duration(milliseconds: 50),
                bound: 0.01,
                onTap: () async {
                  String code = '';
                  for (int i = 0; i < user!.link!.length; i++) {
                    if (RegExp(r'[0-9]').hasMatch(user!.link![i])) {
                      code += user!.link![i];
                    }
                  }

                  final res = await FirebaseDynamicLinksService()
                      .share(int.parse(code));
                  Clipboard.setData(ClipboardData(text: 'JobyFine - Приложение для поиска и выполнения работы\n $res'));

                  const snackBar = SnackBar(
                    backgroundColor: ColorStyles.yellowFFCA0D,
                    content: Text('Скопировано'),
                    duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Container(
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: ColorStyles.purpleA401C4,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Text(
                          user?.link ?? '-',
                          style: CustomTextStyle.white_16_w600,
                        ),
                        const Spacer(),
                        SvgPicture.asset('assets/icons/copy.svg')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ScaleButton(
                onTap: () async {
                  String code = '';
                  for (int i = 0; i < user!.link!.length; i++) {
                    if (RegExp(r'[0-9]').hasMatch(user!.link![i])) {
                      code += user!.link![i];
                    }
                  }

                  final res = await FirebaseDynamicLinksService()
                      .share(int.parse(code));
                  if (res != null) Share.share('JobyFine - Приложение для поиска и выполнения работы\n $res');
                },
                child: Container(
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: ColorStyles.yellowFFCA0D,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Поделиться',
                          style: CustomTextStyle.white_16_w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
