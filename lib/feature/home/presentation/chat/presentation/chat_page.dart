import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:scale_button/scale_button.dart';

class ChatPage extends StatefulWidget {
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
    final access = BlocProvider.of<ProfileBloc>(context).access;
    BlocProvider.of<ChatBloc>(context).add(GetListMessage(access!));
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
                  Text(
                    'Сообщения',
                    style: CustomTextStyle.black_21_w700,
                  ),
                  const Spacer(),
                  SizedBox(width: 23.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoute.menu);
                    },
                    child: SvgPicture.asset('assets/icons/category.svg'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () async {
          final chatBloc = BlocProvider.of<ChatBloc>(context);
          final profileBloc = BlocProvider.of<ProfileBloc>(context);
          chatBloc.editShowPersonChat(false);
          chatBloc.editChatId(chat.id);
          chatBloc.messages = [];
          await Navigator.of(context).pushNamed(
            AppRoute.personalChat,
            arguments: [
              '${chat.id}',
              '${chat.chatWith?.firstname ?? ''} ${chat.chatWith?.lastname ?? ''}',
              '${chat.chatWith?.id}'
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
                  chat.chatWith != null
                      ? SizedBox(
                          height: 50.h,
                          width: 50.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: CachedNetworkImage(
                              imageUrl: '$server/${chat.chatWith!.photo}',
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
                  SizedBox(
                    width: 265.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${chat.chatWith?.firstname ?? ''} ${chat.chatWith?.lastname ?? ''}',
                              style: CustomTextStyle.black_13_w400_000000,
                            ),
                            const Spacer(),
                            Text(
                              chat.lastMsg?.time
                                      ?.toUtc()
                                      .toString()
                                      .substring(0, 10) ??
                                  '-',
                              style: CustomTextStyle.grey_11_w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          chat.lastMsg?.text ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.black_13_w400_171716,
                        ),
                        SizedBox(height: 8.h),
                        // Text(
                        //   chat.typeWork,
                        //   style: CustomTextStyle.grey_13_w400,
                        // ),
                      ],
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
}
