import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:scale_button/scale_button.dart';

class Category extends StatefulWidget {
  TextEditingController titleController;
  TextEditingController aboutController;
  Activities? selectCategory;
  Subcategory? selectSubCategory;
  double bottomInsets;
  Function onAttach;
  Function(Activities?, Subcategory?, String?, String?) onEdit;
  Category({
    super.key,
    required this.titleController,
    required this.aboutController,
    required this.onEdit,
    required this.selectCategory,
    required this.selectSubCategory,
    required this.bottomInsets,
    required this.onAttach,
  });

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  Uint8List? attach;

  List<Activities> activities = [];

  bool openCategory = false;
  bool openSubCategory = false;

  @override
  void initState() {
    super.initState();
    activities.addAll(BlocProvider.of<AuthBloc>(context).activities);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
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
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Категория',
                        style: CustomTextStyle.grey_13_w400,
                      ),
                      SizedBox(height: 3.h),
                      if (widget.selectCategory != null)
                        Text(
                          widget.selectCategory!.description!,
                          style: CustomTextStyle.black_13_w400_171716,
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
            height: openCategory ? 200.h : 0.h,
            decoration: BoxDecoration(
              color: ColorStyles.whiteFFFFFF,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: ColorStyles.shadowFC6554,
                  offset: const Offset(0, -4),
                  blurRadius: 55.r,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
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
                                      e.description ?? '-',
                                      style:
                                          CustomTextStyle.black_13_w400_515150,
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
          SizedBox(height: 9.h),
          ScaleButton(
            onTap: () {
              if (widget.selectCategory != null) {
                setState(() {
                  openSubCategory = !openSubCategory;
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
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Подкатегория',
                        style: CustomTextStyle.grey_13_w400,
                      ),
                      SizedBox(height: 3.h),
                      if (widget.selectSubCategory != null)
                        Text(
                          widget.selectSubCategory?.description ?? '-',
                          style: CustomTextStyle.black_13_w400_171716,
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
            height: openSubCategory ? 200.h : 0.h,
            decoration: BoxDecoration(
              color: ColorStyles.whiteFFFFFF,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: ColorStyles.shadowFC6554,
                  offset: const Offset(0, -4),
                  blurRadius: 55.r,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
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
                                          e.description ?? '-',
                                          style: CustomTextStyle
                                              .black_13_w400_515150,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (e.id == widget.selectSubCategory?.id)
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
          SizedBox(height: 9.h),
          ScaleButton(
            onTap: () {},
            bound: 0.02,
            child: Container(
              height: 50.h,
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CustomTextField(
                hintText: 'Название вашей задачи',
                textEditingController: widget.titleController,
                fillColor: ColorStyles.greyF9F9F9,
                onChanged: (value) {
                  widget.onEdit(
                    widget.selectCategory,
                    widget.selectSubCategory,
                    widget.titleController.text,
                    widget.aboutController.text,
                  );
                },
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
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CustomTextField(
                maxLines: 8,
                hintText: 'Описание задачи',
                textEditingController: widget.aboutController,
                fillColor: ColorStyles.greyF9F9F9,
                onChanged: (value) {
                  widget.onEdit(
                    widget.selectCategory,
                    widget.selectSubCategory,
                    widget.titleController.text,
                    widget.aboutController.text,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 18.h),
          GestureDetector(
            onTap: () => widget.onAttach(),
            child: CustomTextField(
              fillColor: ColorStyles.greyF9F9F9,
              hintText: 'Прикрепить фото или документ',
              hintStyle: CustomTextStyle.grey_13_w400,
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
                        if (attach != null)
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
          SizedBox(height: widget.bottomInsets)
        ],
      ),
    );
  }
}
