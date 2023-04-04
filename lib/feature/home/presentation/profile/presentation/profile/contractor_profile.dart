import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:scale_button/scale_button.dart';

class ContractorProfile extends StatefulWidget {
  const ContractorProfile({super.key});

  @override
  State<ContractorProfile> createState() => _ContractorProfileState();
}

class _ContractorProfileState extends State<ContractorProfile> {
  FocusNode focusNode = FocusNode();
  TextEditingController experienceController = TextEditingController();
  late UserRegModel? user;
  List<File> photos = [];
  @override
  void initState() {
    // TODO: implement initState
    user = BlocProvider.of<ProfileBloc>(context).user;
    print(user?.activity);
    print(user?.images);
    experienceController.text = user?.activity == null ? '' : user!.activity!;

    super.initState();
  }

  _selectImages() async {
    final getMedia = await ImagePicker().getMultiImage(imageQuality: 70);
    if (getMedia != null) {
      List<File> files = [];
      for (var pickedFile in getMedia) {
        File? file = File(pickedFile.path);
        files.add(file);
      }
      photos.clear();
      setState(() {
        photos.addAll(files);
        // user?.copyWith(images: photos);
      });
      // BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
    }
  }

  _selectCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      var cv = File(result.files.first.path!);
      user!.copyWith(cv: cv);
      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    UserRegModel? userReg = BlocProvider.of<ProfileBloc>(context).user;
    Reviews? reviews = BlocProvider.of<RatingBloc>(context).reviews;
    return BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) {
      if (current is UpdateProfileSuccessState) {
        return true;
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
            physics: const BouncingScrollPhysics(),
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
                          child: userReg!.photoLink == null
                              ? Container(
                                  height: 60.h,
                                  width: 60.h,
                                  padding: EdgeInsets.all(10.h),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.shadowFC6554,
                                  ),
                                  child:
                                      Image.asset('assets/images/camera.png'),
                                )
                              : CachedNetworkImage(
                                  imageUrl: userReg.photoLink!.contains(server)
                                      ? userReg.photoLink!
                                      : server + userReg.photoLink!,
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
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 297.w,
                      child: Text(
                        '${user!.firstname ?? ''} ${user!.lastname ?? ''}',
                        // 'Яна Александровна',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 32.h, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset('assets/icons/share.svg'),
                  ],
                ),
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
                                  style: CustomTextStyle.black_11_w500_515150),
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
                          if (user?.cv != null)
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
                    Text(
                      'Изменить',
                      style: CustomTextStyle.blue_13_w400_336FEE,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'Вы не выбрали ни одной категории',
                  style: CustomTextStyle.black_13_w400_515150,
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
                  height: photos.isEmpty ? 170.h : 220.h,
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
                            onTap: () {
                              if (user!.activity != experienceController.text) {
                                user!.copyWith(
                                    activity: experienceController.text);
                                BlocProvider.of<ProfileBloc>(context).add(
                                    UpdateProfileWithoutLoadingEvent(user));
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(500),
                            ],
                            onChanged: (String value) {
                              setState(() {});
                            },
                          ),
                        ),
                        if (photos.isEmpty) const Spacer(),
                        // if (user.activities)
                        if (photos.isNotEmpty)
                          SizedBox(
                            height: photos.isEmpty ? 0 : 75.h,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Column(
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
                                          child: Image.file(
                                            width: 65.h,
                                            height: 65.h,
                                            photos[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: photos.length,
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
              SizedBox(
                height: 183.h + MediaQuery.of(context).viewInsets.bottom,
              ),
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
              SizedBox(height: 60.h),
            ],
          ),
        ),
      );
    });
  }
}
