import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:scale_button/scale_button.dart';
import 'package:url_launcher/url_launcher.dart';


enum SocialMedia{facebook, instagram, tiktok, email}

class ReferalPage extends StatelessWidget {
  const ReferalPage({super.key});

 Future share(SocialMedia socialplatform) async{
  const text = 'Ваша реферальная ссылка';
  final urls = {
    SocialMedia.facebook: 'https://www.facebook.com/sharer/sharer.php?t=$text',
    SocialMedia.instagram:'https://www.instagram.com/sharer.php?t=$text',
    SocialMedia.tiktok:'https://www.tiktok.com/sharer.php?t=$text',
    SocialMedia.email:'mailto:?body=$text',
  };
  final url = urls[socialplatform]!;
  final uri = Uri.parse(url);
  if(await canLaunchUrl(uri)){
    await launchUrl(uri);
  }
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
            SizedBox(height: 66.h),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 28.w),
              child: SizedBox(
                height: 24.h,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Transform.rotate(
                          angle: pi,
                          child:
                              SvgPicture.asset('assets/icons/arrow_right.svg')),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Реферальная система',
                          style: CustomTextStyle.black_21_w700,
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
                'Это ваша реферальная ссылка',
                style: CustomTextStyle.black_15_w500_000000,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'За каждого нового пользователя, кто установит приложение\nпо вашей ссылке, Вы получите от 100 баллов.',
                style: CustomTextStyle.black_13_w400_515150,
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
                    style: CustomTextStyle.black_13_w400_515150,
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
                onTap: () {},
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
                          'www.link//32xs2cw',
                          style: CustomTextStyle.white_15_w600,
                        ),
                        const Spacer(),
                        SvgPicture.asset('assets/icons/copy.svg')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 52.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 1.h,
                        color: ColorStyles.greyF3F3F3,
                      )),
                      SizedBox(width: 24.w),
                      Text(
                        'Поделиться',
                        style: CustomTextStyle.grey_13_w400,
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                          child: Container(
                        height: 1.h,
                        color: ColorStyles.greyF3F3F3,
                      )),
                    ],
                  ),
                  SizedBox(height: 17.h),
                  SizedBox(
                    height: 54.h,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: (){
                            share(SocialMedia.email);
                          },
                          child: Container(
                            height: 54.h,
                            width: 54.h,
                            padding: EdgeInsets.all(15.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: ColorStyles.greyF9F9F9,
                            ),
                            child: SvgPicture.asset('assets/icons/russia.svg'),
                          ),
                        ),
                        SizedBox(width: 8.h),
                        GestureDetector(
                          onTap: (){
                            share(SocialMedia.instagram);
                          },
                          child: Container(
                            height: 54.h,
                            width: 54.h,
                            padding: EdgeInsets.all(15.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: ColorStyles.greyF9F9F9,
                            ),
                            child: SvgPicture.asset('assets/icons/russia.svg'),
                          ),
                        ),
                        SizedBox(width: 8.h),
                        GestureDetector(
                          onTap: (){
                            share(SocialMedia.facebook);
                          },
                          child: Container(
                            height: 54.h,
                            width: 54.h,
                            padding: EdgeInsets.all(15.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: ColorStyles.greyF9F9F9,
                            ),
                            child: SvgPicture.asset('assets/icons/russia.svg'),
                          ),
                        ),
                        SizedBox(width: 8.h),
                        GestureDetector(
                          onTap: (){
                            share(SocialMedia.tiktok);
                          },
                          child: Container(
                            height: 54.h,
                            width: 54.h,
                            padding: EdgeInsets.all(15.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: ColorStyles.greyF9F9F9,
                            ),
                            child: SvgPicture.asset('assets/icons/russia.svg'),
                          ),
                        ),
                        SizedBox(width: 8.h),
                        Container(
                          height: 54.h,
                          width: 54.h,
                          padding: EdgeInsets.all(15.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: ColorStyles.greyF9F9F9,
                          ),
                          child: SvgPicture.asset('assets/icons/russia.svg'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
