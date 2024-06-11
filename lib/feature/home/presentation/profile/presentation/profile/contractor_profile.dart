import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/score/bloc_score/score_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/widgets/grade_mascot_image.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/services/firebase_dynamic_links/firebase_dynamic_links_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ContractorProfile extends StatefulWidget {
  final double padding;
  final Function() callBackFlag;

  const ContractorProfile(
      {super.key, required this.padding, required this.callBackFlag});

  @override
  State<ContractorProfile> createState() => _ContractorProfileState();
}

class _ContractorProfileState extends State<ContractorProfile> {
  FocusNode focusNode = FocusNode();
  TextEditingController experienceController = TextEditingController();
  late UserRegModel? user;

  final GlobalKey _categoryButtonKey = GlobalKey();
  List<String> typeCategories = [];
  List<TaskCategory> listCategories = [];
  List<ArrayImages> photos = [];

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<ProfileBloc>(context).user?.duplicate();
    listCategories = BlocProvider.of<ProfileBloc>(context).activities;
    List<int> activityIndexes = [];

    if (user != null && user!.activitiesInfo != null) {
      for (int i = 0; i < listCategories.length; i++) {
        for (int j = 0; j < user!.activitiesInfo!.length; j++) {
          if (listCategories[i].description ==
              user!.activitiesInfo?[j].description) {
            typeCategories.add(listCategories[i].description!);
            activityIndexes.add(user!.activitiesInfo![j].id!);
          }
        }
      }
    }

    user?.copyWith(
      activitiesDocument: activityIndexes,
      groups: [4],
    );

