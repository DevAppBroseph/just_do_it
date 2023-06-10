import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerProfile extends StatefulWidget {
  Function() callBackFlag;
  CustomerProfile({super.key, required this.callBackFlag});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  late UserRegModel? userFile;
  TextEditingController experienceController = TextEditingController();
  List<ArrayImages> photos = [];
  @override
  void initState() {
    super.initState();
    List<int> activityIndexes = [];
    userFile = BlocProvider.of<ProfileBloc>(context).user;
    userFile?.copyWith(
      activitiesDocument: activityIndexes,
      groups: [4],
    );
    userFile?.copyWith(
      activitiesDocument: activityIndexes,
      groups: [4],
    );

    experienceController.text = userFile?.activity == null ? '' : userFile!.activity!;
    for (var element in userFile!.images!) {
      photos.add(
        ArrayImages(
          element.linkUrl!.contains(server) ? element.linkUrl : server + element.linkUrl!,
          null,
          id: element.id,
        ),
      );
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory? dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectories(type: StorageDirectory.downloads))?.first;
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    path = '${dir!.path}/$uniqueFileName';

    return path;
  }

  _selectImages() async {
    final getMedia = await ImagePicker().getMultiImage(imageQuality: 70);
    if (getMedia != null) {
      List<ArrayImages> files = [];
      for (var pickedFile in getMedia) {
        File? file = File(pickedFile.path);
        files.add(ArrayImages(null, file.readAsBytesSync(), file: file, type: file.path.split('.').last));
      }
      for (var element in files) {
        if (photos.length < 10) {
          photos.add(element);
        }
      }
      userFile?.copyWith(images: photos);
      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(userFile));
      setState(() {userFile;});
    }
  }

  _selectCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      var cv = File(result.files.first.path!);
      // this.cv = cv;
      userFile!.copyWith(cv: cv.readAsBytesSync());
      userFile!.copyWith(cvType: result.files.first.path!.split('.').last);

      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(userFile));
      setState(() {});
    }
  }

  bool proverka = true;
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoute.profile);
                },
                child: Container(
                  height: 270.h,
                  decoration: BoxDecoration(
                    color: ColorStyles.whiteFFFFFF,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.w, left: 24.w, top: 23.h, bottom: 5.h),
                        child: SizedBox(
                          height: 100.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
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
                                            size: Size.fromRadius(40.r),
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
                                                  )),
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
                                              boxShadow: const [BoxShadow(color: Colors.black)],
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
                              ),
                              SizedBox(width: 17.w),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 10.w,
                                    top: 25.h,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${user.firstname ?? ''}\n${user.lastname ?? ''}',
                                            style: CustomTextStyle.black_17_w600_171716,
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          final code = await FirebaseDynamicLinksService()
                                              .shareUserProfile(int.parse(user.id.toString()));
                                          Share.share(code.toString());
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icons/share.svg',
                                          height: 20.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      BlocBuilder<RatingBloc, RatingState>(builder: (context, snapshot) {
                        var reviews = BlocProvider.of<RatingBloc>(context).reviews;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(AppRoute.score);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 2.8.h),
                                    child: ScaleButton(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(AppRoute.score);
                                      },
                                      bound: 0.02,
                                      child: Container(
                                        height: 25.h,
                                        width: 70.h,
                                        decoration: BoxDecoration(
                                          color: ColorStyles.greyEAECEE,
                                          borderRadius: BorderRadius.circular(30.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Грейды',
                                            style: CustomTextStyle.purple_12_w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
                                        if (state is ScoreLoaded) {
                                          Future.delayed(const Duration(milliseconds: 500), () {
                                            widget.callBackFlag();
                                          });
                                          final levels = state.levels;
                                          if (user.balance! < levels![0].mustCoins!) {
                                            return CachedNetworkImage(
                                              progressIndicatorBuilder: (context, url, progress) {
                                                return const CupertinoActivityIndicator();
                                              },
                                              imageUrl: '${levels[0].bwImage}',
                                              height: 30.h,
                                              width: 30.w,
                                            );
                                          }
                                          for (int i = 0; i < levels.length; i++) {
                                            if (levels[i + 1].mustCoins == null) {
                                              return CachedNetworkImage(
                                                progressIndicatorBuilder: (context, url, progress) {
                                                  return const CupertinoActivityIndicator();
                                                },
                                                imageUrl: '${levels[i].image}',
                                                height: 30.h,
                                                width: 30.w,
                                              );
                                            } else {
                                              if (user.balance! >= levels[i].mustCoins! &&
                                                  user.balance! < levels[i + 1].mustCoins!) {
                                                return CachedNetworkImage(
                                                  progressIndicatorBuilder: (context, url, progress) {
                                                    return const CupertinoActivityIndicator();
                                                  },
                                                  imageUrl: '${levels[i].image}',
                                                  height: 30.h,
                                                  width: 30.w,
                                                );
                                              } else if (user.balance! >= levels.last.mustCoins!) {
                                                return CachedNetworkImage(
                                                  progressIndicatorBuilder: (context, url, progress) {
                                                    return const CupertinoActivityIndicator();
                                                  },
                                                  imageUrl: '${levels.last.image}',
                                                  height: 30.h,
                                                  width: 30.w,
                                                );
                                              }
                                            }
                                          }
                                        }
                                        return Container();
                                      }),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Text(
                                          user.balance.toString(),
                                          style: CustomTextStyle.purple_15_w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(AppRoute.rating);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 7.5.h),
                                    child: ScaleButton(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(AppRoute.rating);
                                      },
                                      bound: 0.02,
                                      child: Container(
                                        height: 25.h,
                                        width: 90.h,
                                        decoration: BoxDecoration(
                                          color: ColorStyles.yellowFFCA0D.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(30.r),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Рейтинг',
                                                style: CustomTextStyle.gold_12_w400,
                                              ),
                                              SizedBox(width: 3.h),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 12,
                                                    height: 12,
                                                    child: SvgPicture.asset(
                                                      'assets/icons/star.svg',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 4.h),
                                    child: SizedBox(
                                      child: Text(
                                        reviews?.ranking == null ? '3.4' : reviews!.ranking!.toString(),
                                        style: CustomTextStyle.gold_16_w600_171716,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(AppRoute.rating);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: ScaleButton(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(AppRoute.rating);
                                      },
                                      bound: 0.02,
                                      child: Container(
                                        height: 25.h,
                                        width: 75.h,
                                        decoration: BoxDecoration(
                                          color: ColorStyles.blue336FEE.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(30.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Отзывы',
                                            style: CustomTextStyle.blue_12_w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 4.0.h),
                                    child: SizedBox(
                                      child: Text(
                                        '34',
                                        style: CustomTextStyle.blue_16_w600_171716,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(left: 15.h),
                        child: Row(
                          children: [
                            Text(
                              'Создано заданий:',
                              style: CustomTextStyle.grey_12_w400,
                            ),
                            Text(
                              ' 40',
                              style: CustomTextStyle.black_13_w500_171716,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.h),
                        child: Row(
                          children: [
                            Text(
                              'Выполнено заданий:',
                              style: CustomTextStyle.grey_12_w400,
                            ),
                            Text(
                              ' 40',
                              style: CustomTextStyle.black_13_w500_171716,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h),
              child: Container(
                height: 230.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: ColorStyles.whiteFFFFFF,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 20.w),
                      child: Text(
                        'Основная информация',
                        style: CustomTextStyle.black_16_w600_515150,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoute.editBasicInfo);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/user-square.svg',
                              color: ColorStyles.yellowFFCA0D,
                            ),
                            SizedBox(width: 3.w),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ваше Имя',
                                        style: CustomTextStyle.black_13_w400_171716,
                                      ),
                                      SizedBox(
                                        width: 235.w,
                                        child: Text(
                                          'Изменить имя профиля',
                                          style: CustomTextStyle.grey_12_w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorStyles.greyBDBDBD,
                                    size: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoute.editBasicInfo);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/call.svg',
                              color: ColorStyles.yellowFFCA0D,
                            ),
                            SizedBox(width: 3.w),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Телефон',
                                        style: CustomTextStyle.black_13_w400_171716,
                                      ),
                                      SizedBox(
                                        width: 235.w,
                                        child: Text(
                                          'Изменить номер телефона',
                                          style: CustomTextStyle.grey_12_w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorStyles.greyBDBDBD,
                                    size: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoute.editBasicInfo);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/sms-notification.svg',
                              color: ColorStyles.yellowFFCA0D,
                            ),
                            SizedBox(width: 3.w),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'E-mail',
                                        style: CustomTextStyle.black_13_w400_171716,
                                      ),
                                      SizedBox(
                                        width: 235.w,
                                        child: Text(
                                          'Изменить электронную почту',
                                          style: CustomTextStyle.grey_12_w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorStyles.greyBDBDBD,
                                    size: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, bottom: 15.h, right: 20.w, top: 15.h),
              child: Container(
                height: 230.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: ColorStyles.whiteFFFFFF,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 20.w),
                      child: Text(
                        'Безопасность',
                        style: CustomTextStyle.black_16_w600_515150,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoute.editIdentityInfo);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/password-check.svg',
                              color: ColorStyles.yellowFFCA0D,
                            ),
                            SizedBox(width: 3.w),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Пароль',
                                        style: CustomTextStyle.black_13_w400_171716,
                                      ),
                                      SizedBox(
                                        width: 235.w,
                                        child: Text(
                                          'Изменить пароль учетной записи',
                                          style: CustomTextStyle.grey_12_w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorStyles.greyBDBDBD,
                                    size: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoute.editIdentityInfo);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/finger-scan.svg',
                              color: ColorStyles.yellowFFCA0D,
                            ),
                            SizedBox(width: 3.w),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Паспортные данные',
                                        style: CustomTextStyle.black_13_w400_171716,
                                      ),
                                      SizedBox(
                                        width: 235.w,
                                        child: Text(
                                          'Изменить ваши личные данные',
                                          style: CustomTextStyle.grey_12_w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorStyles.greyBDBDBD,
                                    size: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoute.editIdentityInfo);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, left: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/location1.svg',
                              color: ColorStyles.yellowFFCA0D,
                            ),
                            SizedBox(width: 3.w),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Регион',
                                        style: CustomTextStyle.black_13_w400_171716,
                                      ),
                                      SizedBox(
                                        width: 235.w,
                                        child: Text(
                                          'Изменить регион',
                                          style: CustomTextStyle.grey_12_w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorStyles.greyBDBDBD,
                                    size: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  width: 335.w,
                  decoration: BoxDecoration(
                    color: ColorStyles.whiteFFFFFF,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Stack(
                    children: [
                      ScaleButton(
                        duration: const Duration(milliseconds: 50),
                        bound: 0.01,
                        onTap: _selectCV,
                        child: Container(
                          height: 60.h,
                          width: 190.w,
                          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 11.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 14.h,
                                width: 14.h,
                                child: SvgPicture.asset(SvgImg.documentText, color: ColorStyles.blue336FEE),
                              ),
                              SizedBox(width: 9.17.w),
                              Text(
                                'Загрузить резюме (10мб)',
                                style: CustomTextStyle.blue_12_w400,
                              )
                            ],
                          ),
                        ),
                      ),
                      if (userFile?.cvLink != null)
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 12.h,
                            width: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
            if (userFile?.cvLink != null) SizedBox(height: 8.h),
            if (userFile?.cvLink != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    SizedBox(
                      height: 60.h,
                      width: 60.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // OpenFile.open(cv!.path);
                              launch(
                                  userFile!.cvLink!.contains(server) ? userFile!.cvLink! : server + userFile!.cvLink!);
                            },
                            child: Container(
                              height: 50.h,
                              width: 50.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [BoxShadow(color: Colors.black)],
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgImg.documentText,
                                  height: 25.h,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                // cv = null;

                                userFile?.cv = null;
                                userFile?.cvLink = null;
                                userFile?.cvType = null;
                                BlocProvider.of<ProfileBloc>(context).setUser(user);
                                BlocProvider.of<ProfileBloc>(context).add(
                                  UpdateProfileCvEvent(file: null),
                                );
                                setState(() {});
                              },
                              child: Container(
                                height: 15.h,
                                width: 15.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [BoxShadow(color: Colors.black)],
                                    borderRadius: BorderRadius.circular(40.r)),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    size: 10.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
