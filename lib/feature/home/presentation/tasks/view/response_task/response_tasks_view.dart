import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class SelectedOffersAsCustomer extends StatefulWidget {
  final bool asCustomer;
  final String title;
  const SelectedOffersAsCustomer(
      {super.key, required this.asCustomer, required this.title});

  @override
  State<SelectedOffersAsCustomer> createState() =>
      _SelectedOffersAsCustomerState();
}

class _SelectedOffersAsCustomerState extends State<SelectedOffersAsCustomer> {
  List<Task> taskList = [];
  Task? selectTask;
  Owner? owner;
  late UserRegModel? user;
  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<ProfileBloc>(context).user;
    getListTask();
  }

  void getListTask() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    taskList = BlocProvider.of<TasksBloc>(context).tasks;
    return Scaffold(
      backgroundColor: ColorStyles.greyEAECEE,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: MediaQuery(
              data: const MediaQueryData(textScaleFactor: 1.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorStyles.greyEAECEE,
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
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.title,
                              style: CustomTextStyle.black_22_w700_171716,
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
                            child: ListView.builder(
                              itemCount: user?.selectedOffersAsCustomer?.length,
                              padding:
                                  EdgeInsets.only(top: 15.h, bottom: 100.h),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (user?.selectedOffersAsCustomer != []) {
                                  return itemTask(
                                      user!.selectedOffersAsCustomer![index],
                                      (task) {
                                    setState(() {
                                      selectTask = task;
                                    });
                                  }, user!, context);
                                }
                                return Container();
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
          backgroundColor: ColorStyles.greyEAECEE,
          body: ProfileView(owner: owner!));
    }
    if (selectTask != null) {
      return Scaffold(
        backgroundColor: ColorStyles.greyEAECEE,
        body: TaskPage(
          task: selectTask!,
          openOwner: (owner) {
            this.owner = owner;
            setState(() {});
          },
          canEdit: false,
        ),
      );
    }
    return Container();
  }
}
