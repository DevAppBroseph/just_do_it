import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/data_formatter.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:scale_button/scale_button.dart';

Widget itemTask(Task task, Function(Task) onSelect, UserRegModel? user,
    BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
    child: ScaleButton(
      bound: 0.01,
      onTap: () => onSelect(task),
      child: Container(
        decoration: BoxDecoration(
          color: task.isBanned == null || !task.isBanned!
              ? AppColors.whitePrimary
              : AppColors.greyBackdround.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10.r),
          // boxShadow: [
          // BoxShadow(
          //   color: ColorStyles.shadowFC6554,
          //   offset: const Offset(0, 8),
          //   blurRadius: 5.r,
          // )
          // ],
        ),
        height: 145.h,
        width: 327.h,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 16.h),
              child: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50.h,
                      child: Column(
                        children: [
                          if (task.category != null)
                            if (task.category?.photo != null)
                              SizedBox(
                                width: 34.h,
                                child: Image.network(
                                  task.category!.photo!,
                                  height: 34.h,
                                  width: 34.h,
                                ),
                              ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 230.w,
                              child: Text(
                                task.name,
                                style: CustomTextStyle.sf17w400(
                                  Colors.black,
                                ).copyWith(fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 230.w,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 230.w,
                                    child: Text(
                                      _textCountry(task, user),
                                      style: CustomTextStyle.sf17w400(
                                          AppColors.blackAccent),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    _textData(task.dateStart, user),
                                    style: CustomTextStyle.sf13w400(
                                        AppColors.greySecondary),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 230.w,
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                '${"before".tr()} ${_textCurrency(task.priceTo)} ${DataFormatter.convertCurrencyNameIntoSymbol(task.currency?.name)} ',
                                maxLines: 1,
                                style: CustomTextStyle.sf17w400(
                                  Colors.black,
                                ).copyWith(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 5.w),
                              SvgPicture.asset(
                                'assets/icons/card.svg',
                                height: 16.h,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            task.isGradedNow!
                ? GestureDetector(
                    onTap: () {
                      helpOnTopDialog(
                          context, 'raise_ad'.tr(), 'the_impact'.tr());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 100.h,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/arrow_up.svg',
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    ),
  );
}

String _textCurrency(int data) {
  if (data >= 1000) {
    var formatter = NumberFormat('#,###');

    return formatter.format(data).replaceAll(',', ' ');
  } else {
    return data.toString();
  }
}

String _textData(String data, UserRegModel? user) {
  String text = '';
  String day = '';
  String month = '';
  String year = '';
  List<String> parts = [];
  parts = data.split('-');
  year = parts[0].trim();
  day = parts[2].trim();
  month = parts[1].trim();

  text = '$day.$month.$year';
  return text;
}

String _textCountry(Task task, UserRegModel? user) {
  var text = '';
  for (var country in task.countries) {
    text += '${user?.rus ?? true ? country.name : country.engName}, ';
  }
  for (var region in task.regions) {
    text += '${user?.rus ?? true ? region.name : region.engName}, ';
  }
  for (var town in task.towns) {
    text += '${user?.rus ?? true ? town.name : town.engName}, ';
  }
  if (text.isNotEmpty) text = text.substring(0, text.length - 2);
  if (text.isEmpty) text = 'all_countries_selected'.tr();

  return text;
}
