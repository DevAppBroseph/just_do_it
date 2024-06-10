import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/view/create_task_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/favourite_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/favoutire_customer.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/finished_offers_as_customer.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/orders_create_as_customer_view.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/response_tasks_complete_view_as_customer.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/response_tasks_in_progress_view_as_customer.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/response_tasks_view.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/user_reg.dart';

import '../../../../../models/order_task.dart';
import '../../../../../network/repository.dart';

class Contractor extends StatefulWidget {
  final Size size;
  final Function(int) callBacK;
  final Function() callBackFlag;
  const Contractor({
    super.key,
    required this.size,
    required this.callBacK,
    required this.callBackFlag,
  });

  @override
  State<Contractor> createState() => _ContractorState();
}

class _ContractorState extends State<Contractor> {
  List<Task> taskList = [];
  Task? selectTask;
  late UserRegModel? user;
  Owner? owner;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetCategorieProfileEvent());
    getListTask();
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
    context.read<TasksBloc>().add(
          GetTasksEvent(
            query: null,
            dateEnd: null,
            dateStart: null,
            priceFrom: null,
            priceTo: null,
            subcategory: [],
            countFilter: null,
            customer: null,
          ),
        );
  }

  void getListTask() async {
    List<Task> res = await Repository()
        .getMyTaskList(BlocProvider.of<ProfileBloc>(context).access!, true);
    taskList.clear();
    taskList.addAll(res);
    setState(() {});
    widget.callBackFlag();
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<ProfileBloc>(context).user;
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: BlocBuilder<TasksBloc, TasksState>(buildWhen: (previous, current) {
        if (current is UpdateTask) {
          return true;
        }
        if (previous != current) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        return Stack(
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) {
              if (current is LoadProfileSuccessState) {
                user = BlocProvider.of<ProfileBloc>(context).user;
                return true;
              }
              if (current is UpdateProfileSuccessState) {
                user = BlocProvider.of<ProfileBloc>(context).user;
                return true;
              }
              if (previous != current) {
                return true;
              }
              return false;
            }, builder: (context, data) {
              return ListView(
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
                              'my_tasks'.tr(),
                              style: CustomTextStyle.black16w600515150,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return OrdersCreateAsCustomerView(
                                      title: 'my_task'.tr());
                                }),
                              );
                            },
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'my_task'.tr(),
                                              style: CustomTextStyle
                                                  .black_13_w400_171716,
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'created_by_me_as_a_customer'
                                                    .tr(),
                                                style:
                                                    CustomTextStyle.grey12w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (user?.countOrdersCreateAsCustomer !=
                                            null)
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 6.w),
                                            child: SizedBox(
                                              width: 35.w,
                                              child: Text(
                                                user!
                                                    .countOrdersCreateAsCustomer
                                                    .toString(),
                                                style: CustomTextStyle
                                                    .black_13_w400_171716,
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
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return ResponseTasksInProgressViewAsCustomer(
                                    title: 'performed'.tr(),
                                    asCustomer: false,
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
                                    'assets/icons/clipboard-tick.svg',
                                    color: ColorStyles.yellowFFCA0D,
                                  ),
                                  SizedBox(width: 3.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'performed'.tr(),
                                              style: CustomTextStyle
                                                  .black_13_w400_171716,
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'tasks_for_which_responses'
                                                    .tr(),
                                                style:
                                                    CustomTextStyle.grey12w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (user?.countOrdersInProgressAsCustomer !=
                                            null)
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 6.w),
                                            child: SizedBox(
                                              width: 35.w,
                                              child: Text(
                                                user!
                                                    .countOrdersInProgressAsCustomer
                                                    .toString(),
                                                style: CustomTextStyle
                                                    .black_13_w400_171716,
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
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return ResponseTasksCompleteViewAsCustomer(
                                    title: 'closed'.tr(),
                                    asCustomer: false,
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
                                    'assets/icons/document-like.svg',
                                    color: ColorStyles.yellowFFCA0D,
                                  ),
                                  SizedBox(width: 3.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'closed'.tr(),
                                              style: CustomTextStyle
                                                  .black_13_w400_171716,
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'completed_task'.tr(),
                                                style:
                                                    CustomTextStyle.grey12w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (user?.countOrdersCompleteACustomer !=
                                            null)
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 6.w),
                                            child: SizedBox(
                                              width: 35.w,
                                              child: Text(
                                                user!
                                                    .countOrdersCompleteACustomer
                                                    .toString(),
                                                style: CustomTextStyle
                                                    .black_13_w400_171716,
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
                          SizedBox(height: 20.h),
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
                              'responses_to_offers'.tr(),
                              style: CustomTextStyle.black16w600515150,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return SelectedOffersAsCustomer(
                                    title: 'accepted_offers'.tr(),
                                    asCustomer: false,
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
                                    'assets/icons/flash-circle.svg',
                                    color: ColorStyles.blue336FEE,
                                  ),
                                  SizedBox(width: 3.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'accepted_offers'.tr(),
                                              style: CustomTextStyle
                                                  .black_13_w400_171716,
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'i_made_a_response_to_the_offer'
                                                    .tr(),
                                                style:
                                                    CustomTextStyle.grey12w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (user?.selectedOffersAsCustomer !=
                                            null)
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 6.w),
                                            child: SizedBox(
                                              width: 35.w,
                                              child: Text(
                                                user!.selectedOffersAsCustomer!
                                                    .length
                                                    .toString(),
                                                style: CustomTextStyle
                                                    .black_13_w400_171716,
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
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return FinishedOffersViewAsCustomer(
                                    title: 'closed_offers'.tr(),
                                    asCustomer: false,
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
                                    'assets/icons/verify.svg',
                                    color: ColorStyles.purpleA401C4,
                                  ),
                                  SizedBox(width: 3.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'closed_offers'.tr(),
                                              style: CustomTextStyle
                                                  .black_13_w400_171716,
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'completed_task'.tr(),
                                                style:
                                                    CustomTextStyle.grey12w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user?.finishedOffersAsCustomer !=
                                                      null
                                                  ? user!
                                                      .finishedOffersAsCustomer!
                                                      .length
                                                      .toString()
                                                  : '0',
                                              style: CustomTextStyle
                                                  .black_13_w400_171716,
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
                          SizedBox(height: 20.h),
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
                      // height: 150.h,
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
                              'favourites'.tr(),
                              style: CustomTextStyle.black16w600515150,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return FavouriteTasks(
                                    title: 'selected_offers'.tr(),
                                    asCustomer: false,
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
                                            'offers'.tr(),
                                            style: CustomTextStyle
                                                .black_13_w400_171716,
                                          ),
                                        ),
                                        BlocBuilder<FavouritesBloc,
                                                FavouritesState>(
                                            builder: (context, state) {
                                          if (state is FavouritesLoaded) {
                                            final favouritesOrders = state
                                                    .favourite
                                                    ?.favouriteOffers ??
                                                [];
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(right: 6.w),
                                              child: SizedBox(
                                                width: 35.w,
                                                child: Text(
                                                  favouritesOrders.length
                                                      .toString(),
                                                  style: CustomTextStyle
                                                      .black_13_w400_171716,
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
                                    title: 'selected_executors'.tr(),
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
                                            'executors'.tr(),
                                            style: CustomTextStyle
                                                .black_13_w400_171716,
                                          ),
                                        ),
                                        BlocBuilder<FavouritesBloc,
                                                FavouritesState>(
                                            builder: (context, state) {
                                          if (state is FavouritesLoaded) {
                                            final favouritesOrders = state
                                                    .favourite?.favoriteUsers ??
                                                [];
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(right: 6.w),
                                              child: SizedBox(
                                                width: 35.w,
                                                child: Text(
                                                  favouritesOrders.length
                                                      .toString(),
                                                  style: CustomTextStyle
                                                      .black_13_w400_171716,
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
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector(
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
                  //               contractorCountTask(taskList.length),
                  //               style: CustomTextStyle.black_14_w400_171716,
                  //             ),
                  //             Text(
                  //               'Все задания',
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
                  //     final res = await Navigator.of(context).pushNamed(AppRoute.archiveTasks, arguments: [true]);
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
                  //               contractorCountTask(taskList.length),
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
                  //     'Вас выбрали в ${contractorCountTaskYouChosen(taskList.length)}',
                  //     style: CustomTextStyle.black_18_w500_171716,
                  //   ),
                  // ),
                  // SizedBox(height: 30.h),
                  // Column(
                  //   children: [
                  //     itemButton(
                  //       'Выполняются',
                  //       contractorCountTask(taskList.length),
                  //       SvgImg.inProgress,
                  //       () async {
                  //         await Navigator.of(context).push(
                  //           MaterialPageRoute(builder: (context) {
                  //             return TaskAdditional(title: 'Выполняются', asCustomer: true, scoreTrue: false);
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
                  //       'Выполненные',
                  //       contractorCountTask(taskList.length),
                  //       SvgImg.complete,
                  //       () async {
                  //         await Navigator.of(context).push(
                  //           MaterialPageRoute(builder: (context) {
                  //             return TaskAdditional(title: 'Выполнены', asCustomer: true, scoreTrue: false);
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
                  //       'Ждут подтверждения',
                  //       contractorCountTask(taskList.length),
                  //       SvgImg.needSuccess,
                  //       () async {
                  //         await Navigator.of(context).push(
                  //           MaterialPageRoute(builder: (context) {
                  //             return TaskAdditional(title: 'Ждут подтверждения', asCustomer: true, scoreTrue: false);
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
              );
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
                child: CustomButton(
                  onTap: () async {
                    final res = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const CreateTaskPage(
                            customer: true,
                            doublePop: true,
                            currentPage: 3,
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
                    'сreate_a_task'.tr(),
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
