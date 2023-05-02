import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/models/task.dart';
import 'package:scale_button/scale_button.dart';

Widget itemTask(Task task, Function(Task) onSelect) {
  return Padding(
    padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
    child: ScaleButton(
      bound: 0.01,
      onTap: () => onSelect(task),
      child: Container(
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
        height: 115.h,
        width: 327.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.h,
                child: Column(
                  children: [
                    if (task.activities != null)
                      Row(
                        children: [
                          Image.network(
                            server + task.activities!.photo!,
                            height: 34.h,
                            width: 34.h,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 245.w,
                    child: Text(
                      task.name,
                      style: CustomTextStyle.black_14_w500_171716,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 245.w,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _textCountry(task),
                              style: CustomTextStyle.black_12_w500_515150,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              task.dateStart,
                              style: CustomTextStyle.grey_12_w400,
                            ),
                          ],
                        ),
                        const Spacer(),
                         if(task.currency?.name == null)
                          Text(
                            'до ${task.priceTo} ₽',
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                          if(task.currency?.name == 'Дирхам')
                          Text(
                            'до ${task.priceTo} AED',
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                          if(task.currency?.name == 'Российский рубль')
                          Text(
                            'до ${task.priceTo}  ₽',
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                          if(task.currency?.name == 'Доллар США')
                          Text(
                            'до ${task.priceTo} \$',
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                          if(task.currency?.name == 'Евро')
                          Text(
                            'до ${task.priceTo} €',
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                       
                        SizedBox(width: 5.w),
                        SvgPicture.asset(
                          'assets/icons/card.svg',
                          height: 16.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  
}

 String _textCountry(Task task){
    var text = '';
    for (var country in task.countries) {
      text += '${country.name}, ';
    }
    for (var region in task.regions) {
      text += '${region.name}, ';
    }
    for (var town in task.towns) {
      text += '${town.name}, ';
    }
    if(text.isNotEmpty) text = text.substring(0, text.length-2);
    if(text.isEmpty) text = 'Выбраны все страны';
   
   return text;
  }
