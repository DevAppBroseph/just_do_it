import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:scale_button/scale_button.dart';

class ContractorProfile extends StatefulWidget {
  @override
  State<ContractorProfile> createState() => _ContractorProfileState();
}

class _ContractorProfileState extends State<ContractorProfile> {
  FocusNode focusNode = FocusNode();
  TextEditingController experienceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('object ${MediaQuery.of(context).viewInsets}');
    UserRegModel? user = BlocProvider.of<ProfileBloc>(context).user;
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                  size: Size.fromRadius(30.r),
                  child: user!.photoLink == null
                      ? Container(
                          height: 60.h,
                          width: 60.h,
                          decoration: const BoxDecoration(
                              color: ColorStyles.shadowFC6554),
                        )
                      : Image.network(
                          BlocProvider.of<ProfileBloc>(context)
                              .user!
                              .photoLink!,
                          fit: BoxFit.cover,
                        ),
                ),
              )
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Marvin McKinney',
                style: CustomTextStyle.black_24_w800_171716,
              ),
              SizedBox(width: 5.w),
              SvgPicture.asset('assets/icons/share.svg'),
            ],
          ),
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Expanded(
                  child: ScaleButton(
                    bound: 0.02,
                    child: Container(
                      height: 68.h,
                      padding: EdgeInsets.only(left: 16.w),
                      decoration: BoxDecoration(
                        color: ColorStyles.greyF9F9F9,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ваш рейтинг',
                              style: CustomTextStyle.black_10_w500_515150),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/star.svg'),
                              SizedBox(width: 4.w),
                              Text(
                                '5',
                                style: CustomTextStyle.black_18_w700_171716,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 21.w),
                Expanded(
                  child: ScaleButton(
                    bound: 0.02,
                    child: Container(
                      height: 68.h,
                      padding: EdgeInsets.only(left: 16.w),
                      decoration: BoxDecoration(
                        color: ColorStyles.greyF9F9F9,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ваши баллы',
                                style: CustomTextStyle.black_10_w500_515150,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Text(
                                    '900',
                                    style: CustomTextStyle.purple_18_w700,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/america.png',
                            height: 42.h,
                          ),
                          SizedBox(width: 16.w),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Общие настройки профиля',
              style: CustomTextStyle.grey_12_w400,
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ScaleButton(
              bound: 0.02,
              child: Container(
                height: 68.h,
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                decoration: BoxDecoration(
                  color: ColorStyles.greyF9F9F9,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/user-square.png',
                      height: 23.h,
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Основная информация',
                          style: CustomTextStyle.grey_10_w400,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Имя, Телефон и E-mail',
                          style: CustomTextStyle.black_12_w400_171716,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: ColorStyles.greyBDBDBD,
                      size: 16.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ScaleButton(
              bound: 0.02,
              child: Container(
                height: 68.h,
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                decoration: BoxDecoration(
                  color: ColorStyles.greyF9F9F9,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/shield-tick.png',
                      height: 23.h,
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Безопасность',
                          style: CustomTextStyle.grey_10_w400,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Пароль, паспортные данные, регион',
                          style: CustomTextStyle.black_12_w400_171716,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: ColorStyles.greyBDBDBD,
                      size: 16.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Stack(
              children: [
                ScaleButton(
                  duration: const Duration(milliseconds: 50),
                  bound: 0.01,
                  // onTap: _selectCV,
                  child: Container(
                    height: 40.h,
                    width: 154.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 11.h),
                    decoration: BoxDecoration(
                      color: ColorStyles.greyF9F9F9,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 14.h,
                          width: 14.h,
                          child: SvgPicture.asset(SvgImg.documentText),
                        ),
                        SizedBox(width: 9.17.w),
                        Text(
                          'Загрузить резюме (10мб)',
                          style: CustomTextStyle.black_10_w400,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Text(
                  'Ваши категории',
                  style: CustomTextStyle.grey_12_w400,
                ),
                const Spacer(),
                Text(
                  'Изменить',
                  style: CustomTextStyle.blue_12_w400_336FEE,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Вы не выбрали ни одной категории',
              style: CustomTextStyle.black_12_w400_515150,
            ),
          ),
          SizedBox(height: 50.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Описание вашего опыта',
              style: CustomTextStyle.grey_12_w400,
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              height: 170.h,
              width: 327.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: ColorStyles.whiteFFFFFF,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 45.r,
                    color: ColorStyles.shadowFC6554,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: Column(
                  children: [
                    SizedBox(
                      height: 99.h,
                      // child: CustomTextField(
                      //   textEditingController: experienceController,
                      //   hintText:
                      //       "Опишите свой опыт работы и прикрерите изображения",
                      //   focusNode: focusNode,
                      //   hintStyle: CustomTextStyle.black_12_w400_515150,
                      //   style: CustomTextStyle.black_12_w400_515150,
                      //   maxLines: null,
                      // ),
                      child: TextFormField(
                        focusNode: focusNode,
                        decoration: InputDecoration.collapsed(
                          hintText:
                              "Опишите свой опыт работы и прикрерите изображения",
                          border: InputBorder.none,
                          hintStyle: CustomTextStyle.black_12_w400_515150,
                        ),
                        controller: TextEditingController(),
                        style: CustomTextStyle.black_12_w400_515150,
                        maxLines: null,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '0/250',
                          style: CustomTextStyle.grey_10_w400,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Stack(
              children: [
                ScaleButton(
                  bound: 0.02,
                  child: Container(
                    height: 36.h,
                    width: 102.w,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: ColorStyles.greyF9F9F9,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 14.h,
                          width: 14.h,
                          child: SvgPicture.asset(SvgImg.addCircle),
                        ),
                        SizedBox(width: 9.17.w),
                        Text(
                          'Изображения',
                          style: CustomTextStyle.black_10_w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 133.h + MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
