import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class PersonalChat extends StatefulWidget {
  String? id;
  String name;
  String idWithChat;
  String? image;

  PersonalChat(
    this.id,
    this.name,
    this.idWithChat,
    this.image,
  );
  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  GlobalKey iconBtn = GlobalKey();

  @override
  void initState() {
    super.initState();
    getInitMessage();
  }

  void getInitMessage() async {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    if (widget.id != null) {
      BlocProvider.of<ChatBloc>(context).add(GetListMessageItem(access!));
    }
    Future.delayed(Duration(milliseconds: 1000), () {
      BlocProvider.of<ChatBloc>(context).add(GetListMessageItem(access!));
    });
  }

  // @override
  // void didChangeDependencies() {
  //   final access = BlocProvider.of<ProfileBloc>(context).access;
  //   Future.delayed(Duration(milliseconds: 1000), () {
  //     BlocProvider.of<ChatBloc>(context).add(GetListMessageItem(access!));
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<ProfileBloc>(context).user;
    return Scaffold(
      backgroundColor: ColorStyles.whiteFFFFFF,
      body: Column(
        children: [
          SizedBox(height: 66.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                CustomIconButton(
                  onBackPressed: () => Navigator.of(context).pop(),
                  icon: SvgImg.arrowRight,
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          body: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 66.h),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 25.w, right: 28.w),
                                child: Row(
                                  children: [
                                    CustomIconButton(
                                      onBackPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: SvgImg.arrowRight,
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Профиль',
                                      style: CustomTextStyle.black_22_w700,
                                    ),
                                    const Spacer(),
                                    SizedBox(width: 30.w),
                                  ],
                                ),
                              ),
                              ProfileView(
                                  owner: Owner(
                                      id: int.parse(widget.idWithChat),
                                      firstname: null,
                                      lastname: null,
                                      photo: null)),
                            ],
                          ),
                        );
                      },
                    ));
                  },
                  child: SizedBox(
                    width: 240.w,
                    child: AutoSizeText(
                      // 'Яковлев Максим Алексеевич',
                      widget.name,
                      style: CustomTextStyle.black_22_w700,
                      maxLines: 1,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => iconSelectTranslate(
                    context,
                    getWidgetPosition(iconBtn),
                    (index) {
                      // Navigator.pop(context);
                    },
                  ),
                  child: Container(
                    color: Colors.white,
                    width: 30.w,
                    height: 30.h,
                    child: Icon(
                      Icons.more_vert_rounded,
                      key: iconBtn,
                    ),
                  ),
                ),
                // Container(
                //   height: 36.h,
                //   decoration: BoxDecoration(
                //     color: ColorStyles.whiteF5F5F5,
                //     borderRadius: BorderRadius.circular(8.r),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.all(10.h),
                //     child: Row(
                //       children: [
                //         // SvgPicture.asset('assets/icons/translate.svg'),
                //         // SizedBox(width: 8.h),
                //         Text(
                //           'Показать оригинал',
                //           style: CustomTextStyle.blue_13_w400_336FEE,
                //         )
                //       ],
                //     ),
                //   ),
                // )
                // SvgPicture.asset('assets/icons/more-circle.svg'),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) {
                if (current is UpdateListMessageItemState) {
                  widget.id =
                      BlocProvider.of<ChatBloc>(context).idChat.toString();
                  return true;
                } else if (current is UpdateListPersonState) {
                  final access = BlocProvider.of<ProfileBloc>(context).access;
                  BlocProvider.of<ChatBloc>(context)
                      .add(GetListMessageItem(access!));
                }
                return true;
              },
              builder: (context, snapshot) {
                List<ChatMessage> messages =
                    BlocProvider.of<ChatBloc>(context).messages;
                return GestureDetector(
                  onTap: () {
                    focusNode.unfocus();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    reverse: true,
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
                    itemBuilder: (context, index) {
                      if (user?.id != int.parse(messages[index].user.id)) {
                        return Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: Container(
                                      height: 40.h,
                                      width: 40.h,
                                      decoration: BoxDecoration(
                                        color: ColorStyles.greyE0E6EE,
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: widget.image != null
                                          ? widget.image != 'null'
                                              ? Image.network(
                                                  server + widget.image!,
                                                  fit: BoxFit.cover,
                                                )
                                              : null
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 8.h),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 250.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CupertinoCard(
                                            radius: BorderRadius.circular(25.r),
                                            color: ColorStyles.greyF9F9F9,
                                            margin: EdgeInsets.zero,
                                            elevation: 0,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 16.w,
                                              ),
                                              child: Text(
                                                messages[index].text,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          // Text(
                                          //   messages[index]
                                          //       .createdAt
                                          //       .toUtc()
                                          //       .toString(),
                                          //   style: CustomTextStyle.grey_11_w400DADADA,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CupertinoCard(
                                radius: BorderRadius.circular(25.r),
                                color: ColorStyles.greyF9F9F9,
                                margin: EdgeInsets.zero,
                                elevation: 0,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.w,
                                  ),
                                  child: Text(
                                    messages[index].text,
                                  ),
                                ),
                              ),
                              // SizedBox(height: 8.h),
                              // Text(
                              //   '${++index} минут назад',
                              //   style: CustomTextStyle.grey_11_w400DADADA,
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              focusNode.unfocus();
            },
            child: Container(
              height: 109.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: ColorStyles.whiteFFFFFF,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -4),
                    color: ColorStyles.shadowFC6554,
                    blurRadius: 55.r,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 19.h),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      width: 327.w,
                      height: 70.h,
                      child: Stack(
                        children: [
                          CustomTextField(
                            width: 327.w,
                            height: 70.h,
                            focusNode: focusNode,
                            actionButton: false,
                            hintText: 'Введите сообщение',
                            textEditingController: textController,
                            fillColor: ColorStyles.greyF9F9F9,
                            maxLines: 10,
                            onTap: () {
                              // Future.delayed(const Duration(milliseconds: 800),
                              //     () {
                              //   scrollController.animateTo(
                              //     scrollController.position.maxScrollExtent,
                              //     duration: const Duration(milliseconds: 100),
                              //     curve: Curves.linear,
                              //   );
                              // });
                            },
                            contentPadding: EdgeInsets.only(
                              left: 16.w,
                              top: 20.h,
                              bottom: 20.h,
                              right: 90.h,
                            ),
                          ),
                          SizedBox(
                            width: 327.w,
                            height: 56.h,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // SvgPicture.asset(
                                  //   'assets/icons/add.svg',
                                  //   color: ColorStyles.greyBDBDBD,
                                  // ),
                                  SizedBox(width: 18.w),
                                  GestureDetector(
                                    onTap: () {
                                      if (textController.text.isNotEmpty) {
                                        BlocProvider.of<ChatBloc>(context).add(
                                          SendMessageEvent(
                                            textController.text,
                                            widget.idWithChat,
                                            user!.id!.toString(),
                                          ),
                                        );
                                      }
                                      textController.text = '';
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/send-2.svg',
                                      color: ColorStyles.black515150,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
