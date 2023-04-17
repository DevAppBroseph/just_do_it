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
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';

class ContractorProfile extends StatefulWidget {
  double padding;
  ContractorProfile({super.key, required this.padding});

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
    user = BlocProvider.of<ProfileBloc>(context).user;
    listCategories = BlocProvider.of<ProfileBloc>(context).activities;

    for (int i = 0; i < listCategories.length; i++) {
      for (int j = 0; j < user!.activitiesInfo!.length; j++) {
        if (listCategories[i].description ==
            user!.activitiesInfo?[j].description) {
          typeCategories.add(listCategories[i].description!);
        }
      }
    }
    experienceController.text = user?.activity == null ? '' : user!.activity!;

    super.initState();
  }

  _selectImages() async {
    final getMedia = await ImagePicker().getMultiImage(imageQuality: 70);
    if (getMedia != null) {
      List<ArrayImages> files = [];
      for (var pickedFile in getMedia) {
        File? file = File(pickedFile.path);
        files.add(ArrayImages(null, file.readAsBytesSync()));
      }
      files.forEach((element) {
        if (photos.length < 10) {
          photos.add(element);
        }
      });
      user?.copyWith(images: photos);
      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
    }
  }

  _selectCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      var cv = File(result.files.first.path!);
      user!.copyWith(cv: cv.readAsBytesSync());
      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Reviews? reviews = BlocProvider.of<RatingBloc>(context).reviews;
    // log('message ${user?.toJson()}');
    return BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) {
      Loader.hide();
      if (current is UpdateProfileSuccessState) {
        user = BlocProvider.of<ProfileBloc>(context).user;
      }
      return true;
    }, builder: (context, data) {
      return MediaQuery(
        data: const MediaQueryData(textScaleFactor: 1.0),
        child: GestureDetector(
          onTap: () {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
              user!.copyWith(activity: experienceController.text);
              BlocProvider.of<ProfileBloc>(context)
                  .add(UpdateProfileEvent(user));
            }
          },
          child: ListView(
            shrinkWrap: true,
            padding: MediaQuery.of(context).viewInsets,
            // physics: const ClampingScrollPhysics(),
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
                          GestureDetector(
                            onTap: () async {
                              var image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
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
                                          child: Image.asset(
                                              'assets/images/camera.png'),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              user!.photoLink!.contains(server)
                                                  ? user!.photoLink!
                                                  : server + user!.photoLink!,
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
                          )
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        // width: 327.w,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 240.w,
                              child: AutoSizeText(
                                '${user?.firstname ?? ''}\n${user?.lastname ?? ''}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w800),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    'assets/icons/share.svg',
                    height: 25.h,
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
                            color: ColorStyles.greyF9F9F9,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ваш рейтинг',
                                style: CustomTextStyle.black_11_w500_515150,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/star.svg'),
                                  SizedBox(width: 4.w),
                                  Text(
                                    reviews?.ranking == null
                                        ? '-'
                                        : (reviews!.ranking!).toString(),
                                    style: CustomTextStyle.black_19_w700_171716,
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
                                    style: CustomTextStyle.black_11_w500_515150,
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Text(
                                        '900',
                                        style: CustomTextStyle.purple_19_w700,
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
                  style: CustomTextStyle.grey_13_w400,
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
                              style: CustomTextStyle.grey_11_w400,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Имя, Телефон и E-mail',
                              style: CustomTextStyle.black_13_w400_171716,
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
                              style: CustomTextStyle.grey_11_w400,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Пароль, паспортные данные, регион',
                              style: CustomTextStyle.black_13_w400_171716,
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
              Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Stack(
                        children: [
                          ScaleButton(
                            duration: const Duration(milliseconds: 50),
                            bound: 0.01,
                            onTap: _selectCV,
                            child: Container(
                              height: 40.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.h, vertical: 11.h),
                              decoration: BoxDecoration(
                                color: ColorStyles.greyF9F9F9,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 14.h,
                                    width: 14.h,
                                    child:
                                        SvgPicture.asset(SvgImg.documentText),
                                  ),
                                  SizedBox(width: 9.17.w),
                                  Text(
                                    'Загрузить резюме (10мб)',
                                    style: CustomTextStyle.black_11_w400,
                                  )
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
                  ),
                  Expanded(flex: 8, child: Container()),
                ],
              ),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Text(
                      'Ваши категории',
                      style: CustomTextStyle.grey_13_w400,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        showIconModalCategories(
                          context,
                          _categoryButtonKey,
                          (value) {
                            // categoryController.text = '';

                            String str = '';
                            if (value.isNotEmpty) {
                              str = value.first;
                            }

                            if (value.length > 1) {
                              for (int i = 1; i < typeCategories.length; i++) {
                                str += ', ${typeCategories[i]}';
                              }
                            }

                            List<int> activityIndexes = [];

                            typeCategories.forEach((element) {
                              activityIndexes.add(listCategories
                                  .firstWhere((element2) =>
                                      element2.description == element)
                                  .id);
                            });
                            user?.copyWith(
                              activitiesDocument: activityIndexes,
                              groups: [4],
                            );
                            BlocProvider.of<ProfileBloc>(context)
                                .add(UpdateProfileEvent(user));

                            // categoryController.text = str;

                            setState(() {});
                          },
                          listCategories,
                          'Выбор до 3х категорий*',
                          typeCategories,
                        );
                      },
                      child: Text(
                        'Изменить',
                        key: _categoryButtonKey,
                        style: CustomTextStyle.blue_13_w400_336FEE,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              if (user != null && typeCategories.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Вы не выбрали ни одной категории',
                    style: CustomTextStyle.black_13_w400_515150,
                  ),
                ),
              if (user != null && typeCategories.isNotEmpty)
                Container(
                  height: 74.h,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 24.w, right: 18.w),
                    itemCount: typeCategories.length,
                    itemBuilder: (context, index) {
                      var category = listCategories.firstWhere((element) =>
                          element.description == typeCategories[index]);

                      return _categoryItem(category, index);
                    },
                  ),
                ),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'Описание вашего опыта',
                  style: CustomTextStyle.grey_13_w400,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AnimatedContainer(
                  height: user?.images?.isEmpty ?? true ? 170.h : 220.h,
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
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90.h,
                          child: TextFormField(
                            onTap: () {
                              if (user!.activity != experienceController.text) {
                                user!.copyWith(
                                    activity: experienceController.text);
                                BlocProvider.of<ProfileBloc>(context).add(
                                  UpdateProfileWithoutLoadingEvent(user),
                                );
                              }
                            },
                            focusNode: focusNode,
                            decoration: InputDecoration.collapsed(
                              hintText:
                                  "Опишите свой опыт работы и прикрепите изображения",
                              border: InputBorder.none,
                              hintStyle: CustomTextStyle.black_13_w400_515150,
                            ),
                            controller: experienceController,
                            style: CustomTextStyle.black_13_w400_515150,
                            maxLines: null,
                            onFieldSubmitted: (value) {
                              if (user!.activity != experienceController.text) {
                                user!.copyWith(
                                    activity: experienceController.text);
                                BlocProvider.of<ProfileBloc>(context).add(
                                  UpdateProfileWithoutLoadingEvent(user),
                                );
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(500)
                            ],
                            onChanged: (String value) {
                              BlocProvider.of<ProfileBloc>(context)
                                  .user!
                                  .copyWith(
                                      activity: experienceController.text);

                              print(BlocProvider.of<ProfileBloc>(context)
                                  .user
                                  ?.activity);
                              setState(() {});
                            },
                          ),
                        ),
                        if (user!.images!.isNotEmpty) const Spacer(),
                        if (user!.images!.isNotEmpty)
                          SizedBox(
                            height: user!.images!.isEmpty ? 0 : 75.h,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                log('message ${index}');
                                return SizedBox(
                                  width: 80.h,
                                  height: 65.h,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: 5.w, left: 5.w),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: SizedBox(
                                            width: 65.h,
                                            height: 65.h,
                                            child: user!.images![index].byte !=
                                                    null
                                                ? Image.memory(
                                                    user!.images![index].byte!,
                                                    width: 65.h,
                                                    height: 65.h,
                                                    fit: BoxFit.cover,
                                                    frameBuilder: (context,
                                                        child,
                                                        frame,
                                                        wasSynchronouslyLoaded) {
                                                      return const CupertinoActivityIndicator();
                                                    },
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: user!
                                                            .images![index]
                                                            .linkUrl!
                                                            .contains(server)
                                                        ? user!.images![index]
                                                            .linkUrl!
                                                        : '$server${user!.images![index].linkUrl}',
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                            progress) {
                                                      return const CupertinoActivityIndicator();
                                                    },
                                                    width: 65.h,
                                                    height: 65.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            barrierColor: ColorStyles.black
                                                .withOpacity(0.4),
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return AlertDialog(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: SizedBox(
                                                  height: 100.h,
                                                  child:
                                                      const CupertinoActivityIndicator(),
                                                ),
                                              );
                                            },
                                          );
                                          user!.images!.removeAt(index);
                                          for (var element in user!.images!) {
                                            element.byte ??=
                                                await Repository().downloadFile(
                                              element.linkUrl!.contains(server)
                                                  ? element.linkUrl!
                                                  : '$server${element.linkUrl}',
                                            );
                                          }

                                          Navigator.of(context).pop();

                                          BlocProvider.of<ProfileBloc>(context)
                                              .add(UpdateProfileEvent(user));
                                        },
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            width: 20.w,
                                            height: 20.h,
                                            margin:
                                                EdgeInsets.only(right: 10.w),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              // border: Border.all(
                                              //   width: 1,
                                              //   color: Colors.black,
                                              // ),
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                              size: 10.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: user!.images!.length,
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${experienceController.text.length}/500',
                              style: CustomTextStyle.grey_11_w400,
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
                      onTap: () {
                        _selectImages();
                      },
                      child: Container(
                        height: 36.h,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: ColorStyles.greyF9F9F9,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 14.h,
                              width: 14.h,
                              child: SvgPicture.asset(SvgImg.addCircle),
                            ),
                            SizedBox(width: 9.17.w),
                            Text(
                              'Изображения',
                              style: CustomTextStyle.black_11_w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (user?.images?.isNotEmpty ?? false)
                      SizedBox(
                        width: 111.w,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 13.h,
                            width: 13.h,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Text(
                                user?.images?.length.toString() ?? '',
                                style: TextStyle(
                                  color: ColorStyles.whiteFFFFFF,
                                  fontSize: 10.sp,
                                ),
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
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
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
                          style: CustomTextStyle.black_13_w500_171716,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ProfileBloc>(context).setAccess(null);
                  BlocProvider.of<ProfileBloc>(context).setUser(null);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
                },
                child: Center(
                  child: Text(
                    'Удалить аккаунт',
                    style: CustomTextStyle.black_13_w500_171716,
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     BlocProvider.of<ProfileBloc>(context).setAccess(null);
              //     BlocProvider.of<ProfileBloc>(context).setUser(null);
              //     Navigator.of(context)
              //         .pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
              //   },
              //   child: Center(
              //     child: Text(
              //       'Удалить аккаунт',
              //       style: CustomTextStyle.black_13_w500_171716,
              //     ),
              //   ),
              // ),
              SizedBox(height: widget.padding + 50.h),
            ],
          ),
        ),
      );
    });
  }

  Widget _categoryItem(Activities activitiy, int index) {
    return Container(
      height: 74.h,
      width: 115.w,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          // BoxShadow(
          //   color: Color.fromRGBO(26, 42, 97, 0.06),
          //   offset: Offset(0, 4),
          //   blurRadius: .h,
          // )
        ],
        color: index == 0
            ? const Color.fromRGBO(255, 234, 203, 1)
            : index == 1
                ? const Color.fromRGBO(255, 224, 237, 1)
                : const Color.fromRGBO(213, 247, 254, 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (activitiy.photo != null)
              Image.network(
                server + activitiy.photo!,
                width: 24.w,
                height: 24.h,
              )
            else
              SizedBox(height: 24.h),
            SizedBox(height: 8.h),
            Text(
              activitiy.description ?? '',
              style: CustomTextStyle.black_15_w400_515150.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // color: Colors.red,
    );
  }
}
