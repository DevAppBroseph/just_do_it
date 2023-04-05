import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

class PersonalChat extends StatefulWidget {
  int chatId;
  PersonalChat(this.chatId, {super.key});
  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  ScrollController scrollController = ScrollController();
  bool sending = false;
  TextEditingController msg = TextEditingController();
  bool emptyMessage = true;
  @override
  void initState() {
    BlocProvider.of<ChatBloc>(context).add(LoadChatEvent(
        BlocProvider.of<ProfileBloc>(context).access, widget.chatId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: ColorStyles.whiteFFFFFF,
      body: BlocBuilder<ChatBloc, ChatState>(builder: (context, snapshot) {
        if (snapshot is LoadingChatState) {
          return const CupertinoActivityIndicator();
        }
        Chat chat = BlocProvider.of<ChatBloc>(context).chat!;
        return Column(
          children: [
            SizedBox(height: 66.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Transform.rotate(
                    angle: pi,
                    child: SvgPicture.asset('assets/icons/arrow_right.svg'),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${chat.chatWith.firstname} ${chat.chatWith.lastname}',
                  style: CustomTextStyle.black_21_w700,
                ),
                const Spacer(),
                SvgPicture.asset('assets/icons/more-circle.svg'),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: chat.messagesList.length,
                reverse: true,
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.w),
                itemBuilder: ((context, index) {
                  return message(chat.messagesList[index]);
                }),
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            Container(
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
                      height: 56.h,
                      child: Stack(
                        children: [
                          CustomTextField(
                            width: 327.w,
                            height: 56.h,
                            hintText: 'Введите сообщение',
                            textEditingController: msg,
                            fillColor: ColorStyles.greyF9F9F9,
                            onChanged: (String text) {
                              if (msg.text.isNotEmpty && emptyMessage) {
                                setState(() {
                                  emptyMessage = false;
                                });
                              } else if (msg.text.isEmpty && !emptyMessage) {
                                setState(() {
                                  emptyMessage = true;
                                });
                              }
                            },
                            // onTap: () {
                            // Future.delayed(const Duration(milliseconds: 400),
                            //     () {
                            //   scrollController.animateTo(
                            //     scrollController.position.maxScrollExtent,
                            //     duration: const Duration(milliseconds: 100),
                            //     curve: Curves.linear,
                            //   );
                            // });
                            // },
                            contentPadding: EdgeInsets.only(
                                left: 16.w,
                                top: 20.h,
                                bottom: 20.h,
                                right: 90.h),
                          ),
                          SizedBox(
                            width: 327.w,
                            height: 56.h,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/add.svg',
                                    color: ColorStyles.greyBDBDBD,
                                  ),
                                  SizedBox(width: 8.w),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/icons/send-2.svg',
                                      color: emptyMessage
                                          ? ColorStyles.black515150
                                          : ColorStyles.yellowFFCA0D,
                                    ),
                                    onPressed: () async {
                                      await Repository().sendMessage(
                                          msg.text,
                                          BlocProvider.of<ProfileBloc>(context)
                                              .access,
                                          chat.chatWith.id);
                                    },
                                  ),
                                  SizedBox(width: 9.w),
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
            // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        );
      }),
    );
  }

  Widget message(Message msg) {
    UserRegModel user = BlocProvider.of<ProfileBloc>(context).user!;

    return user.id != msg.sender.id
        ? Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(20.r),
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            color: ColorStyles.greyF6F7F7,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: msg.sender.photo == null
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: SvgPicture.asset(
                                          'assets/icons/user.svg'),
                                    ),
                                  ],
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      'http://$server${msg.sender.photo!}',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.h),
                    Column(
                      children: [
                        CupertinoCard(
                          radius: BorderRadius.circular(25.r),
                          color: ColorStyles.greyF9F9F9,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.w),
                            child: Text(msg.text),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          DateFormat('kk:mm').format(msg.time),
                          style: CustomTextStyle.grey_11_w400DADADA,
                        ),
                      ],
                    )
                  ],
                )),
          )
        : Padding(
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
                            horizontal: 16.w, vertical: 16.w),
                        child: Text(msg.text),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      DateFormat('kk:mm').format(msg.time),
                      style: CustomTextStyle.grey_11_w400DADADA,
                    ),
                  ],
                )),
          );
  }
}
