import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
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

class ContractorProfile extends StatefulWidget {
  double padding;
  Function() callBackFlag;
  ContractorProfile({super.key, required this.padding, required this.callBackFlag});

  @override
  State<ContractorProfile> createState() => _ContractorProfileState();
}

class _ContractorProfileState extends State<ContractorProfile> {
  FocusNode focusNode = FocusNode();
  TextEditingController experienceController = TextEditingController();
  late UserRegModel? user;

  final GlobalKey _categoryButtonKey = GlobalKey();
  List<String> typeCategories = [];
  List<Activities> listCategories = [];
  List<ArrayImages> photos = [];

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<ProfileBloc>(context).user;
    listCategories = BlocProvider.of<ProfileBloc>(context).activities;
    
    log('message');
    List<int> activityIndexes = [];

    for (int i = 0; i < listCategories.length; i++) {
      for (int j = 0; j < user!.activitiesInfo!.length; j++) {
        if (listCategories[i].description == user!.activitiesInfo?[j].description) {
          typeCategories.add(listCategories[i].description!);
          activityIndexes.add(user!.activitiesInfo![j].id!);
        }
      }
    }

    user?.copyWith(
      activitiesDocument: activityIndexes,
      groups: [4],
    );

    experienceController.text = user?.activity == null ? '' : user!.activity!;
    for (var element in user!.images!) {
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
      user?.copyWith(images: photos);
      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
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
      user!.copyWith(cv: cv.readAsBytesSync());
      user!.copyWith(cvType: result.files.first.path!.split('.').last);

      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
      setState(() {});
    }
  }

  int? proverkaBalance;
  bool change = false;
  bool openImages = false;

  bool proverka = true;
  @override
  Widget build(BuildContext context) {
    Reviews? reviews = BlocProvider.of<RatingBloc>(context).reviews;

    return BlocBuilder<ProfileBloc, ProfileState>(buildWhen: (previous, current) {
      Loader.hide();
      if (current is UpdateProfileSuccessState) {
        user = BlocProvider.of<ProfileBloc>(context).user;
        if (user!.images != null) {
          photos.clear();
          photos.addAll(user!.images!);
        }
      }
      return true;
    }, builder: (context, data) {
      double widthTabBarItem = (MediaQuery.of(context).size.width - 40.w) / 2;
      return MediaQuery(
        data: const MediaQueryData(textScaleFactor: 1.0),
        child: GestureDetector(
          onTap: () {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
              user!.copyWith(activity: experienceController.text);
              BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
            }
          },
          child: ListView(
            shrinkWrap: true,
            padding: MediaQuery.of(context).viewInsets,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 270.h,
                    decoration: BoxDecoration(
                      color: ColorStyles.whiteFFFFFF,
                      borderRadius: BorderRadius.circular(20.r),
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
                                  height: 80.h,
                                  width: 80.h,
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
                                                      imageUrl: user!.photoLink!.contains(server)
                                                          ? user!.photoLink!
                                                          : server + user!.photoLink!,
                                                      fit: BoxFit.cover,
                                                    )),
                                        ),
                                      ),
                                      if (user!.photoLink != null)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              user!.photo = null;
                                              user!.photoLink = null;
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
                                              '${user!.firstname ?? ''}\n${user!.lastname ?? ''}',
                                              style: CustomTextStyle.black_18_w800,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            final code = await FirebaseDynamicLinksService()
                                                .shareUserProfile(int.parse(user!.id.toString()));
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
                                        BlocBuilder<ScoreBloc, ScoreState>(buildWhen: (previous, current) {
                                          if (user!.balance! == proverkaBalance) {
                                            return false;
                                          }
                                          return true;
                                        }, builder: (context, state) {
                                          if (state is ScoreLoaded) {
                                            Future.delayed(const Duration(milliseconds: 500), () {
                                              widget.callBackFlag();
                                            });
                                            proverkaBalance = user!.balance!;
                                            final levels = state.levels;
                                            if (user!.balance! < levels![0].mustCoins!) {
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
                                                if (user!.balance! >= levels[i].mustCoins! &&
                                                    user!.balance! < levels[i + 1].mustCoins!) {
                                                  return CachedNetworkImage(
                                                    progressIndicatorBuilder: (context, url, progress) {
                                                      return const CupertinoActivityIndicator();
                                                    },
                                                    imageUrl: '${levels[i].image}',
                                                    height: 30.h,
                                                    width: 30.w,
                                                  );
                                                } else if (user!.balance! >= levels.last.mustCoins!) {
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
                                            user!.balance.toString(),
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
                  height: 225.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: ColorStyles.whiteFFFFFF,
                    borderRadius: BorderRadius.circular(20.r),
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
                  height: 225.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: ColorStyles.whiteFFFFFF,
                    borderRadius: BorderRadius.circular(20.r),
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
                                            'Изменить Ваши личные данные',
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
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 11.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                      width: 3.h,
                                    ),
                                SizedBox(
                                  height: 14.h,
                                  width: 14.h,
                                  child: SvgPicture.asset(
                                    SvgImg.documentText,
                                    color: ColorStyles.blue336FEE,
                                  ),
                                ),
                                SizedBox(width: 9.17.w),
                                Text(
                                  'Загрузить резюме (10мб)',
                                  style: CustomTextStyle.blue_12_w400,
                                ),
                                SizedBox(
                                  width: 100.h,
                                ),
                                Text(
                                  '.doc, .pdf',
                                  style: CustomTextStyle.grey_12_w400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (user?.cvLink != null)
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
              if (user?.cvLink != null) SizedBox(height: 8.h),
              if (user?.cvLink != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 60.h,
                        width: 120.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // OpenFile.open(cv!.path);
                                launch(user!.cvLink!.contains(server) ? user!.cvLink! : server + user!.cvLink!);
                              },
                              child: Container(
                                height: 50.h,
                                width: 120.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [BoxShadow(color: Colors.black)],
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    SvgPicture.asset(
                                      SvgImg.documentText,
                                      height: 25.h,
                                    ),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    Text(
                                      'Rezume.pdf',
                                      style: CustomTextStyle.black_11_w400_171716,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  // cv = null;

                                  user?.cv = null;
                                  user?.cvLink = null;
                                  user?.cvType = null;
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
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: user != null && typeCategories.isEmpty
                      ? 120.h
                      : typeCategories.length == 3
                          ? 260.h
                          : typeCategories.length == 2
                              ? 200.h
                              : 160.h,
                  decoration: BoxDecoration(
                    color: ColorStyles.whiteFFFFFF,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.h, left: 20.w),
                        child: Row(
                          children: [
                            Text(
                              'Ваши категории',
                              style: CustomTextStyle.black_16_w600_171716,
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 25.w),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: CustomTextStyle.blue_14_w400_336FEE,
                                ),
                                onPressed: () {
                                  showIconModalCategories(
                                    context,
                                    _categoryButtonKey,
                                    (value) {
                                      List<int> activityIndexes = [];

                                      for (var element in typeCategories) {
                                        activityIndexes.add(listCategories
                                            .firstWhere((element2) => element2.description == element)
                                            .id);
                                      }
                                      user?.copyWith(
                                        activitiesDocument: activityIndexes,
                                        groups: [4],
                                      );

                                      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));

                                      setState(() {});
                                    },
                                    listCategories,
                                    'Выбор до 3х категорий*',
                                    typeCategories,
                                  );
                                },
                                key: _categoryButtonKey,
                                child: const Text('Изменить'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.h),
                      if (user != null && typeCategories.isEmpty) SizedBox(height: 6.h),
                      if (user != null && typeCategories.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'Вы не выбрали ни одной категории',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        ),
                      if (user != null && typeCategories.isNotEmpty)
                        SizedBox(
                          height: typeCategories.length == 3
                              ? 180.h
                              : typeCategories.length == 2
                                  ? 130
                                  : 80,
                          width: double.infinity,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(left: 24.w, right: 18.w),
                            itemCount: typeCategories.length,
                            itemBuilder: (context, index) {
                              var category =
                                  listCategories.firstWhere((element) => element.description == typeCategories[index]);

                              return _categoryItem(category, index);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AnimatedContainer(
                  height: user?.images?.isEmpty ?? true
                      ? change
                          ? 270.h
                          : 235.h
                      : change
                          ? 374.h
                          : 324.h,
                  width: 327.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: ColorStyles.whiteFFFFFF,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 45.r,
                        color: ColorStyles.shadowFC6554,
                      ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ваш опыт работы',
                                style: CustomTextStyle.black_16_w600_171716,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: CustomTextStyle.blue_14_w400_336FEE,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      change = true;
                                    });
                                  },
                                  child: const Text('Изменить'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 130.h,
                          child: TextFormField(
                            enabled: change,
                            autocorrect: true,
                            onTap: () {
                              if (user!.activity != experienceController.text) {
                                user!.copyWith(activity: experienceController.text);
                                BlocProvider.of<ProfileBloc>(context).add(
                                  UpdateProfileWithoutLoadingEvent(user),
                                );
                              }
                            },
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: focusNode,
                            decoration: InputDecoration.collapsed(
                              hintText: "Опишите свой опыт работы и прикрепите изображения",
                              border: InputBorder.none,
                              hintStyle: CustomTextStyle.grey_14_w400,
                            ),
                            controller: experienceController,
                            style: CustomTextStyle.black_14_w400_515150,
                            maxLines: 2,
                            onFieldSubmitted: (value) {
                              if (user!.activity != experienceController.text) {
                                user!.copyWith(activity: experienceController.text);
                                BlocProvider.of<ProfileBloc>(context).add(
                                  UpdateProfileWithoutLoadingEvent(user),
                                );
                              }
                            },
                            inputFormatters: [LengthLimitingTextInputFormatter(250)],
                            onChanged: (String value) {
                              BlocProvider.of<ProfileBloc>(context).user!.copyWith(activity: experienceController.text);

                              setState(() {});
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${experienceController.text.length}/250',
                              style: CustomTextStyle.grey_12_w400,
                            )
                          ],
                        ),
                        if (user!.images!.isNotEmpty && change)
                          SizedBox(
                            width: 400.w,
                            child: const Divider(
                              color: ColorStyles.greyD9D9D9,
                              thickness: 1,
                            ),
                          ),
                        if (user!.images!.isNotEmpty)
                          SizedBox(
                            height: 5.h,
                          ),
                        if (user!.images!.isNotEmpty)
                          SizedBox(
                            height: user!.images!.isEmpty ? 0 : 82.h,
                            width: !change ? 300.w :double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics:
                                  openImages ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    if (change)
                                      GestureDetector(
                                        onTap: () async {
                                          user!.images!.removeAt(index);

                                          BlocProvider.of<ProfileBloc>(context).setUser(user);

                                          BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                                          setState(() {});
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 60.w),
                                          child: SvgPicture.asset(
                                            'assets/icons/x-circle.svg',
                                            height: 15.h,
                                            width: 15.w,
                                            color: ColorStyles.redFC6554,
                                          ),
                                        ),
                                      ),
                                    GestureDetector(
                                      onTap: () {
                                        launch(user!.images![index].linkUrl!.contains(server)
                                            ? user!.images![index].linkUrl!
                                            : server + user!.images![index].linkUrl!);
                                      },
                                      child: SizedBox(
                                        width: 80.h,
                                        height: 65.h,
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 5.w, left: 7.w),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.r),
                                                child: SizedBox(
                                                  width: 65.h,
                                                  height: 65.h,
                                                  child: user!.images![index].byte != null
                                                      ? Image.memory(
                                                          user!.images![index].byte!,
                                                          width: 65.h,
                                                          height: 65.h,
                                                          fit: BoxFit.cover,
                                                          frameBuilder:
                                                              (context, child, frame, wasSynchronouslyLoaded) {
                                                            return const CupertinoActivityIndicator();
                                                          },
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: user!.images![index].linkUrl!.contains(server)
                                                              ? user!.images![index].linkUrl!
                                                              : '$server${user!.images![index].linkUrl}',
                                                          progressIndicatorBuilder: (context, url, progress) {
                                                            return const CupertinoActivityIndicator();
                                                          },
                                                          width: 65.h,
                                                          height: 65.h,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            if (index == 3 && !openImages && user!.images!.length > 4)
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    openImages = true;
                                                  });
                                                },
                                                child: Padding(
                                                  padding:  EdgeInsets.only(right: 5.w, left: 7.w),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10.r),
                                                      child: Container(
                                                        width: 65.h,
                                                      height: 65.h,
                                                        decoration:  BoxDecoration(
                                                          color: ColorStyles.black.withOpacity(0.4),
                                                          
                                                        ),
                                                        child: Center(child: Text('+ ${user!.images!.length - 4}', style: CustomTextStyle.white_16_w600)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            // if (change)
                                            //   GestureDetector(
                                            //     onTap: () async {
                                            //       user!.images!.removeAt(index);

                                            //       BlocProvider.of<ProfileBloc>(context).setUser(user);

                                            //       BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                                            //       setState(() {});
                                            //     },
                                            //     child: Align(
                                            //       alignment: Alignment.topRight,
                                            //       child: Container(
                                            //         width: 20.w,
                                            //         height: 20.h,
                                            //         margin: EdgeInsets.only(right: 10.w),
                                            //         decoration: const BoxDecoration(
                                            //           color: Colors.white,
                                            //           shape: BoxShape.circle,
                                            //         ),
                                            //         alignment: Alignment.center,
                                            //         child: Icon(
                                            //           Icons.close,
                                            //           color: Colors.black,
                                            //           size: 10.h,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: user!.images!.length,
                            ),
                          ),
                        if (change)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                change = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 15),
                              child: Text(
                                'Сохранить',
                                style: CustomTextStyle.blue_14_w400_336FEE,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Stack(
                  children: [
                    ScaleButton(
                      bound: 0.02,
                      onTap: () {
                        _selectImages();
                      },
                      child: Container(
                        height: 45.h,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: ColorStyles.whiteFFFFFF,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 14.h,
                              width: 14.h,
                              child: SvgPicture.asset(
                                SvgImg.addCircle,
                                color: ColorStyles.blue336FEE,
                              ),
                            ),
                            SizedBox(width: 9.17.w),
                            Text(
                              'Изображения',
                              style: CustomTextStyle.blue_12_w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (user?.images?.isNotEmpty ?? false)
                      SizedBox(
                        width: 121.w,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 16.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Text(
                                user?.images?.length.toString() ?? '',
                                style: CustomTextStyle.white_11.copyWith(fontSize: 10.sp),
                              ),
                            ),
                          ),
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
                    color: ColorStyles.whiteFFFFFF,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 15.h),
              Container(
                height: 50.h,
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                decoration: BoxDecoration(
                  color: ColorStyles.whiteFFFFFF,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
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
              ),
              SizedBox(height: widget.padding + 50.h),
            ],
          ),
        ),
      );
    });
  }

  Widget _categoryItem(Activities activitiy, int index) {
    return Container(
      height: 50.h,
      width: 115.w,
      margin: EdgeInsets.only(right: 6.w, top: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: index == 0
            ? const Color.fromRGBO(255, 234, 203, 1)
            : index == 1
                ? const Color.fromRGBO(255, 224, 237, 1)
                : const Color.fromRGBO(213, 247, 254, 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (activitiy.photo != null)
              Image.network(
                server + activitiy.photo!,
                width: 24.w,
                height: 24.h,
              ),
            SizedBox(width: 10.w),
            Text(
              activitiy.description ?? '',
              style: CustomTextStyle.black_11_w400_171716,
            ),
          ],
        ),
      ),
    );
  }
}
