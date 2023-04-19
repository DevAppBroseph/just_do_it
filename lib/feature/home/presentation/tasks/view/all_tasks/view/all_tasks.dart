import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';

class AllTasksView extends StatefulWidget {
  const AllTasksView({super.key});

  @override
  State<AllTasksView> createState() => _AllTasksViewState();
}

class _AllTasksViewState extends State<AllTasksView> {
  List<Task> taskList = [];

  @override
  void initState() {
    super.initState();
    getListTask();
  }

  void getListTask() async {
    List<Task> res = await Repository()
        .getMyTaskList(BlocProvider.of<ProfileBloc>(context).access!);
    taskList.clear();
    taskList.addAll(res.reversed);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.keyboard_backspace_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Все задания',
                          style: CustomTextStyle.black_21_w700_171716,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height - 20.h - 10.h - 77.h,
                  child: ListView.builder(
                    itemCount: taskList.length,
                    padding: EdgeInsets.only(top: 15.h, bottom: 100.h),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return itemTask(taskList[index]);
                    },
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
              child: CustomButton(
                onTap: () {},
                btnColor: ColorStyles.yellowFFD70A,
                textLabel: Text(
                  'Создать новое',
                  style: CustomTextStyle.black_15_w600_171716,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemTask(Task task) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
      child: ScaleButton(
        bound: 0.01,
        child: Container(
          height: 100.h,
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
          width: 327.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
            child: Row(
              children: [
                Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: server + task.activities!.photo!,
                      height: 34.h,
                      width: 34.h,
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 235.w,
                      child: Text(
                        task.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: CustomTextStyle.black_13_w500_171716,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 235.w,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.region,
                                style: CustomTextStyle.black_11_w400,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                task.dateEnd,
                                style: CustomTextStyle.grey_11_w400,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'до ${task.priceTo} ₽',
                            style: CustomTextStyle.black_13_w500_171716,
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
}
