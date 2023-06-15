import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
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
import 'package:just_do_it/feature/home/presentation/tasks/view/task_additional.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';

import '../../../../../models/order_task.dart';
import '../../../../../network/repository.dart';

class Contractor extends StatefulWidget {
  final Size size;
  Function(int) callBacK;
  Function() callBackFlag;
  Contractor({super.key, required this.size, required this.callBacK, required this.callBackFlag});

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
    user = BlocProvider.of<ProfileBloc>(context).user;
    getListTask();
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
    context.read<TasksBloc>().add(
          GetTasksEvent(
            access: access,
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
    List<Task> res = await Repository().getMyTaskList(BlocProvider.of<ProfileBloc>(context).access!, true);
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
          BlocBuilder<ProfileBloc, ProfileState>(buildWhen: (previous, current) {
            if (current is UpdateProfileEvent) {
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
                    height: 245.h,
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
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return const OrdersCreateAsCustomerView(
                                  title: 'Мои задания',
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
                                            'Мои задания',
                                            style: CustomTextStyle.black_13_w400_171716,
                                          ),
                                          SizedBox(
                                            width: 235.w,
                                            child: Text(
                                              'Созданные мной в качестве заказчика',
                                              style: CustomTextStyle.grey_12_w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (user?.countOrdersCreateAsCustomer != null)
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user!.countOrdersCreateAsCustomer.toString(),
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
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return const ResponseTasksInProgressViewAsCustomer(
                                  title: 'Выполняемые',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Выполняемые',
                                            style: CustomTextStyle.black_13_w400_171716,
                                          ),
                                          SizedBox(
                                            width: 235.w,
                                            child: Text(
                                              'Задания, на которые получены отклики и подтверждение выбора исполнителя',
                                              style: CustomTextStyle.grey_12_w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (user?.countOrdersInProgressAsCustomer != null)
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user!.countOrdersInProgressAsCustomer.toString(),
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
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return const ResponseTasksCompleteViewAsCustomer(
                                  title: 'Закрытые',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Закрытые',
                                            style: CustomTextStyle.black_13_w400_171716,
                                          ),
                                          SizedBox(
                                            width: 235.w,
                                            child: Text(
                                              'Выполненные задания',
                                              style: CustomTextStyle.grey_12_w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (user?.countOrdersCompleteACustomer != null)
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user!.countOrdersCompleteACustomer.toString(),
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
                    height: 175.h,
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
                            'Отклики на офферы',
                            style: CustomTextStyle.black_16_w600_515150,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return const SelectedOffersAsCustomer(
                                  title: 'Принятые офферы',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Принятые офферы',
                                            style: CustomTextStyle.black_13_w400_171716,
                                          ),
                                          SizedBox(
                                            width: 235.w,
                                            child: Text(
                                              'Я сделал отклик на оффер',
                                              style: CustomTextStyle.grey_12_w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                        if (user?.selectedOffersAsCustomer != null)
                                      Padding(
                                        padding: EdgeInsets.only(right: 6.w),
                                        child: SizedBox(
                                          width: 35.w,
                                          child: Text(
                                            user!.selectedOffersAsCustomer!.length.toString(),
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
                            onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return const FinishedOffersViewAsCustomer(
                                  title: 'Закрытые офферы',
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Закрытые офферы',
                                            style: CustomTextStyle.black_13_w400_171716,
                                          ),
                                          SizedBox(
                                            width: 235.w,
                                            child: Text(
                                              'Выполненные задания',
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
                                          user?.finishedOffersAsCustomer != null
                                                  ? user!.finishedOffersAsCustomer!.length.toString()
                                                  : '0',
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
                                  title: 'Избранные офферы',
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
                                          'Офферы',
                                          style: CustomTextStyle.black_13_w400_171716,
                                        ),
                                      ),
                                      BlocBuilder<FavouritesBloc, FavouritesState>(builder: (context, state) {
                                        if (state is FavouritesLoaded) {
                                          final favouritesOrders = state.favourite!.favouriteOffers;
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
                                  title: 'Избранные исполнители',
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
                                          'Исполнители',
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
                        return CeateTasks(
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
                  'Создать задание',
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
