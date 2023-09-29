import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/helpers/data_formatter.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:scale_button/scale_button.dart';

Widget itemFavouriteTask(FavouriteOffers task, Function(FavouriteOffers) onSelect) {
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
        height: 130.h,
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
                    if (task.order != null)
                      Row(
                        children: [
                          if(task.order?.category?.photo != null)
                          SizedBox(
                            width: 34.h,
                            height: 34.h,
                            child: Image.network(
                              task.order!.category!.photo!,
                              height: double.infinity,
                              width: double.infinity,
                            ),
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
                      task.order!.name!,
                      style: CustomTextStyle.black_14_w500_171716,
                      maxLines: 2,
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
                            SizedBox(
                              width: 245.w,
                              child: Text(
                                _textCountry(task),
                                style: CustomTextStyle.black_12_w500_515150,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              _textData(task.order!.dateStart!),
                              style: CustomTextStyle.grey_12_w400,
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 245.w,
                    child: Row(
                      children: [
                        const Spacer(),
                        Text(
                          'до ${DataFormatter.addSpacesToNumber(task.order!.priceTo)} ${DataFormatter.convertCurrencyNameIntoSymbol(task.order!.currency!.name)} ',
                          maxLines: 1,
                          style: CustomTextStyle.black_14_w500_171716,
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
    ),
  );
}
String _textData(String data){
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
String _textCountry(FavouriteOffers task) {
  var text = '';
  for (var country in task.order!.countries!) {
    text += '${country.name}, ';
  }
  for (var region in task.order!.regions!) {
    text += '${region.name}, ';
  }
  for (var town in task.order!.towns!) {
    text += '${town.name}, ';
  }
  if (text.isNotEmpty) text = text.substring(0, text.length - 2);
  if (text.isEmpty) text = 'Выбраны все страны';

  return text;
}