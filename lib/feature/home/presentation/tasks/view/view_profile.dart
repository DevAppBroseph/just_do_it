import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widget_position.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/network/repository.dart';

class ProfileView extends StatefulWidget {
  Owner owner;
  ProfileView({super.key, required this.owner});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Owner? owner;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(GetCategoriesEvent());
    super.initState();
    getProfile();
  }

  void getProfile() async {
    String? accessToken = await Storage().getAccessToken();
    owner = await Repository().getRanking(accessToken!, widget.owner);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 90.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (owner?.photo != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(1000.r),
                            child: Image.network(
                              owner?.photo ?? '',
                              height: 76.h,
                              width: 76.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(width: 17.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${owner?.firstname ?? ''} ${owner?.lastname ?? ''}',
                                style: CustomTextStyle.black_17_w600_171716,
                                softWrap: true,
                              ),
                              const Spacer(),
                              Text(
                                'Рейтинг',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                              SizedBox(height: 9.h),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/star.svg'),
                                  SizedBox(width: 4.w),
                                  Text(
                                    owner?.ranking ?? '-',
                                    style: CustomTextStyle.black_13_w500_171716,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => taskMoreDialogForProfile(
                            context,
                            getWidgetPosition(globalKey),
                            (index) {},
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/more-circle.svg',
                            key: globalKey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Container(
                        height: 36.h,
                        width: 75.w,
                        decoration: BoxDecoration(
                          color: ColorStyles.greyF9F9F9,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/document_text.svg',
                              color: ColorStyles.blue336FEE,
                            ),
                            Text(
                              'Резюме',
                              style:
                                  CustomTextStyle.black_11_w400_171716.copyWith(
                                color: ColorStyles.blue336FEE,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        height: 36.h,
                        width: 181.w,
                        decoration: BoxDecoration(
                          color: ColorStyles.greyF9F9F9,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset('assets/icons/clipboard.svg'),
                            Text(
                              'Паспортные данные загружены',
                              style: CustomTextStyle.black_11_w400_171716,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Text(
                        'Создано заданий:',
                        style: CustomTextStyle.black_12_w400_292D32,
                      ),
                      Text(
                        ' 40',
                        style: CustomTextStyle.black_13_w500_171716,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        'Выполнено заданий:',
                        style: CustomTextStyle.black_12_w400_292D32,
                      ),
                      Text(
                        ' 40',
                        style: CustomTextStyle.black_13_w500_171716,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    height: 70.h,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: Container(
                            height: 70.h,
                            width: 105.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEACB),
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorStyles.shadowFC6554,
                                  offset: const Offset(0, 4),
                                  blurRadius: 45.r,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.h, vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/build.png',
                                    height: 24.h,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Ремонт и строительство',
                                    style: CustomTextStyle.black_11_w400_171716,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: Container(
                            height: 70.h,
                            width: 105.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE0ED),
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorStyles.shadowFC6554,
                                  offset: const Offset(0, 4),
                                  blurRadius: 45.r,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.h, vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/soap.png',
                                    height: 24.h,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Красота\nи здоровье',
                                    style: CustomTextStyle.black_11_w400_171716,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: Container(
                            height: 70.h,
                            width: 105.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD5F7FE),
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorStyles.shadowFC6554,
                                  offset: const Offset(0, 4),
                                  blurRadius: 45.r,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.h, vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/book.png',
                                    height: 24.h,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Репетиторы\nи обучение',
                                    style: CustomTextStyle.black_11_w400_171716,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    'Опыт работы',
                    style: CustomTextStyle.grey_14_w400,
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorStyles.whiteFFFFFF,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorStyles.shadowFC6554,
                          offset: const Offset(0, 4),
                          blurRadius: 45.r,
                        )
                      ],
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      children: [
                        Text(
                          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
                          style: CustomTextStyle.black_12_w400_292D32,
                        ),
                        if (owner != null && owner!.listPhoto.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 18.h),
                            child: SizedBox(
                              height: 66.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: owner!.listPhoto.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: CachedNetworkImage(
                                        imageUrl: owner!.listPhoto[index],
                                        height: 66.h,
                                        width: 66.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        SizedBox(height: 18.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 229.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 36.h,
                                  decoration: BoxDecoration(
                                    color: ColorStyles.whiteF5F5F5,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.h),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/translate.svg'),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Перевод',
                                          style: CustomTextStyle
                                              .blue_14_w400_336FEE,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
