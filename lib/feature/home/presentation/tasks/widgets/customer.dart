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
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/finished_offers_view.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/my_answers_as_executor_view.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/my_answers_selected_as_executor_view.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/open_offers_view.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/orders_complete_as_executor_view.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/response_task/selected_offers_view.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

class Customer extends StatefulWidget {
  final Function(int) callBacK;
  final Function() callBackFlag;

  const Customer({
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
  late UserRegModel? user;
  Task? selectTask;
  Owner? owner;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetCategorieProfileEvent());
    user = BlocProvider.of<ProfileBloc>(context).user;
    getListTask();
  }

  void getListTask() async {
    List<Task> res = await Repository()
        .getMyTaskList(BlocProvider.of<ProfileBloc>(context).access!, false);
    taskList.clear();
    taskList.addAll(res);
    setState(() {});
    widget.callBackFlag();
  }

  @override
  Widget build(BuildContext context) {
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
              if (current is UpdateProfileSuccessState) {
                user = BlocProvider.of<ProfileBloc>(context).user;
                return true;
              }
              if (current is LoadProfileSuccessState) {
                user = BlocProvider.of<ProfileBloc>(context).user;
                return true;
              }
              if (previous != current) {
                return true;
              }
              return true;
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
                        color: AppColors.whitePrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 20.w),
                            child: Text(
                              'my_tasks'.tr(),
                              style: CustomTextStyle.sf17w400(
                                  AppColors.blackAccent),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return MyAnswersAsExecutorView(
                                    title: 'all_responses'.tr(),
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
                                    'assets/icons/note2.svg',
                                    color: AppColors.yellowBackground,
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
                                              'all_responses'.tr(),
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'tasks_that_i_have_responded_to'
                                                    .tr(),
                                                style: CustomTextStyle.sf13w400(
                                                    AppColors.greySecondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user?.countMyAnswersAsExecutor !=
                                                      null
                                                  ? user!
                                                      .countMyAnswersAsExecutor
                                                      .toString()
                                                  : '0',
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
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
                                  return MyAnswersSelectedAsExecutorView(
                                    title: 'confirmed'.tr(),
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
                                    'assets/icons/clipboard-tick.svg',
                                    color: AppColors.yellowBackground,
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
                                              'confirmed'.tr(),
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'i_was_chosen_as_a_performer'
                                                    .tr(),
                                                style: CustomTextStyle.sf13w400(
                                                    AppColors.greySecondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user?.countMyAnswersSelectedAsExecutor !=
                                                      null
                                                  ? user!
                                                      .countMyAnswersSelectedAsExecutor
                                                      .toString()
                                                  : '0',
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
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
                                  return OrdersCompleteAsExecutorView(
                                    title: 'closed'.tr(),
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
                                    'assets/icons/document-like.svg',
                                    color: AppColors.yellowBackground,
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
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'tasks_that_were_completed_by_me'
                                                    .tr(),
                                                style: CustomTextStyle.sf13w400(
                                                    AppColors.greySecondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user?.countOrdersCompleteAsExecutor !=
                                                      null
                                                  ? user!
                                                      .countOrdersCompleteAsExecutor
                                                      .toString()
                                                  : '0',
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
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
                          SizedBox(height: 22.h),
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
                        color: AppColors.whitePrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 20.w),
                            child: GestureDetector(
                              onTap: () {
                                context
                                    .read<ProfileBloc>()
                                    .add(GetProfileEvent());
                              },
                              child: Text(
                                'my_offers'.tr(),
                                style: CustomTextStyle.sf17w400(
                                    AppColors.blackAccent),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return OpenOffers(title: 'open'.tr());
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
                                    color: AppColors.blueSecondary,
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
                                              'open'.tr(),
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'waiting_for_the_customer_response'
                                                    .tr(),
                                                style: CustomTextStyle.sf13w400(
                                                    AppColors.greySecondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user?.openOffers != null
                                                  ? user!.openOffers!.length
                                                      .toString()
                                                  : '0',
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
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
                                  return SelectedOffersView(
                                    title: 'accepted'.tr(),
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
                                    'assets/icons/tick-circle.svg',
                                    color: Colors.green,
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
                                              'accepted'.tr(),
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'there_is_a_response_from_the_customer'
                                                    .tr(),
                                                style: CustomTextStyle.sf13w400(
                                                    AppColors.greySecondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user?.selectedOffers != null
                                                  ? user!.selectedOffers!.length
                                                      .toString()
                                                  : '0',
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
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
                                  return FinishedOffers(
                                    title: 'closed'.tr(),
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
                                    'assets/icons/verify.svg',
                                    color: AppColors.purplePrimary,
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
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Text(
                                                'the_deal_has_been_implemented'
                                                    .tr(),
                                                style: CustomTextStyle.sf13w400(
                                                    AppColors.greySecondary),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 6.w),
                                          child: SizedBox(
                                            width: 35.w,
                                            child: Text(
                                              user?.finishedOffers != null
                                                  ? user!.finishedOffers!.length
                                                      .toString()
                                                  : '0',
                                              style: CustomTextStyle.sf17w400(
                                                  AppColors.blackSecondary),
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
                          SizedBox(height: 22.h),
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
                        color: AppColors.whitePrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, left: 20.w),
                            child: Text(
                              'favourites'.tr(),
                              style: CustomTextStyle.sf17w400(
                                  AppColors.blackAccent),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return FavouriteTasks(
                                    title: 'selected_tasks'.tr(),
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
                                    color: AppColors.greyActive,
                                  ),
                                  SizedBox(width: 3.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'tasks'.tr(),
                                            style: CustomTextStyle.sf17w400(
                                                AppColors.blackSecondary),
                                          ),
                                        ),
                                        BlocBuilder<FavouritesBloc,
                                                FavouritesState>(
                                            builder: (context, state) {
                                          if (state is FavouritesLoaded) {
                                            final favouritesOrders = state
                                                    .favourite
                                                    ?.favouriteOrder ??
                                                [];
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(right: 6.w),
                                              child: SizedBox(
                                                width: 35.w,
                                                child: Text(
                                                  favouritesOrders.length
                                                      .toString(),
                                                  style:
                                                      CustomTextStyle.sf17w400(
                                                          AppColors
                                                              .blackSecondary),
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
                                    title: 'selected_customers'.tr(),
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
                                    color: AppColors.greyActive,
                                  ),
                                  SizedBox(width: 3.w),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            'customers'.tr(),
                                            style: CustomTextStyle.sf17w400(
                                                AppColors.blackSecondary),
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
                                                  style:
                                                      CustomTextStyle.sf17w400(
                                                          AppColors
                                                              .blackSecondary),
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
                          SizedBox(height: 22.h),
                        ],
                      ),
                    ),
                  ),
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
                  btnColor: AppColors.yellowPrimary,
                  textLabel: Text(
                    'create_offer'.tr(),
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
