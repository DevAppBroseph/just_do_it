import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:scale_button/scale_button.dart';

Widget itemFavouriteUser(
    FavoriteCustomers user, Function(FavoriteCustomers) onSelect) {
  return Padding(
    padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 15.w),
    child: ScaleButton(
      bound: 0.02,
      onTap: () => onSelect(user),
      child: Container(
        decoration: BoxDecoration(
          color: LightAppColors.whitePrimary,
          borderRadius: BorderRadius.circular(20.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: ColorStyles.shadowFC6554,
          //     offset: const Offset(0, 4),
          //     blurRadius: 45.r,
          //   )
          // ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            if (user.user!.photo != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(1000.r),
                child: Image.network(
                  user.user!.photo!,
                  height: 48.h,
                  width: 48.w,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 260,
                    child: Text(
                      '${user.user!.firstname ?? '-'} ${user.user!.lastname ?? '-'}',
                      style: CustomTextStyle.sf18w800(
                              LightAppColors.blackSecondary)
                          .copyWith(fontWeight: FontWeight.w600),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10.w,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: LightAppColors.greySecondary,
                size: 15.h,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
