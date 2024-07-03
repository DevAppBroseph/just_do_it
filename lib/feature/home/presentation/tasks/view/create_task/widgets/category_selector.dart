import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/formatter_upper.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/task/task_subcategory.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:open_file/open_file.dart';
import 'package:scale_button/scale_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CategorySelector extends StatefulWidget {
  TextEditingController titleController;
  TextEditingController aboutController;
  TaskCategory? selectCategory;
  bool customer;
  TaskSubcategory? selectSubCategory;
  double bottomInsets;
  Function onAttach;
  List<ArrayImages> document;
  Function(int?, int?) removefiles;
  Function(TaskCategory?, TaskSubcategory?, String?, String?) onEdit;
  CategorySelector({
    super.key,
    required this.titleController,
    required this.aboutController,
    required this.onEdit,
    required this.selectCategory,
    required this.selectSubCategory,
    required this.bottomInsets,
    required this.onAttach,
    required this.customer,
    required this.document,
    required this.removefiles,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<TaskCategory> activities = [];

  bool openCategory = false;
  bool openSubCategory = false;
  late UserRegModel? user;
  final ScrollController _categoryController = ScrollController();
  final ScrollController _subCategoryController = ScrollController();

  @override
  void initState() {
    super.initState();
    activities.addAll(BlocProvider.of<AuthBloc>(context).categories);
    user = BlocProvider.of<ProfileBloc>(context).user;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          ScaleButton(
            onTap: () {
              setState(() {
                openCategory = !openCategory;
                openSubCategory = false;
              });
            },
            bound: 0.02,
            child: Container(
              height: 50.h,
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'category'.tr(),
                        style: CustomTextStyle.sf15w400(
                            LightAppColors.greySecondary),
                      ),
                      SizedBox(height: 3.h),
                      if (widget.selectCategory != null)
                        Text(
                          user?.rus ?? true
                              ? widget.selectCategory!.description!
                              : widget.selectCategory!.engDescription!,
                          style: SettingsScope.themeOf(context).theme.getStyle(
                              (lightStyles) => lightStyles.sf17w400BlackSec,
                              (darkStyles) => darkStyles.sf17w400BlackSec),
                        ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(SvgImg.arrowRight)
                ],
              ),
            ),
          ),
          SizedBox(height: 9.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: openCategory
                ? (activities.length < 5)
                    ? activities.length * 40.h
                    : 200.h
                : 0.h,
            decoration: BoxDecoration(
              color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                  ? DarkAppColors.blackSurface
                  : LightAppColors.whitePrimary,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: LightAppColors.shadowPrimary,
                  offset: const Offset(0, -4),
                  blurRadius: 55.r,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
            child: Scrollbar(
              thumbVisibility: true,
              controller: _categoryController,
              child: ListView(
                shrinkWrap: true,
                controller: _categoryController,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: activities
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: GestureDetector(
                          onTap: () {
                            if (e.id == widget.selectCategory?.id) {
                              widget.selectCategory = null;
                            } else {
                              widget.selectCategory = e;
                            }
                            openSubCategory = false;
                            widget.selectSubCategory = null;
                            setState(() {});
                            widget.onEdit(
                              widget.selectCategory,
                              widget.selectSubCategory,
                              widget.titleController.text,
                              widget.aboutController.text,
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 40.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 250.w,
                                      child: Text(
                                        user?.rus ?? true
                                            ? e.description ?? '-'
                                            : e.engDescription ?? '',
                                        style: SettingsScope.themeOf(context)
                                            .theme
                                            .getStyle(
                                                (lightStyles) => lightStyles
                                                    .sf17w400BlackSec,
                                                (darkStyles) => darkStyles
                                                    .sf17w400BlackSec),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (e.id == widget.selectCategory?.id)
                                      const Icon(Icons.check)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: 9.h),
          ScaleButton(
            onTap: () {
              if (widget.selectCategory != null) {
                setState(() {
                  openSubCategory = !openSubCategory;
                  openCategory = false;
                });
              } else {
                setState(() {
                  openSubCategory = false;
                });
              }
            },
            bound: 0.02,
            child: Container(
              height: 50.h,
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'subcategory'.tr(),
                        style: CustomTextStyle.sf15w400(
                            LightAppColors.greySecondary),
                      ),
                      SizedBox(height: 3.h),
                      if (widget.selectSubCategory != null)
                        SizedBox(
                          width: 240.w,
                          child: Text(
                            user?.rus ?? true
                                ? widget.selectSubCategory?.description ?? '-'
                                : widget.selectSubCategory?.engDescription ??
                                    '-',
                            style: SettingsScope.themeOf(context)
                                .theme
                                .getStyle(
                                    (lightStyles) =>
                                        lightStyles.sf17w400BlackSec,
                                    (darkStyles) =>
                                        darkStyles.sf17w400BlackSec),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(SvgImg.arrowRight)
                ],
              ),
            ),
          ),
          SizedBox(height: 9.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: openSubCategory
                ? (widget.selectCategory!.subcategory.length < 5)
                    ? widget.selectCategory!.subcategory.length * 40.h
                    : 200.h
                : 0.h,
            decoration: BoxDecoration(
              color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                  ? DarkAppColors.blackSurface
                  : LightAppColors.whitePrimary,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: LightAppColors.shadowPrimary,
                  offset: const Offset(0, -4),
                  blurRadius: 55.r,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
            child: Scrollbar(
              thumbVisibility: true,
              controller: _subCategoryController,
              child: ListView(
                shrinkWrap: true,
                controller: _subCategoryController,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: widget.selectCategory?.subcategory
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: GestureDetector(
                              onTap: () {
                                if (e.id == widget.selectSubCategory?.id) {
                                  widget.selectSubCategory = null;
                                } else {
                                  widget.selectSubCategory = e;
                                }
                                setState(() {});
                                widget.onEdit(
                                  widget.selectCategory,
                                  widget.selectSubCategory,
                                  widget.titleController.text,
                                  widget.aboutController.text,
                                );
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: 40.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 250.w,
                                          child: Text(
                                            user?.rus ?? true
                                                ? e.description ?? '-'
                                                : e.engDescription ?? '-',
                                            style: SettingsScope.themeOf(
                                                    context)
                                                .theme
                                                .getStyle(
                                                    (lightStyles) => lightStyles
                                                        .sf17w400BlackSec,
                                                    (darkStyles) => darkStyles
                                                        .sf17w400BlackSec),
                                          ),
                                        ),
                                        const Spacer(),
                                        if (e.id ==
                                            widget.selectSubCategory?.id)
                                          const Icon(Icons.check)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList() ??
                    [],
              ),
            ),
          ),
          SizedBox(height: 9.h),
          ScaleButton(
            onTap: () {},
            bound: 0.02,
            child: Container(
              height: 50.h,
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CustomTextField(
                onTap: () {
                  openSubCategory = false;
                  openCategory = false;
                  setState(() {});
                },
                style: SettingsScope.themeOf(context).theme.getStyle(
                    (lightStyles) => lightStyles.sf17w400BlackSec,
                    (darkStyles) => darkStyles.sf17w400BlackSec),
                hintText:
                    widget.customer ? 'task_name'.tr() : 'offer_name'.tr(),
                textEditingController: widget.titleController,
                fillColor:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                onChanged: (value) {
                  widget.onEdit(
                    widget.selectCategory,
                    widget.selectSubCategory,
                    widget.titleController.text,
                    widget.aboutController.text,
                  );
                },
                formatters: [
                  UpperEveryTextInputFormatter(),
                ],
              ),
            ),
          ),
          SizedBox(height: 18.h),
          ScaleButton(
            onTap: () {},
            bound: 0.02,
            child: Container(
              height: 130.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              decoration: BoxDecoration(
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CustomTextField(
                autocorrect: true,
                maxLines: 8,
                onTap: () {
                  openSubCategory = false;
                  openCategory = false;
                  setState(() {});
                },
                hintText: widget.customer
                    ? 'description_task'.tr()
                    : 'description_offer'.tr(),
                style: SettingsScope.themeOf(context).theme.getStyle(
                    (lightStyles) => lightStyles.sf17w400BlackSec,
                    (darkStyles) => darkStyles.sf17w400BlackSec),
                textEditingController: widget.aboutController,
                fillColor:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                onChanged: (value) {
                  widget.onEdit(
                    widget.selectCategory,
                    widget.selectSubCategory,
                    widget.titleController.text,
                    widget.aboutController.text,
                  );
                },
                formatters: [
                  UpperEveryTextInputFormatter(),
                ],
              ),
            ),
          ),
          SizedBox(height: 18.h),
          GestureDetector(
            onTap: () => widget.onAttach(),
            child: CustomTextField(
              fillColor:
                  SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                      ? DarkAppColors.blackSurface
                      : LightAppColors.whitePrimary,
              hintText: 'attach_doc'.tr(),
              hintStyle: CustomTextStyle.sf15w400(LightAppColors.greySecondary),
              height: 50.h,
              enabled: false,
              suffixIcon: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          SvgImg.gallery,
                          height: 15.h,
                          width: 15.h,
                        ),
                        if (widget.document.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 5.w),
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
              textEditingController: TextEditingController(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            ),
          ),
          SizedBox(height: 15.h),
          SingleChildScrollView(
            child: SizedBox(
              height: 60.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.document.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  bool file = false;
                  if (widget.document[index].linkUrl != null &&
                      (widget.document[index].linkUrl!.contains('.png') ||
                          widget.document[index].linkUrl!.contains('.jpg') ||
                          widget.document[index].linkUrl!.contains('.jpeg'))) {
                    file = false;
                  } else if (widget.document[index].linkUrl != null &&
                      (widget.document[index].linkUrl!.contains('.pdf') ||
                          widget.document[index].linkUrl!.contains('.doc') ||
                          widget.document[index].linkUrl!.contains('.docx'))) {
                    file = true;
                  } else if (widget.document[index].type == 'pdf' ||
                      widget.document[index].type == 'doc' ||
                      widget.document[index].type == 'docx') {
                    file = true;
                  }

                  if (file) {
                    return SizedBox(
                      height: 60.h,
                      width: 60.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (widget.document[index].file != null) {
                                OpenFile.open(
                                    widget.document[index].file!.path);
                              } else {
                                launch(widget.document[index].linkUrl!
                                        .contains(server)
                                    ? widget.document[index].linkUrl!
                                    : server + widget.document[index].linkUrl!);
                              }
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
                                widget.removefiles(null, index);
                              },
                              child: Container(
                                height: 15.h,
                                width: 15.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black)
                                    ],
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
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      if (widget.document[index].file != null) {
                        OpenFile.open(widget.document[index].file!.path);
                      } else {
                        launch(widget.document[index].linkUrl!.contains(server)
                            ? widget.document[index].linkUrl!
                            : server + widget.document[index].linkUrl!);
                      }
                    },
                    child: SizedBox(
                      height: 60.h,
                      width: 60.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 50.h,
                            width: 50.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: widget.document[index].byte != null
                                  ? Image.memory(
                                      widget.document[index].byte!,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.document[index].linkUrl!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                widget.removefiles(index, null);
                              },
                              child: Container(
                                height: 15.h,
                                width: 15.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black)
                                    ],
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
                  );
                },
              ),
            ),
          ),
          SizedBox(height: widget.bottomInsets)
        ],
      ),
    );
  }
}
