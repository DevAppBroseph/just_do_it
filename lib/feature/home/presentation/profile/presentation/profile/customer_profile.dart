import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/score/bloc_score/score_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/services/firebase_dynamic_links/firebase_dynamic_links_service.dart';
import 'package:scale_button/scale_button.dart';
import 'package:share_plus/share_plus.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  Widget build(BuildContext context) {
    Reviews? reviews = BlocProvider.of<RatingBloc>(context).reviews;

    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, snapshot) {
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
                SizedBox(width: 25.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 70.h,
                          width: 70.h,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    BlocProvider.of<ProfileBloc>(context).add(
                                      UpdateProfilePhotoEvent(photo: image),
                                    );
                                  }
                                },
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                      size: Size.fromRadius(30.r),
                                      child: user!.photoLink == null
                                          ? Container(
                                              height: 60.h,
                                              width: 60.h,
                                              padding: EdgeInsets.all(10.h),
                                              decoration: const BoxDecoration(
                                                color: ColorStyles.shadowFC6554,
                                              ),
                                              child: Image.asset('assets/images/camera.png'),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: user.photoLink!.contains(server)
                                                  ? user.photoLink!
                                                  : server + user.photoLink!,
                                              fit: BoxFit.cover,
                                            )
                                      // : Image.network(
                                      //     BlocProvider.of<ProfileBloc>(context)
                                      //         .user!
                                      //         .photoLink!,
                                      //     fit: BoxFit.cover,
                                      //   ),
                                      ),
                                ),
                              ),
                              if (user.photoLink != null)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      user.photo = null;
                                      user.photoLink = null;
                                      BlocProvider.of<ProfileBloc>(context).setUser(user);
                                      BlocProvider.of<ProfileBloc>(context).add(
                                        UpdateProfilePhotoEvent(photo: null),
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20.h,
                                      width: 20.h,
                                      decoration: BoxDecoration(
                                        boxShadow: [BoxShadow(color: Colors.black)],
                                        borderRadius: BorderRadius.circular(100.r),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          size: 10.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      // width: 327.w,
                   
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                          
                            child: AutoSizeText(
                              '${user.firstname ?? ''} ${user.lastname ?? ''}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 33.sp, fontWeight: FontWeight.w800),
                              maxLines: 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final code =
                                  await FirebaseDynamicLinksService().shareUserProfile(int.parse(user.id.toString()));
                              Share.share(code.toString());
                            },
                            child: SvgPicture.asset(
                              'assets/icons/share.svg',
                              height: 25.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          color: ColorStyles.yellowFFD70A,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ваш рейтинг', style: CustomTextStyle.black_12_w500_515150),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/star.svg', color: ColorStyles.black),
                                SizedBox(width: 4.w),
                                Text(
                                  reviews?.ranking == null ? '-' : (reviews?.ranking!).toString(),
                                  style: CustomTextStyle.black_20_w700_171716,
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
                          color: ColorStyles.yellowFFD70A,
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
                                  style: CustomTextStyle.black_12_w500_515150,
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Text(
                                      user.balance.toString(),
                                      style: CustomTextStyle.purple_20_w700,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
                              if (state is ScoreLoaded) {
                                final levels = state.levels;
                                if (user.balance! < levels![0].mustCoins!) {
                                  return CachedNetworkImage(
                                    imageUrl: '${levels[0].bwImage}',
                                    height: 42,
                                    width: 42,
                                  );
                                }

                                if (user.balance! > levels[0].mustCoins! && user.balance! < levels[1].mustCoins!) {
                                  return Image.network(
                                    '${levels[0].image}',
                                    height: 42,
                                    width: 42,
                                  );
                                }
                                if (user.balance! >= levels[1].mustCoins! && user.balance! < levels[2].mustCoins!) {
                                  return Image.network(
                                    levels[1].image != null ? '${levels[1].image}' : '',
                                    height: 42,
                                    width: 42,
                                    fit: BoxFit.fill,
                                  );
                                }
                                if (user.balance! >= levels[2].mustCoins! && user.balance! < levels[3].mustCoins!) {
                                  return Image.network(
                                    levels[2].image != null ? '${levels[2].image}' : '',
                                    height: 42,
                                    width: 42,
                                    fit: BoxFit.fill,
                                  );
                                }
                                if (user.balance! >= levels[3].mustCoins! && user.balance! < levels[4].mustCoins!) {
                                  return Image.network(
                                    levels[3].image != null ? '${levels[3].image}' : '',
                                    height: 42,
                                    width: 42,
                                    fit: BoxFit.fill,
                                  );
                                }
                                if (user.balance! >= levels[4].mustCoins!) {
                                  return Image.network(
                                    levels[4].image != null ? '${levels[4].image}' : '',
                                    height: 42,
                                    width: 42,
                                    fit: BoxFit.fill,
                                  );
                                }
                              }
                              return Container();
                            }),
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
                style: CustomTextStyle.grey_14_w400,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ScaleButton(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoute.editBasicInfo);
                },
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
                            style: CustomTextStyle.grey_12_w400,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Имя, Телефон и E-mail',
                            style: CustomTextStyle.black_14_w400_171716,
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
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoute.editIdentityInfo);
                },
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
                            style: CustomTextStyle.grey_12_w400,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Пароль, паспортные данные, регион',
                            style: CustomTextStyle.black_14_w400_171716,
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
            SizedBox(height: 20.h),
            ScaleButton(
              bound: 0.02,
              onTap: () {
                BlocProvider.of<ProfileBloc>(context).setAccess(null);
                BlocProvider.of<ProfileBloc>(context).setUser(null);
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
              },
              child: Container(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                decoration: BoxDecoration(
                  color: ColorStyles.greyF9F9F9,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  color: Colors.transparent,
                  height: 50.h,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/logout_account.svg',
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Выйти из аккаунта',
                        style: CustomTextStyle.black_14_w500_171716,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () async {
                await Repository().deleteProfile(BlocProvider.of<ProfileBloc>(context).access!);
                BlocProvider.of<ProfileBloc>(context).setAccess(null);
                BlocProvider.of<ProfileBloc>(context).setUser(null);
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
              },
              child: Center(
                child: Text(
                  'Удалить аккаунт',
                  style: CustomTextStyle.black_14_w500_171716,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      );
    });
  }
}
