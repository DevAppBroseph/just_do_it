import 'package:auto_size_text/auto_size_text.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:just_do_it/helpers/data_updater.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class PersonalChat extends StatefulWidget {
  String? id;
  String name;
  String idWithChat;
  String? image;
  int? categoryId;

  PersonalChat(this.id, this.name, this.idWithChat, this.image,
      {super.key, this.categoryId});

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
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    if (widget.id == "null") {
      final chatElementIndex = chatBloc.chatList.indexWhere(
          (element) => element.chatWith?.id == int.parse(widget.idWithChat));
      if (chatElementIndex != -1) {
        final chatId = chatBloc.chatList[chatElementIndex].id;
        widget.id = chatId.toString();
        chatBloc.editChatId(chatId);
      } else {
        chatBloc.editChatId(null);
      }
      chatBloc.messages = [];
    }

    if (widget.id != "null") {
      BlocProvider.of<ChatBloc>(context).add(GetListMessageItem());
      BlocProvider.of<ChatBloc>(context).add(GetListMessage());
    }
    chatBloc.editShowPersonChat(false);
  }

  void openProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          body: Container(
            color: AppColors.greyPrimary,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    color: AppColors.greyPrimary,
                    child: SizedBox(height: 66.h)),
                Container(
                  color: AppColors.greyPrimary,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 28.w),
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
                          'profile'.tr(),
                          style: CustomTextStyle.sf22w700(
                              AppColors.blackSecondary),
                        ),
                        const Spacer(),
                        SizedBox(width: 30.w),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: ProfileView(
                      owner: Owner(
                          id: int.parse(widget.idWithChat),
                          firstname: null,
                          lastname: null,
                          photo: null)),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<ProfileBloc>(context).user;
    return WillPopScope(
      onWillPop: () async {
        context.read<ChatBloc>().editShowPersonChat(true);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whitePrimary,
        body: Column(
          children: [
            SizedBox(height: 66.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  CustomIconButton(
                    onBackPressed: () {
                      context.read<ChatBloc>().editShowPersonChat(true);
                      Navigator.of(context).pop(widget.id);
                    },
                    icon: SvgImg.arrowRight,
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      if (widget.name.isNotEmpty) {
                        openProfile();
                      }
                    },
                    child: SizedBox(
                      width: 240.w,
                      child: AutoSizeText(
                        widget.name.isEmpty
                            ? 'account_deleted'.tr()
                            : widget.name,
                        style:
                            CustomTextStyle.sf22w700(AppColors.blackSecondary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => iconSelectTranslate(
                      context,
                      getWidgetPosition(iconBtn),
                      (index) {},
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
                  } else if (current is UpdateListPersonState) {
                    BlocProvider.of<ChatBloc>(context)
                        .add(GetListMessageItem());
                  }
                  return true;
                },
                builder: (context, state) {
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 24.w),
                      itemBuilder: (context, index) {
                        if (user?.id != int.parse(messages[index].user.id)) {
                          return Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (widget.name.isNotEmpty) {
                                          openProfile();
                                        }
                                      },
                                      child: ClipOval(
                                        child: Container(
                                          height: 40.h,
                                          width: 40.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.greyError,
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: widget.image != null
                                              ? !widget.image!.contains("null")
                                                  ? Image.network(
                                                      widget.image!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null
                                              : null,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.h),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: 250.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CupertinoCard(
                                              radius:
                                                  BorderRadius.circular(25.r),
                                              color: AppColors.greyActive,
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
                                  color: AppColors.greyActive,
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
                  color: AppColors.whitePrimary,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -4),
                      color: AppColors.shadowPrimary,
                      blurRadius: 55.r,
                    ),
                  ],
                ),
                child: widget.name.isEmpty
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          'you_can_t_write_to_the_interlocutor_because_he_deleted_his_account'
                              .tr(),
                          style:
                              CustomTextStyle.sf17w400(AppColors.blackAccent),
                          textAlign: TextAlign.center,
                        ),
                      ))
                    : Padding(
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
                                    hintText: 'enter_a_message'.tr(),
                                    textEditingController: textController,
                                    fillColor: AppColors.greyActive,
                                    maxLines: 10,
                                    onTap: () {},
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
                                          SizedBox(width: 18.w),
                                          GestureDetector(
                                            onTap: () {
                                              if (textController
                                                  .text.isNotEmpty) {
                                                // BlocProvider.of<ChatBloc>(context).messages.isEmpty
                                                BlocProvider.of<ChatBloc>(
                                                        context)
                                                    .add(
                                                  SendMessageEvent(
                                                      textController.text,
                                                      widget.idWithChat,
                                                      user!.id!.toString(),
                                                      categoryId:
                                                          widget.categoryId),
                                                );
                                                if (widget.id == "null") {
                                                  DataUpdater()
                                                      .updateTasksAndProfileData(
                                                          context);
                                                } else {
                                                  BlocProvider.of<ChatBloc>(
                                                          context)
                                                      .add(GetListMessage());
                                                }
                                              }
                                              textController.text = '';
                                            },
                                            child: SvgPicture.asset(
                                              'assets/icons/send-2.svg',
                                              color: AppColors.blackAccent,
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
          ],
        ),
      ),
    );
  }
}