    experienceController.text = user?.activity ?? '';
    if (user != null && user!.images != null) {
      for (var element in user!.images!) {
        log("Element ${element.linkUrl}");
        photos.add(
          ArrayImages(
            element.linkUrl!.contains(server)
                ? element.linkUrl
                : server + element.linkUrl!,
            null,
            id: element.id,
          ),
        );
      }
    }
  }

  @override
  didChangeDependencies() {
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    super.didChangeDependencies();
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
        files.add(ArrayImages(null, file.readAsBytesSync(),
            file: file, type: file.path.split('.').last));
      }
      for (var element in files) {
        if (photos.length < 10) {
          photos.add(element);
        }
      }
      user?.copyWith(images: photos);
      setState(() {});
      if (!mounted) return;

      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
    }
  }

  // Initialize a variable to keep track of the permission request status
  bool _isRequestingPermission = false;

  _selectCV() async {
    await Permission.manageExternalStorage.request();

    if (_isRequestingPermission) {
      print('A permission request is already in progress.');
      return;
    }

    _isRequestingPermission = true;

    var status = await Permission.storage.status;

    if (status.isDenied) {

      var s = await Permission.storage.request();
      print(s.isGranted
      );
      status = await Permission.storage.status;
      print('is Denied');
      if (status.isGranted) {
        print('Storage permission not granted');
        _isRequestingPermission = false;
        return;
      }
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.any,
      //allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      var cv = File(result.files.first.path!);
      user!.copyWith(cv: cv.readAsBytesSync());
      user!.copyWith(cvType: result.files.first.path!.split('.').last);

      if (!mounted) return;
      BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
    }

    _isRequestingPermission = false;
  }

  int? proverkaBalance;
  bool change = false;
  bool openImages = false;

  bool proverka = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) {
      Loader.hide();

      if (current is UpdateProfileSuccessState ||
          current is LoadProfileSuccessState) {
        user = BlocProvider.of<ProfileBloc>(context).user!.duplicate();

        return true;
      }
      if (current is UpdateProfileTaskState) {
        user = BlocProvider.of<ProfileBloc>(context).user!.duplicate();
        if (user!.images != null) {
          photos.clear();
          photos.addAll(user!.images!);
        }
      }
      return true;
    }, builder: (context, data) {
      // double widthTabBarItem = (MediaQuery.of(context).size.width - 40.w) / 2;
      return MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    // height: 270.h,
                    decoration: BoxDecoration(
                      color: ColorStyles.whiteFFFFFF,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10.w, left: 24.w, top: 23.h, bottom: 5.h),
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
                                          var image = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          if (image != null) {
                                            if (!context.mounted) return;

                                            BlocProvider.of<ProfileBloc>(
                                                    context)
                                                .add(
                                              UpdateProfilePhotoEvent(
                                                  photo: image),
                                            );
                                          }
                                        },
                                        child: ClipOval(
                                          child: SizedBox.fromSize(
                                            size: Size.fromRadius(40.r),
                                            child: user?.photoLink == null
                                                ? Container(
                                                    height: 60.h,
                                                    width: 60.h,
                                                    padding:
                                                        EdgeInsets.all(10.h),
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
                                                  ),
                                          ),
                                        ),
                                      ),
                                      if (user?.photoLink != null)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              user!.photo = null;
                                              user!.photoLink = null;
                                              BlocProvider.of<ProfileBloc>(
                                                      context)
                                                  .setUser(user);
                                              BlocProvider.of<ProfileBloc>(
                                                      context)
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
                                                    BorderRadius.circular(
                                                        100.r),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${(user?.firstname ?? '')}\n${(user?.lastname ?? '')}',
                                                textAlign: TextAlign.start,
                                                style: CustomTextStyle
                                                    .black_18_w800,
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final code =
                                                await FirebaseDynamicLinksService()
                                                    .shareUserProfile(int.parse(
                                                        user!.id.toString()));
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
                        BlocBuilder<RatingBloc, RatingState>(
                            builder: (context, snapshot) {
                          var reviews =
                              BlocProvider.of<RatingBloc>(context).reviews;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoute.score);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 0.5.h),
                                  // padding: EdgeInsets.zero,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 1.5.h),
                                        child: ScaleButton(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed(AppRoute.score);
                                          },
                                          bound: 0.02,
                                          child: Container(
                                            height: 25.h,
                                            width: 70.h,
                                            decoration: BoxDecoration(
                                              color: ColorStyles.greyEAECEE,
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'grades'.tr(),
                                                style: CustomTextStyle
                                                    .purple12w400,
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
                                          BlocBuilder<ScoreBloc, ScoreState>(
                                              buildWhen: (previous, current) {
                                            if (user?.allbalance ==
                                                proverkaBalance) {
                                              return false;
                                            }
                                            return true;
                                          }, builder: (context, state) {
                                            if (state is ScoreLoaded) {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                widget.callBackFlag();
                                              });
                                              proverkaBalance =
                                                  user?.allbalance;
                                              final levels = state.levels;
                                              return GradeMascotImage(
                                                levels: levels,
                                                user: user,
                                              );
                                            }
                                            return Container();
                                          }),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            constraints:
                                                BoxConstraints(minHeight: 30.h),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(top: 2.h),
                                            child: Text(
                                              user?.balance.toString() ?? '',
                                              style:
                                                  CustomTextStyle.purple15w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoute.rating);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 7.5.h),
                                      child: ScaleButton(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed(AppRoute.rating);
                                        },
                                        bound: 0.02,
                                        child: Container(
                                          height: 25.h,
                                          width: 90.h,
                                          decoration: BoxDecoration(
                                            color: ColorStyles.yellowFFCA0D
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'rating'.tr(),
                                                  style: CustomTextStyle
                                                      .gold12w400,
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
                                          reviews?.ranking == null
                                              ? '0'
                                              : reviews!.ranking!.toString(),
                                          style: CustomTextStyle
                                              .gold_16_w600_171716,
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
                                  Navigator.of(context)
                                      .pushNamed(AppRoute.rating);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: ScaleButton(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed(AppRoute.rating);
                                        },
                                        bound: 0.02,
                                        child: Container(
                                          height: 25.h,
                                          width: 75.h,
                                          decoration: BoxDecoration(
                                            color: ColorStyles.blue336FEE
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'reviews'.tr(),
                                              style: CustomTextStyle.blue12w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 4.0.h),
                                      child: SizedBox(
                                        child: Text(
                                          reviews?.reviewsDetail == null
                                              ? ''
                                              : reviews!.reviewsDetail.length
                                                  .toString(),
                                          style: CustomTextStyle
                                              .blue_16_w600_171716,
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
                                'tasks_created'.tr(),
                                style: CustomTextStyle.grey12w400,
                              ),
                              Text(
                                user?.countOrdersCreateAsCustomer == null
                                    ? '0'
                                    : user!.countOrdersCreateAsCustomer
                                        .toString(),
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
                                'completed_tasks'.tr(),
                                style: CustomTextStyle.grey12w400,
                              ),
                              Text(
                                user?.countOrdersCompleteAsExecutor == null
                                    ? '0'
                                    : user!.countOrdersCompleteAsExecutor!
                                        .toString(),
                                style: CustomTextStyle.black_13_w500_171716,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              if ((user?.isBanned ?? false) ||
                  (user?.verifyStatus == "Failed")) ...[
                Container(
                  height: 40.h,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: ColorStyles.redFC6554.withOpacity(0.19),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          child:
                              SvgPicture.asset('assets/icons/info_circle.svg'),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          child: Text(
                            "ban_reason".tr(),
                            textAlign: TextAlign.start,
                            style: CustomTextStyle.red11w400171716,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedContainer(
                    width: 330.w,
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: ColorStyles.whiteFFFFFF,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 12.h, bottom: 12.h, left: 16.w, right: 16.w),
                      child: SizedBox(
                        width: 250.w,
                        child: Text(
                          (user?.verifyStatus == "Failed")
                              ? user?.banReason ?? "failed_verification".tr()
                              : user?.banReason ?? ("unknown_reason".tr()),
                          style: CustomTextStyle.black_14_w400_515150,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
              Padding(
                padding: EdgeInsets.only(
                    bottom: 7.h, top: 5.h, left: 20.w, right: 20.w),
                child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: ColorStyles.whiteFFFFFF,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 23.h, left: 20.w),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset('assets/icons/document.svg'),
                            SizedBox(width: 3.w),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 240.w,
                                    child: Text(
                                      'passport_data_uploaded'.tr(),
                                      style: user != null &&
                                              user!.docType != null &&
                                              user!.docType != ''
                                          ? CustomTextStyle.black_11_w400_171716
                                          : CustomTextStyle.grey12w400,
                                    ),
                                  ),
                                  if (user != null &&
                                      user!.docType != null &&
                                      user!.docType != '')
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 20.w),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            user?.verifyStatus != null &&
                                    user!.verifyStatus == 'Success'
                                ? SvgPicture.asset(
                                    'assets/icons/security-user.svg')
                                : SvgPicture.asset(
                                    'assets/icons/security-user.svg',
                                    color: Colors.red,
                                  ),
                            SizedBox(width: 3.w),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: user?.verifyStatus != null &&
                                            user!.verifyStatus == 'Success'
                                        ? 240.w
                                        : 180.w,
                                    child: user?.verifyStatus != null &&
                                            user!.verifyStatus == 'Success'
                                        ? Text('your_account_is_verified'.tr(),
                                            style: CustomTextStyle
                                                .black_11_w400_171716)
                                        : Text('re_verify'.tr(),
                                            style: CustomTextStyle
                                                .red11w400171716),
                                  ),
                                  if (user?.verifyStatus == 'Success') ...[
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  ] else if (user?.verifyStatus ==
                                      'Progress') ...[
                                    ScaleButton(
                                      onTap: () {},
                                      bound: 0.02,
                                      child: Container(
                                        height: 22.h,
                                        width: 86.w,
                                        decoration: BoxDecoration(
                                          color: ColorStyles.greyBDBDBD,
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'on_inspection'.tr(),
                                            style: CustomTextStyle.white_11,
                                          ),
                                        ),
                                      ),
                                    )
                                  ] else ...[
                                    ScaleButton(
                                      onTap: () async {
                                        if (user!.canAppellate!) {
                                          final sendForVerificationSuccess =
                                              await Repository()
                                                  .sendForVerification(
                                                      BlocProvider.of<
                                                                  ProfileBloc>(
                                                              context)
                                                          .access,
                                                      user!.id!);
                                          if (sendForVerificationSuccess) {
                                            if (!context.mounted) return;

                                            BlocProvider.of<ProfileBloc>(
                                                    context)
                                                .setUser(user);
                                            setState(() {
                                              user!.copyWith(
                                                  verifyStatus: "Progress");
                                            });
                                          }
                                        }
                                      },
                                      bound: 0.02,
                                      child: Container(
                                        height: 22.h,
                                        width: 86.w,
                                        decoration: BoxDecoration(
                                          color: user?.canAppellate ?? false
                                              ? ColorStyles.yellowFFCA0D
                                              : ColorStyles.greyBDBDBD,
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'send'.tr(),
                                            style: CustomTextStyle
                                                .black_11_w400_171716
                                                .copyWith(
                                                    color: user?.canAppellate ??
                                                            false
                                                        ? (user?.verifyStatus ==
                                                                "Progress"
                                                            ? Colors.white
                                                            : Colors.black)
                                                        : Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h),
                child: Container(
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
                          'general_settings'.tr(),
                          style: CustomTextStyle.black_16_w600_171716,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRoute.editBasicInfo);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'basic_information'.tr(),
                                          style: CustomTextStyle
                                              .black_13_w400_171716,
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'change_profile_name'.tr(),
                                            style: CustomTextStyle.grey12w400,
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
                          Navigator.of(context)
                              .pushNamed(AppRoute.editIdentityInfo);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/shield_tick.svg',
                                color: ColorStyles.yellowFFCA0D,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'security'.tr(),
                                          style: CustomTextStyle
                                              .black_13_w400_171716,
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'change_phone_number'.tr(),
                                            style: CustomTextStyle.grey12w400,
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
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.h, vertical: 11.h),
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
                                  'upload_a_resume'.tr(),
                                  style: CustomTextStyle.blue12w400,
                                ),
                                SizedBox(
                                  width: 80.h,
                                ),
                                Text(
                                  '.doc, .pdf',
                                  style: CustomTextStyle.grey12w400,
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
                                launch(user!.cvLink!.contains(server)
                                    ? user!.cvLink!
                                    : server + user!.cvLink!);
                              },
                              child: Container(
                                height: 50.h,
                                width: 120.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black)
                                    ],
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
                                      style:
                                          CustomTextStyle.black_11_w400_171716,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  user?.cv = null;
                                  user?.cvLink = null;
                                  user?.cvType = null;
                                  BlocProvider.of<ProfileBloc>(context)
                                      .setUser(user);
                                  BlocProvider.of<ProfileBloc>(context).add(
                                    UpdateProfileCvEvent(
                                        file: null,
                                        images: user!.images!
                                            .where((e) => e.linkUrl != null)
                                            .map((e) => e.linkUrl!)
                                            .toList()),
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
                              'your_categories'.tr(),
                              style: CustomTextStyle.black_16_w600_171716,
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 25.w),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: CustomTextStyle.blue14w400336FEE,
                                ),
                                onPressed: () {
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
                                    'selection_of_up_to_3_categories'.tr(),
                                    typeCategories,
                                  );
                                },
                                key: _categoryButtonKey,
                                child: Text('change'.tr()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.h),
                      if (user != null && typeCategories.isEmpty)
                        SizedBox(height: 6.h),
                      if (user != null && typeCategories.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'you_have_not_selected_any_categories'.tr(),
                            style: CustomTextStyle.grey14w400,
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
                              var category = listCategories.firstWhere(
                                  (element) =>
                                      element.description ==
                                      typeCategories[index]);

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
                                'your_work_experience'.tr(),
                                style: CustomTextStyle.black_16_w600_171716,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: CustomTextStyle.blue14w400336FEE,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      change = true;
                                    });
                                  },
                                  child: Text('change'.tr()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          minLines: 5,
                          enabled: change,
                          autocorrect: true,
                          textCapitalization: TextCapitalization.sentences,
                          focusNode: focusNode,
                          decoration: InputDecoration.collapsed(
                            hintText:
                                "describe_your_work_experience_and_attach_images"
                                    .tr(),
                            border: InputBorder.none,
                            hintStyle: CustomTextStyle.grey14w400,
                          ),
                          controller: experienceController,
                          style: CustomTextStyle.black_14_w400_515150,
                          maxLines: null,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(250)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${experienceController.text.length}/250',
                              style: CustomTextStyle.grey12w400,
                            )
                          ],
                        ),
                        if ((user?.images?.isNotEmpty ?? false) && change)
                          SizedBox(
                            width: 400.w,
                            child: const Divider(
                              color: ColorStyles.greyD9D9D9,
                              thickness: 1,
                            ),
                          ),
                        if (user?.images?.isNotEmpty ?? false)
                          SizedBox(
                            height: 5.h,
                          ),
                        if (user?.images?.isNotEmpty ?? false)
                          Builder(builder: (context) {
                            return SizedBox(
                              height: user!.images!.isEmpty ? 0 : 82.h,
                              width: !change ? 300.w : double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: openImages
                                    ? const ClampingScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      if (change)
                                        GestureDetector(
                                          onTap: () async {
                                            photos.removeAt(index);
                                            user!.images!.removeAt(index);
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 60.w),
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
                                          launch(user!.images![index].linkUrl!
                                                  .contains(server)
                                              ? user!.images![index].linkUrl!
                                              : server +
                                                  user!
                                                      .images![index].linkUrl!);
                                        },
                                        child: SizedBox(
                                          width: 80.h,
                                          height: 65.h,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5.w, left: 7.w),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  child: SizedBox(
                                                    width: 65.h,
                                                    height: 65.h,
                                                    child: user!.images![index]
                                                                .byte !=
                                                            null
                                                        ? Image.memory(
                                                            user!.images![index]
                                                                .byte!,
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
                                                                    .images![
                                                                        index]
                                                                    .linkUrl!
                                                                    .contains(
                                                                        server)
                                                                ? user!
                                                                    .images![
                                                                        index]
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
                                              if (index == 3 &&
                                                  !openImages &&
                                                  user!.images!.length > 4)
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      openImages = true;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.w, left: 7.w),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        child: Container(
                                                          width: 65.h,
                                                          height: 65.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: ColorStyles
                                                                .black
                                                                .withOpacity(
                                                                    0.4),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                                  '+ ${user!.images!.length - 4}',
                                                                  style: CustomTextStyle
                                                                      .white_16_w600)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                itemCount: user!.images!.length,
                              ),
                            );
                          }),
                        if (change)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                change = false;
                              });
                              if (user!.activity != experienceController.text) {
                                user!.activity = experienceController.text;
                              }
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(UpdateProfileEvent(user));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 15),
                              child: Text(
                                'save'.tr(),
                                style: CustomTextStyle.blue14w400336FEE,
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
                              'images'.tr(),
                              style: CustomTextStyle.blue12w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (user?.images?.isNotEmpty ?? false)
                      SizedBox(
                        width: user!.rus! ? 121.w : 100,
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
                                style: CustomTextStyle.white_11
                                    .copyWith(fontSize: 10.sp),
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
                  BlocProvider.of<ProfileBloc>(context).logout();
                  BlocProvider.of<ProfileBloc>(context).setUser(null);
                  BlocProvider.of<ChatBloc>(context).add(CloseSocketEvent());
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
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
                          'log_out_of_your_account'.tr(),
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
                    if (user!.isBanned!) {
                      banDialog(context, 'your_profile_is_blocked'.tr());
                    } else {
                      await Repository().deleteProfile(
                          BlocProvider.of<ProfileBloc>(context).access!);
                      if (!context.mounted) return;

                      BlocProvider.of<ProfileBloc>(context).logout();
                      BlocProvider.of<ProfileBloc>(context).setUser(null);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoute.home, (route) => false);
                    }
                  },
                  child: Center(
                    child: Text(
                      'delete_account'.tr(),
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

  Widget _categoryItem(TaskCategory activitiy, int index) {
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
              Flexible(
                child: Image.network(
                  server + activitiy.photo!,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            SizedBox(width: 10.w),
            Text(
              user?.rus ?? true
                  ? activitiy.description ?? ''
                  : activitiy.engDescription ?? '',
              style: CustomTextStyle.black_11_w400_171716,
            ),
          ],
        ),
      ),
    );
  }
}
