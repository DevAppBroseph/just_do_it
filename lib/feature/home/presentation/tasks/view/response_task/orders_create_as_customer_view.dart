import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class OrdersCreateAsCustomerView extends StatefulWidget {
  final String title;
  const OrdersCreateAsCustomerView({super.key, required this.title});

  @override
  State<OrdersCreateAsCustomerView> createState() =>
      _OrdersCreateAsCustomerViewState();
}

class _OrdersCreateAsCustomerViewState
    extends State<OrdersCreateAsCustomerView> {
  Task? selectTask;
  Owner? owner;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightAppColors.greyPrimary,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
              child: Container(
                decoration: const BoxDecoration(
                  color: LightAppColors.greyPrimary,
                ),
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
                            child: CustomIconButton(
                              onBackPressed: () {
                                if (owner != null) {
                                  owner = null;
                                  setState(() {});
                                } else if (selectTask != null) {
                                  selectTask = null;
                                  setState(() {});
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              icon: SvgImg.arrowRight,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(GetProfileEvent());
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.title,
                                style: CustomTextStyle.sf22w700(
                                    LightAppColors.blackSecondary),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height -
                                20.h -
                                10.h -
                                82.h,
                            child: BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                final user = context.read<ProfileBloc>().user;
                                return ListView.builder(
                                  itemCount:
                                      user?.ordersCreateAsCustomer?.length,
                                  padding:
                                      EdgeInsets.only(top: 15.h, bottom: 100.h),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (user?.ordersCreateAsCustomer != []) {
                                      return itemTask(
                                          user!.ordersCreateAsCustomer![index],
                                          (task) {
                                        setState(() {
                                          selectTask = task;
                                        });
                                      }, user, context);
                                    }
                                    return Container();
                                  },
                                );
                              },
                            ),
                          ),
                          view(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget view() {
    if (owner != null) {
      return Scaffold(
          backgroundColor: LightAppColors.greyPrimary,
          body: ProfileView(owner: owner!));
    }
    if (selectTask != null) {
      return Scaffold(
        backgroundColor: LightAppColors.greyPrimary,
        body: TaskPage(
          task: selectTask!,
          openOwner: (owner) {
            this.owner = owner;
            setState(() {});
          },
          canEdit: true,
          showResponses: true,
        ),
      );
    }
    return Container();
  }
}
