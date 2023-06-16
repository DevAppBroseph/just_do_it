import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply_from_favourite/reply_fav_bloc.dart' as rep;
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response_from_favourite/response_fav_bloc.dart'as res;
import 'package:just_do_it/feature/home/presentation/search/presentation/widget/sliding_panel_reply.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/widget/sliding_panel_reply_from_fav.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/widget/sliding_panel_response_from_fav.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_favourite_task.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FavouriteTasks extends StatefulWidget {
  final String title;
  final bool asCustomer;
  const FavouriteTasks({super.key, required this.title, required this.asCustomer});

  @override
  State<FavouriteTasks> createState() => _FavouriteTasksState();
}

class _FavouriteTasksState extends State<FavouriteTasks> {
  Task? selectTask;
  @override
  void initState() {
    super.initState();
  }

  Owner? owner;
  FavouriteOffers? selectFavouriteTask;
  List<FavouriteOffers>? favouritesOrders;
  PanelController panelControllerReplyFromFav = PanelController();
  PanelController panelControllerResponseFromFav = PanelController();
  @override
  void dispose() {
    if (panelControllerReplyFromFav.isPanelOpen) panelControllerReplyFromFav.close();
    if (panelControllerResponseFromFav.isPanelOpen) panelControllerResponseFromFav.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesBloc, FavouritesState>(builder: (context, state) {
      if (state is FavouritesLoaded) {
        if (widget.asCustomer == false) {
          favouritesOrders = state.favourite!.favouriteOffers;
        } else {
          favouritesOrders = state.favourite!.favouriteOrder;
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: ColorStyles.greyEAECEE,
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
                                  child: CustomIconButton(
                                    onBackPressed: () {
                                      if (owner != null) {
                                        owner = null;
                                        setState(() {});
                                      } else if (selectTask != null) {
                                        selectFavouriteTask = null;
                                        selectTask = null;
                                        // final access = BlocProvider.of<ProfileBloc>(context).access;
                                        // context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
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
                                  height: MediaQuery.of(context).size.height - 20.h - 10.h - 82.h,
                                  child: ListView.builder(
                                    itemCount: favouritesOrders!.length,
                                    padding: EdgeInsets.only(top: 15.h, bottom: 100.h),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return itemFavouriteTask(
                                        favouritesOrders![index],
                                        (task) {
                                          setState(() {
                                            selectFavouriteTask = task;
                                            if (selectFavouriteTask?.order != null) {
                                              getTask();
                                            }
                                          });
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
                    )
                  ],
                ),
              ),
              BlocBuilder<res.ResponseBlocFromFav, res.ResponseState>(
                builder: (context, snapshot) {
                  if (snapshot is res.OpenSlidingPanelState) {
                    selectTask = snapshot.selectTask;
                    panelControllerResponseFromFav.animatePanelToPosition(1.0);
                  } else if (snapshot is res.CloseSlidingPanelState) {
                    panelControllerResponseFromFav.animatePanelToPosition(0.0);
                  }
                  return SlidingPanelResponseFromFav(panelControllerResponseFromFav, selectTask: selectTask);
                },
              ),
              BlocBuilder<rep.ReplyFromFavBloc, rep.ReplyState>(
                builder: (context, snapshot) {
                  if (snapshot is rep.OpenSlidingPanelState) {
                    panelControllerReplyFromFav.animatePanelToPosition(1.0);
                  } else if (snapshot is rep.CloseSlidingPanelState) {
                    panelControllerReplyFromFav.animatePanelToPosition(0.0);
                  }
                  return SlidingPanelReplyFromFav(panelControllerReplyFromFav);
                },
              ),
            ],
          ),
        );
      }
      return Container(
        color: Colors.amber,
      );
    });
  }

  void getTask() async {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    final task = await Repository().getTaskById(selectFavouriteTask!.order!.id!, access);
    log(task.toString());
    setState(() {
      selectTask = task;
      log(selectTask!.isLiked.toString());
    });
  }

  Widget view() {
    if (owner != null) {
      return Scaffold(backgroundColor: ColorStyles.greyEAECEE, body: ProfileView(owner: owner!));
    }

    if (selectTask != null) {
      return Scaffold(
        backgroundColor: ColorStyles.greyEAECEE,
        body: TaskView(
          selectTask: selectTask!,
          openOwner: (owner) {
            this.owner = owner;
            setState(() {});
          },
          canEdit: false,
          canSelect: true,
          fromFav: true,
        ),
      );
    }
    return Container();
  }
}
