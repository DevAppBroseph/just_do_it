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
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scale_button/scale_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
  File? cv;

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<ProfileBloc>(context).user;
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<ScoreBloc>().add(GetScoreEvent(access));
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
    if (user?.cvLink != null) downloadCV(user!.cvLink!);
    getPhotos();
  }

  void getPhotos() async {
    for (var element in user!.images!) {
      log('messageэ ${element.linkUrl}');
      element.byte = await Repository().downloadFile(
          element.linkUrl!.contains(server)
              ? element.linkUrl!
              : server + element.linkUrl!);
      log('message ${element.linkUrl} ${element.byte == null}');
    }
  }

  void downloadCV(String url) async {
    Uint8List? byte = await Repository()
        .downloadFile(url.contains(server) ? url : server + url);
    String savePath = await getFilePath(url.split('/').last);
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(byte!);
      cv = file;
      await raf.close();
      setState(() {});
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory? dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectories(
              type: StorageDirectory.downloads))
          ?.first;
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
        files.add(ArrayImages(null, file.readAsBytesSync()));
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
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      var cv = File(result.files.first.path!);
      this.cv = cv;
      user!.copyWith(cv: cv.readAsBytesSync());
      user!.copyWith(cvType: result.files.first.path!.split('.').last);

      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Reviews? reviews = BlocProvider.of<RatingBloc>(context).reviews;
    return BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) {
      Loader.hide();
      if (current is UpdateProfileSuccessState) {
        user = BlocProvider.of<ProfileBloc>(context).user;
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
              BlocProvider.of<ProfileBloc>(context)
                  .add(UpdateProfileEvent(user));
            }
          },
          child: ListView(
            shrinkWrap: true,
            padding: MediaQuery.of(context).viewInsets,
            children: [
              SizedBox(width: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 21.w),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 68.h,
                              width: 68.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var image = await ImagePicker().pickImage(
                                          source: ImageSource.gallery);
                                      if (image != null) {
                                        BlocProvider.of<ProfileBloc>(context)
                                            .add(
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: ColorStyles
                                                        .shadowFC6554,
                                                  ),
                                                  child: Image.asset(
                                                      'assets/images/camera.png'),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: user!.photoLink!
                                                          .contains(server)
                                                      ? user!.photoLink!
                                                      : server +
                                                          user!.photoLink!,
                                                  fit: BoxFit.cover,
                                                )),
                                    ),
                                  ),
                                  if (user?.photoLink != null)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          user?.photo = null;
                                          user?.photoLink = null;
                                          BlocProvider.of<ProfileBloc>(context)
                                              .setUser(user);
                                          BlocProvider.of<ProfileBloc>(context)
                                              .add(
                                            UpdateProfilePhotoEvent(
                                                photo: null),
                                          );
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 20.h,
                                          width: 20.h,
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(color: Colors.black)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(100.r),
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
                          ],
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ваш рейтинг',
                                style: CustomTextStyle.black_12_w500_515150,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    color: ColorStyles.black,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    reviews?.ranking == null
                                        ? '-'
                                        : (reviews!.ranking!).toString(),
                                    style: CustomTextStyle.black_20_w700_171716,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 25.w),
                    const Spacer(),
                    SizedBox(
                      width: 240.w,
                      child: AutoSizeText(
                        '${user?.firstname ?? ''} ${user?.lastname ?? ''}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30.sp, fontWeight: FontWeight.w800),
                        maxLines: 2,
                        softWrap: true,
                      ),
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
                        height: 25.h,
                      ),
                    ),
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
                                    'Ваш грейд',
                                    style: CustomTextStyle.black_12_w500_515150,
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      BlocBuilder<ScoreBloc, ScoreState>(
                                          builder: (context, state) {
                                        if (state is ScoreLoaded) {
                                          final levels = state.levels;
                                          if (user!.balance! <
                                              levels![0].mustCoins!) {
                                            return Text(
                                              levels[0].name!,
                                              style: CustomTextStyle
                                                  .purple_20_w700
                                                  .copyWith(fontSize: 15),
                                            );
                                          }

                                          if (user!.balance! >=
                                                  levels[0].mustCoins! &&
                                              user!.balance! <
                                                  levels[1].mustCoins!) {
                                            return Text(
                                              levels[0].name!,
                                              style: CustomTextStyle
                                                  .purple_20_w700
                                                  .copyWith(fontSize: 15),
                                            );
                                          }
                                          if (user!.balance! >=
                                                  levels[1].mustCoins! &&
                                              user!.balance! <
                                                  levels[2].mustCoins!) {
                                            return Text(
                                              levels[1].name!,
                                              style: CustomTextStyle
                                                  .purple_20_w700
                                                  .copyWith(fontSize: 15),
                                            );
                                          }
                                          if (user!.balance! >=
                                                  levels[2].mustCoins! &&
                                              user!.balance! <
                                                  levels[3].mustCoins!) {
                                            return Text(
                                              levels[2].name!,
                                              style: CustomTextStyle
                                                  .purple_20_w700
                                                  .copyWith(fontSize: 15),
                                            );
                                          }
                                          if (user!.balance! >=
                                                  levels[3].mustCoins! &&
                                              user!.balance! <
                                                  levels[4].mustCoins!) {
                                            return Text(
                                              levels[3].name!,
                                              style: CustomTextStyle
                                                  .purple_20_w700
                                                  .copyWith(fontSize: 15),
                                            );
                                          }
                                          if (user!.balance! >=
                                              levels[4].mustCoins!) {
                                            return Text(
                                              levels[4].name!,
                                              style: CustomTextStyle
                                                  .purple_20_w700
                                                  .copyWith(fontSize: 15),
                                            );
                                          }
                                        }
                                        return Container();
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              BlocBuilder<ScoreBloc, ScoreState>(
                                  builder: (context, state) {
                                if (state is ScoreLoaded) {
                                  final levels = state.levels;
                                  if (user!.balance! < levels![0].mustCoins!) {
                                    return CachedNetworkImage(
                                      imageUrl: '${levels[0].bwImage}',
                                      height: 42,
                                      width: 42,
                                    );
                                  }

                                  if (user!.balance! >= levels[0].mustCoins! &&
                                      user!.balance! < levels[1].mustCoins!) {
                                    return Image.network(
                                      '${levels[0].image}',
                                      height: 42,
                                      width: 42,
                                    );
                                  }
                                  if (user!.balance! >= levels[1].mustCoins! &&
                                      user!.balance! < levels[2].mustCoins!) {
                                    return Image.network(
                                      levels[1].image != null
                                          ? '${levels[1].image}'
                                          : '',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                  if (user!.balance! >= levels[2].mustCoins! &&
                                      user!.balance! < levels[3].mustCoins!) {
                                    return Image.network(
                                      levels[2].image != null
                                          ? '${levels[2].image}'
                                          : '',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                  if (user!.balance! >= levels[3].mustCoins! &&
                                      user!.balance! < levels[4].mustCoins!) {
                                    return Image.network(
                                      levels[3].image != null
                                          ? '${levels[3].image}'
                                          : '',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                  if (user!.balance! >= levels[4].mustCoins!) {
                                    return Image.network(
                                      levels[4].image != null
                                          ? '${levels[4].image}'
                                          : '',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.fill,
                                    );
                                  }
                                }
                                return Container();
                              }),
                              const Spacer(),
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
                                        user?.balance.toString() ?? '0',
                                        style: CustomTextStyle.purple_20_w700,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
              SizedBox(height: 18.h),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    width: 180.w,
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
                                  child: SvgPicture.asset(SvgImg.documentText),
                                ),
                                SizedBox(width: 9.17.w),
                                Text(
                                  'Загрузить резюме (10мб)',
                                  style: CustomTextStyle.black_12_w400,
                                )
                              ],
                            ),
                          ),
                        ),
                        if (cv != null)
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
              if (cv != null) SizedBox(height: 8.h),
              if (cv != null)
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
                                OpenFile.open(cv!.path);
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black)
                                    ],
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
                                  cv = null;

                                  user?.cv = null;
                                  user?.cvLink = null;
                                  user?.cvType = null;
                                  BlocProvider.of<ProfileBloc>(context)
                                      .setUser(user);
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
                                      boxShadow: const [
                                        BoxShadow(color: Colors.black)
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(40.r)),
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
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Text(
                      'Ваши категории',
                      style: CustomTextStyle.grey_14_w400,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        showIconModalCategories(
                          context,
                          _categoryButtonKey,
                          (value) {
                            List<int> activityIndexes = [];

                            for (var element in typeCategories) {
                              activityIndexes.add(listCategories
                                  .firstWhere((element2) =>
                                      element2.description == element)
                                  .id);
                            }
                            user?.copyWith(
                              activitiesDocument: activityIndexes,
                              groups: [4],
                            );
                            BlocProvider.of<ProfileBloc>(context)
                                .add(UpdateProfileEvent(user));

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
                        style: CustomTextStyle.blue_14_w400_336FEE,
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
                    style: CustomTextStyle.black_14_w400_515150,
                  ),
                ),
              if (user != null && typeCategories.isNotEmpty)
                SizedBox(
                  height: 90.h,
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
                  style: CustomTextStyle.grey_14_w400,
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
                              hintStyle: CustomTextStyle.black_14_w400_515150,
                            ),
                            controller: experienceController,
                            style: CustomTextStyle.black_14_w400_515150,
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
                                return GestureDetector(
                                  onTap: () {
                                    launch(user!.images![index].linkUrl!
                                            .contains(server)
                                        ? user!.images![index].linkUrl!
                                        : server +
                                            user!.images![index].linkUrl!);
                                  },
                                  child: SizedBox(
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
                                              child: user!.images![index]
                                                          .byte !=
                                                      null
                                                  ? Image.memory(
                                                      user!
                                                          .images![index].byte!,
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
                                            user!.images!.removeAt(index);
                                            setState(() {});
                                            for (var element in user!.images!) {
                                              element.byte ??=
                                                  await Repository()
                                                      .downloadFile(
                                                element.linkUrl!
                                                        .contains(server)
                                                    ? element.linkUrl!
                                                    : '$server${element.linkUrl}',
                                              );
                                            }

                                            BlocProvider.of<ProfileBloc>(
                                                    context)
                                                .setUser(user);

                                            BlocProvider.of<ProfileBloc>(
                                                    context)
                                                .add(UpdateProfileEvent(user));
                                            setState(() {});
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
                              style: CustomTextStyle.grey_12_w400,
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
                              style: CustomTextStyle.black_12_w400,
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
                                  fontSize: 11.sp,
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
                          style: CustomTextStyle.black_14_w500_171716,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              GestureDetector(
                onTap: () async {
                  await Repository().deleteProfile(
                      BlocProvider.of<ProfileBloc>(context).access!);
                  BlocProvider.of<ProfileBloc>(context).setAccess(null);
                  BlocProvider.of<ProfileBloc>(context).setUser(null);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
                },
                child: Center(
                  child: Text(
                    'Удалить аккаунт',
                    style: CustomTextStyle.black_14_w500_171716,
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
      height: 90.h,
      width: 115.w,
      margin: const EdgeInsets.only(right: 6),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (activitiy.photo != null)
              Image.network(
                server + activitiy.photo!,
                width: 24.w,
                height: 24.h,
              ),
            const Spacer(),
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
