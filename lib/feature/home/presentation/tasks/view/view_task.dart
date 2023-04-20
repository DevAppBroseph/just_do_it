import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/models/task.dart';

class TaskView extends StatelessWidget {
  Task selectTask;
  TaskView({super.key, required this.selectTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                'Открыто',
                style: CustomTextStyle.grey_11_w400,
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Text(
            'до ${selectTask.priceTo} ₽',
            style: CustomTextStyle.black_16_w500_171716,
          ),
          SizedBox(height: 12.h),
          Text(
            selectTask.name,
            style: CustomTextStyle.black_16_w800_171716,
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Image.network(
                '$server ${selectTask.activities?.photo ?? ''}',
                height: 24.h,
              ),
              SizedBox(width: 8.h),
              Text(
                '${selectTask.activities?.description ?? '-'}, ${selectTask.subcategory?.description ?? '-'}',
                style: CustomTextStyle.black_12_w400_292D32,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            'Описание',
            style: CustomTextStyle.grey_12_w400,
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: ColorStyles.whiteFFFFFF,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: ColorStyles.shadowFC6554,
                  offset: const Offset(0, 4),
                  blurRadius: 45.r,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text(
              selectTask.description,
              style: CustomTextStyle.black_12_w400_292D32,
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              SizedBox(
                width: 150.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Регион',
                      style: CustomTextStyle.grey_12_w400,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      selectTask.region,
                      style: CustomTextStyle.black_12_w400_292D32,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 150.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Срок исполнения',
                      style: CustomTextStyle.grey_12_w400,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      selectTask.dateEnd,
                      style: CustomTextStyle.black_12_w400_292D32,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 50.h),
          Text(
            'Заказчик',
            style: CustomTextStyle.grey_12_w400,
          ),
          SizedBox(height: 6.h),
          Container(
            decoration: BoxDecoration(
              color: ColorStyles.whiteFFFFFF,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: ColorStyles.shadowFC6554,
                  offset: const Offset(0, 4),
                  blurRadius: 45.r,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
            child: Row(
              children: [
                if (selectTask.owner?.photo != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000.r),
                    child: Image.network(
                      selectTask.owner!.photo!,
                      height: 48.h,
                      width: 48.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selectTask.owner?.firstname ?? '-'} ${selectTask.owner?.lastname ?? '-'}',
                      style: CustomTextStyle.black_16_w600_171716,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          'Рейтинг',
                          style: CustomTextStyle.grey_12_w400,
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset('assets/icons/star.svg'),
                        SizedBox(width: 4.w),
                        Text(
                          '-',
                          style: CustomTextStyle.black_12_w500_171716,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 38.h),
          CustomButton(
            onTap: () {},
            btnColor: ColorStyles.yellowFFD70A,
            textLabel: Text(
              'Откликнуться',
              style: CustomTextStyle.black_14_w600_171716,
            ),
          )
        ],
      ),
    );
  }
}
