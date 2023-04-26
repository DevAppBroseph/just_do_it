import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:scale_button/scale_button.dart';

class DatePicker extends StatefulWidget {
  double bottomInsets;
  TextEditingController coastMinController;
  TextEditingController coastMaxController;
  Function(String?, DateTime?, DateTime?) onEdit;
  DateTime? startDate;
  DateTime? endDate;
  String? selectRegion;
  DatePicker({
    super.key,
    required this.onEdit,
    required this.bottomInsets,
    required this.coastMinController,
    required this.coastMaxController,
    required this.startDate,
    required this.endDate,
    required this.selectRegion,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  bool openRegion = false;
  ScrollController controller = ScrollController();

  void _showDatePicker(ctx, int index) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    color: Colors.white,
                    child: Row(
                      children: [
                        const Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          borderRadius: BorderRadius.zero,
                          child: Text(
                            'Готово',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.black),
                          ),
                          onPressed: () {
                            if (index == 0 && widget.startDate == null) {
                              widget.startDate = DateTime.now();
                            } else if (index == 1 && widget.endDate == null) {
                              widget.endDate = DateTime.now();
                            }
                            setState(() {});
                            Navigator.of(ctx).pop();
                            widget.onEdit(
                              widget.selectRegion,
                              widget.startDate,
                              widget.endDate,
                            );
                          },
                        ),
                        SizedBox(width: 5.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 200.h,
              color: Colors.white,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: index == 0
                      ? widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          )
                      : widget.endDate ??
                          widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                  minimumDate: index == 0
                      ? DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        )
                      : widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                  maximumDate: index == 0
                      ? widget.endDate ??
                          DateTime(
                            DateTime.now().year + 5,
                            DateTime.now().month,
                            DateTime.now().day,
                          )
                      : null,
                  onDateTimeChanged: (val) {
                    if (index == 0) {
                      widget.startDate = val;
                    } else if (index == 1) {
                      widget.endDate = val;
                    }
                    widget.onEdit(
                      widget.selectRegion,
                      widget.startDate,
                      widget.endDate,
                    );
                    setState(() {});
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        controller: controller,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          ScaleButton(
            bound: 0.02,
            onTap: () {
              _showDatePicker(context, 0);
            },
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Дата начала',
                        style: CustomTextStyle.grey_14_w400,
                      ),
                      SizedBox(height: 0.h),
                      if (widget.startDate != null)
                        Text(
                          DateFormat('dd.MM.yyyy').format(widget.startDate!),
                          // : 'Выберите дату начала выполнения',
                          style: CustomTextStyle.black_14_w400_171716,
                        ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/calendar.svg')
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 16.h),
              SvgPicture.asset('assets/icons/line.svg'),
            ],
          ),
          ScaleButton(
            bound: 0.02,
            onTap: () {
              _showDatePicker(context, 1);
            },
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Дата завершения',
                        style: CustomTextStyle.grey_14_w400,
                      ),
                      SizedBox(height: 0.h),
                      if (widget.endDate != null)
                        Text(
                          DateFormat('dd.MM.yyyy').format(widget.endDate!),
                          // : 'Выберите дату завершения задачи',
                          style: CustomTextStyle.black_14_w400_171716,
                        ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/calendar.svg')
                ],
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: ScaleButton(
                  bound: 0.02,
                  onTap: () {},
                  child: Container(
                    height: 55.h,
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    decoration: BoxDecoration(
                      color: ColorStyles.greyF9F9F9,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Бюджет от ₽',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            CustomTextField(
                              height: 20.h,
                              width: 80.w,
                              textInputType: TextInputType.number,
                              actionButton: false,
                              onTap: () {
                                setState(() {});
                              },
                              onChanged: (value) {
                                widget.onEdit(
                                  widget.selectRegion,
                                  widget.startDate,
                                  widget.endDate,
                                );
                              },
                              onFieldSubmitted: (value) {
                                setState(() {});
                              },
                              contentPadding: EdgeInsets.zero,
                              hintText: '',
                              fillColor: ColorStyles.greyF9F9F9,
                              maxLines: null,
                              style: CustomTextStyle.black_14_w400_171716,
                              textEditingController: widget.coastMinController,
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
                  onTap: () {},
                  child: Container(
                    height: 55.h,
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    decoration: BoxDecoration(
                      color: ColorStyles.greyF9F9F9,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Бюджет до ₽',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            CustomTextField(
                              height: 20.h,
                              width: 80.w,
                              actionButton: false,
                              textInputType: TextInputType.number,
                              onTap: () {
                                setState(() {});
                              },
                              onChanged: (value) {
                                widget.onEdit(
                                  widget.selectRegion,
                                  widget.startDate,
                                  widget.endDate,
                                );
                              },
                              onFieldSubmitted: (value) {
                                setState(() {});
                              },
                              contentPadding: EdgeInsets.zero,
                              hintText: '',
                              fillColor: ColorStyles.greyF9F9F9,
                              maxLines: null,
                              style: CustomTextStyle.black_14_w400_171716,
                              textEditingController: widget.coastMaxController,
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
          SizedBox(height: 18.h),
          ScaleButton(
            bound: 0.02,
            onTap: () {
              setState(() {
                openRegion = !openRegion;
              });
              FocusScope.of(context).unfocus();

              Future.delayed(Duration(milliseconds: 300), () {
                controller.animateTo(
                  controller.position.maxScrollExtent - 20.h,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.linear,
                );
              });
            },
            child: CustomTextField(
              fillColor: ColorStyles.greyF9F9F9,
              hintText: 'Выбрать регион',
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 55.h,
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
                          SvgImg.earth,
                          height: 15.h,
                          width: 15.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              textEditingController:
                  TextEditingController(text: widget.selectRegion ?? ''),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            ),
          ),
          SizedBox(height: 14.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: openRegion ? 200.h : 0.h,
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
              children: countryRussia
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.selectRegion == e) {
                            widget.selectRegion = null;
                          } else {
                            widget.selectRegion = e;
                          }
                          widget.onEdit(
                            widget.selectRegion,
                            widget.startDate,
                            widget.endDate,
                          );
                          setState(() {});
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
                                      e,
                                      style:
                                          CustomTextStyle.black_14_w400_515150,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (e == widget.selectRegion)
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
          SizedBox(height: 14.h),
          Row(
            children: [
              const Spacer(),
              SvgPicture.asset(SvgImg.help),
            ],
          ),
          SizedBox(height: 8.h),
          CustomButton(
            onTap: () {},
            btnColor: ColorStyles.purpleA401C4,
            textLabel: Text(
              'Поднять объявление наверх',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: widget.bottomInsets),
        ],
      ),
    );
  }
}
