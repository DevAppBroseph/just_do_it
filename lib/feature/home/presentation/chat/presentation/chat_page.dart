import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';

class ChatPage extends StatefulWidget {
  final Function()? onBackPressed;
  final Function(int) onSelect;

  const ChatPage(this.onBackPressed, this.onSelect, {super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    getInitMessage();
  }

  void getInitMessage() async {
    BlocProvider.of<ChatBloc>(context).add(GetListMessage());
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 66.h),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 28.w),
              child: Row(
                children: [
                  if (widget.onBackPressed != null)
                    CustomIconButton(
                      onBackPressed: widget.onBackPressed!,
                      icon: SvgImg.arrowRight,
                    ),
                  if (widget.onBackPressed != null) SizedBox(width: 15.w),
                  const Spacer(),
                  Text(
                    'message'.tr(),
                    style: CustomTextStyle.black_22_w700,
                  ),
                  const Spacer(),
                  SizedBox(width: 23.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoute.menu,
                          arguments: [(page) {}, false]).then((value) {
                        if (value != null) {
                          if (value == 'create') {
                            widget.onSelect(0);
                          }
                          if (value == 'search') {
                            widget.onSelect(1);
                          }
                          if (value == 'chat') {
                            widget.onSelect(3);
                          }
                        }
                      });
                    },
                    child: SvgPicture.asset('assets/icons/category.svg'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) {
                  log('message $current');
                  if (current is UpdateListMessageState) return true;
                  return false;
                },
                builder: (context, snapshot) {
                  List<ChatList> listChat =
                      BlocProvider.of<ChatBloc>(context).chatList;
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: listChat.length,
                    itemBuilder: ((context, index) {
                      return itemChatMessage(listChat[index]);
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemChatMessage(ChatList chat) {
    final user = BlocProvider.of<ProfileBloc>(context).user;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () async {
          final chatBloc = BlocProvider.of<ChatBloc>(context);
          chatBloc.editShowPersonChat(false);
          chatBloc.editChatId(chat.id);
          chatBloc.messages = [];
          await Navigator.of(context).pushNamed(
            AppRoute.personalChat,
            arguments: [
              '${chat.id}',
              chat.chatWith != null && chat.chatWith!.firstname!.isEmpty
                  ? ''
                  : '${chat.chatWith?.firstname} ${chat.chatWith?.lastname}',
              '${chat.chatWith?.id}',
              '${chat.chatWith?.photo}',
            ],
          );
          chatBloc.editShowPersonChat(true);
          chatBloc.editChatId(null);
          getInitMessage();
        },
        duration: const Duration(milliseconds: 50),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  chat.chatWith?.photo != null
                      ? SizedBox(
                          height: 50.h,
                          width: 50.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: CachedNetworkImage(
                              imageUrl: '$server${chat.chatWith!.photo}',
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
                                child:
                                    SvgPicture.asset('assets/icons/user.svg'),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(width: 12.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 255.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180.w,
                                child: AutoSizeText(
                                  chat.chatWith != null &&
                                          chat.chatWith!.firstname!.isEmpty
                                      ? 'Аккаунт удален'
                                      : '${chat.chatWith?.firstname} ${chat.chatWith?.lastname}',
                                  style: CustomTextStyle.black_14_w400_000000,
                                  maxLines: 1,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _textData(chat.lastMsg?.time
                                        ?.toUtc()
                                        .toString()
                                        .substring(0, 10) ??
                                    '-'),
                                style: CustomTextStyle.grey_12_w400,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  chat.lastMsg?.text ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyle.black_14_w400_171716,
                                ),
                              ),
                              if (chat.lastMsg?.unread != null &&
                                  chat.lastMsg!.unread! &&
                                  (user != null &&
                                      user.id != chat.lastMsg?.sender?.id) &&
                                  chat.countUnreadMessage != 0)
                                Container(
                                  height: 15.h,
                                  width: 15.h,
                                  decoration: BoxDecoration(
                                    color: ColorStyles.yellowFFCA0D,
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      chat.countUnreadMessage?.toString() ?? '',
                                      style: CustomTextStyle.white_10_w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.h,
                      color: ColorStyles.greyF7F7F8,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _textData(String data) {
    String text = '';
    String day = '';
    String month = '';
    String year = '';
    List<String> parts = [];
    parts = data.split('-');
    year = parts[0].trim();
    day = parts[2].trim();
    month = parts[1].trim();

    text = '$day.$month.$year';
    return text;
  }
}
