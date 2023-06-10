import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/view/create_task_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/favourite_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/favoutire_customer.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';

class Customer extends StatefulWidget {
  Function(int) callBacK;
  Function() callBackFlag;
  Customer({
    Key? key,
    required this.size,
    required this.callBacK,
    required this.callBackFlag,
  }) : super(key: key);

  final Size size;

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  List<Task> taskList = [];
  Task? selectTask;
  Owner? owner;
  @override
  void initState() {
    super.initState();
    getListTask();
  }

  void getListTask() async {
    List<Task> res = await Repository().getMyTaskList(BlocProvider.of<ProfileBloc>(context).access!, false);
    taskList.clear();
    taskList.addAll(res);
    setState(() {});
    widget.callBackFlag();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  bottom: 15.h,
                  right: 20.w,
                ),
                child: Container(
                  height: 230.h,
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
                          'Все задания',
                          style: CustomTextStyle.black_16_w600_515150,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/note2.svg',
                                color: ColorStyles.yellowFFCA0D,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Все отклики',
                                          style: CustomTextStyle.black_13_w400_171716,
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'Задания, на которые я откликнулся',
                                            style: CustomTextStyle.grey_12_w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.w),
                                      child: SizedBox(
                                        width: 35.w,
                                        child: Text(
                                          232.toString(),
                                          style: CustomTextStyle.black_13_w400_171716,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/clipboard-tick.svg',
                                color: ColorStyles.yellowFFCA0D,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Подтвержденные',
                                          style: CustomTextStyle.black_13_w400_171716,
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'Меня выбрали исполнителем',
                                            style: CustomTextStyle.grey_12_w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.w),
                                      child: SizedBox(
                                        width: 35.w,
                                        child: Text(
                                          133.toString(),
                                          style: CustomTextStyle.black_13_w400_171716,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/document-like.svg',
                                color: ColorStyles.yellowFFCA0D,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Закрытые',
                                          style: CustomTextStyle.black_13_w400_171716,
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'Задания, которые были выполнены мной',
                                            style: CustomTextStyle.grey_12_w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.w),
                                      child: SizedBox(
                                        width: 35.w,
                                        child: Text(
                                          400.toString(),
                                          style: CustomTextStyle.black_13_w400_171716,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
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
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  bottom: 15.h,
                  right: 20.w,
                ),
                child: Container(
                  height: 230.h,
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
                          'Мои офферы',
                          style: CustomTextStyle.black_16_w600_515150,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final res = await Navigator.of(context).pushNamed(AppRoute.allTasks, arguments: [false]);
                          if (res != null) {
                            if (res == true) {
                              widget.callBacK(1);
                            } else {
                              widget.callBacK(0);
                            }
                          }
                          getListTask();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/flash-circle.svg',
                                color: ColorStyles.blue336FEE,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Открытые',
                                          style: CustomTextStyle.black_13_w400_171716,
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'Ждут отклика заказчика',
                                            style: CustomTextStyle.grey_12_w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.w),
                                      child: SizedBox(
                                        width: 35.w,
                                        child: Text(
                                          taskList.length.toString(),
                                          style: CustomTextStyle.black_13_w400_171716,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/tick-circle.svg',
                                color: Colors.green,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Принятые',
                                          style: CustomTextStyle.black_13_w400_171716,
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'Есть отклик от заказчика',
                                            style: CustomTextStyle.grey_12_w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.w),
                                      child: SizedBox(
                                        width: 35.w,
                                        child: Text(
                                          '343',
                                          style: CustomTextStyle.black_13_w400_171716,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/verify.svg',
                                color: ColorStyles.purpleA401C4,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Закрытые',
                                          style: CustomTextStyle.black_13_w400_171716,
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'Сделка реализована',
                                            style: CustomTextStyle.grey_12_w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.w),
                                      child: SizedBox(
                                        width: 35.w,
                                        child: Text(
                                          '5',
                                          style: CustomTextStyle.black_13_w400_171716,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
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
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  bottom: 15.h,
                  right: 20.w,
                ),
                child: Container(
                  height: 150.h,
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
                          'Избранное',
                          style: CustomTextStyle.black_16_w600_515150,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return FavouriteTasks(
                                title: 'Избранные задачи',
                                asCustomer: true,
                              );
                            }),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/edit.svg',
                                color: ColorStyles.greyD9D9D9,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 235.w,
                                      child: Text(
                                        'Задачи',
                                        style: CustomTextStyle.black_13_w400_171716,
                                      ),
                                    ),
                                    BlocBuilder<FavouritesBloc, FavouritesState>(builder: (context, state) {
                                      if (state is FavouritesLoaded) {
                                        final favouritesOrders = state.favourite!.favouriteOrder;
                                        return Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              favouritesOrders!.length.toString(),
                                              style: CustomTextStyle.black_13_w400_171716,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return FavouriteCustomer(
                                title: 'Избранные заказчики',
                              );
                            }),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/user1.svg',
                                color: ColorStyles.greyD9D9D9,
                              ),
                              SizedBox(width: 3.w),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 235.w,
                                      child: Text(
                                        'Заказчики',
                                        style: CustomTextStyle.black_13_w400_171716,
                                      ),
                                    ),
                                    BlocBuilder<FavouritesBloc, FavouritesState>(builder: (context, state) {
                                      if (state is FavouritesLoaded) {
                                        final favouritesOrders = state.favourite!.favoriteUsers;
                                        return Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              favouritesOrders!.length.toString(),
                                              style: CustomTextStyle.black_13_w400_171716,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    }),
                                  ],
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
              // GestureDetector(
              //   onTap: () async {
              //     final res = await Navigator.of(context).pushNamed(AppRoute.allTasks, arguments: [false]);
              //     if (res != null) {
              //       if (res == true) {
              //         widget.callBacK(1);
              //       } else {
              //         widget.callBacK(0);
              //       }
              //     }
              //     getListTask();
              //   },
              //   child: Container(
              //     height: 55.h,
              //     width: widget.size.width,
              //     margin: EdgeInsets.symmetric(horizontal: 24.w),
              //     padding: EdgeInsets.symmetric(horizontal: 12.w),
              //     decoration: BoxDecoration(
              //       color: ColorStyles.yellowFFD70A,
              //       borderRadius: BorderRadius.circular(10.r),
              //     ),
              //     child: Row(
              //       children: [
              //         SvgPicture.asset(
              //           SvgImg.task,
              //           color: ColorStyles.black,
              //         ),
              //         SizedBox(width: 16.w),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               taskCounts(taskList.length),
              //               style: CustomTextStyle.black_14_w400_171716,
              //             ),
              //             Text(
              //               'Все офферы',
              //               style: CustomTextStyle.black_14_w400_171716,
              //             )
              //           ],
              //         ),
              //         const Spacer(),
              //         const Icon(
              //           Icons.keyboard_arrow_right_rounded,
              //           color: ColorStyles.whiteFFFFFF,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 16.h),
              // GestureDetector(
              //   onTap: () async {
              //     final res = await Navigator.of(context).pushNamed(AppRoute.archiveTasks, arguments: [false]);
              //     if (res != null) {
              //       if (res == true) {
              //         widget.callBacK(1);
              //       } else {
              //         widget.callBacK(0);
              //       }
              //     }
              //     getListTask();
              //   },
              //   child: Container(
              //     height: 55.h,
              //     width: widget.size.width,
              //     margin: EdgeInsets.symmetric(horizontal: 24.w),
              //     padding: EdgeInsets.symmetric(horizontal: 12.w),
              //     decoration: BoxDecoration(
              //       color: ColorStyles.yellowFFD70A,
              //       borderRadius: BorderRadius.circular(10.r),
              //     ),
              //     child: Row(
              //       children: [
              //         SvgPicture.asset(
              //           SvgImg.archive,
              //           color: ColorStyles.black,
              //         ),
              //         SizedBox(width: 16.w),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               taskCounts(taskList.length),
              //               style: CustomTextStyle.black_14_w400_171716,
              //             ),
              //             Text(
              //               'В архиве',
              //               style: CustomTextStyle.black_14_w400_171716,
              //             )
              //           ],
              //         ),
              //         const Spacer(),
              //         const Icon(
              //           Icons.keyboard_arrow_right_rounded,
              //           color: ColorStyles.whiteFFFFFF,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 50.h),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 24.w),
              //   child: Text(
              //     'Вы создали ${taskCounts(taskList.length)}',
              //     style: CustomTextStyle.black_18_w500_171716,
              //   ),
              // ),
              // SizedBox(height: 30.h),
              // Column(
              //   children: [
              //     itemButton(
              //       'Открыты',
              //       taskCounts(taskList.length),
              //       SvgImg.inProgress,
              //       () async {
              //         await Navigator.of(context).push(
              //           MaterialPageRoute(builder: (context) {
              //             return TaskAdditional(title: 'Открыты', asCustomer: false, scoreTrue: false);
              //           }),
              //         );
              //         getListTask();
              //       },
              //     ),
              //     Padding(
              //       padding: EdgeInsets.only(top: 18.h),
              //       child: const Divider(
              //         height: 1,
              //         indent: 20,
              //         endIndent: 20,
              //       ),
              //     ),
              //   ],
              // ),
              // Column(
              //   children: [
              //     SizedBox(height: 18.h),
              //     itemButton(
              //       'Невыполненные',
              //       taskCounts(taskList.length),
              //       SvgImg.close,
              //       () async {
              //         await Navigator.of(context).push(
              //           MaterialPageRoute(builder: (context) {
              //             return TaskAdditional(title: 'Невыполненные', asCustomer: false, scoreTrue: false);
              //           }),
              //         );
              //         getListTask();
              //       },
              //     ),
              //     Padding(
              //       padding: EdgeInsets.only(top: 18.h),
              //       child: const Divider(
              //         height: 1,
              //         indent: 20,
              //         endIndent: 20,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 100.h,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
              child: CustomButton(
                onTap: () async {
                  final res = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CeateTasks(
                          customer: false,
                          doublePop: true,
                          currentPage: 4,
                        );
                      },
                    ),
                  );
                  if (res != null) {
                    if (res == true) {
                      widget.callBacK(1);
                    } else {
                      widget.callBacK(0);
                    }
                  }

                  getListTask();
                },
                btnColor: ColorStyles.yellowFFD70A,
                textLabel: Text(
                  'Создать оффер',
                  style: CustomTextStyle.black_16_w600_171716,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
