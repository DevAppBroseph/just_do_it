import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/network/repository.dart';

class ListTasks extends StatefulWidget {
  const ListTasks({super.key});

  @override
  State<ListTasks> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  List<OrderTask> orderTask = [];

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  getOrders() async {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    orderTask.clear();
    List<OrderTask> tempList = await Repository().getListTasks(access ?? '');
    List<OrderTask> reversedList = List.from(tempList.reversed);
    orderTask = reversedList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text('Заказы'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {},
                child: Text('Создать create_task'.tr()),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: orderTask.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                      color: ColorStyles.whiteFFFFFF,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          orderTask[index].owner?.photo != null
                              ? SizedBox(
                                  height: 50.h,
                                  width: 50.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: CachedNetworkImage(
                                      imageUrl: orderTask[index].owner!.photo!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50.h,
                                  width: 50.h,
                                  decoration: BoxDecoration(
                                    color: ColorStyles.greyF6F7F7,
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 24.h,
                                        width: 24.h,
                                        child: SvgPicture.asset(
                                            'assets/icons/user.svg'),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 220.w,
                                child: Text(
                                    '${orderTask[index].owner?.firstname ?? '-'} ${orderTask[index].owner?.lastname ?? '-'}'),
                              ),
                              SizedBox(height: 10.h),
                              Text(orderTask[index].name ?? '-'),
                              Text(orderTask[index].description ?? '-'),
                            ],
                          ),
                          const Spacer(),
                          profileBloc.user?.id != orderTask[index].owner?.id
                              ? GestureDetector(
                                  onTap: () async {
                                    final chatBloc =
                                        BlocProvider.of<ChatBloc>(context);
                                    chatBloc.editShowPersonChat(false);
                                    chatBloc
                                        .editChatId(orderTask[index].chatId);
                                    chatBloc.messages = [];
                                    await Navigator.of(context).pushNamed(
                                      AppRoute.personalChat,
                                      arguments: [
                                        '${orderTask[index].chatId}',
                                        '${orderTask[index].owner?.firstname ?? ''} ${orderTask[index].owner?.lastname ?? ''}',
                                        '${orderTask[index].owner?.id}',
                                        '${orderTask[index].owner?.photo}',
                                      ],
                                    );
                                    chatBloc.editShowPersonChat(true);
                                    chatBloc.editChatId(null);
                                    getOrders();
                                  },
                                  child: const Icon(
                                    Icons.messenger,
                                    color: ColorStyles.yellowFFCA0D,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
