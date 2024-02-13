import 'package:chat_web_app/fire_chat/chat_card_admin_widget.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:chat_web_app/fire_chat/messages_bloc/messages_cubit.dart';
import 'package:chat_web_app/fire_chat/rooms_bloc/rooms_cubit.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../fire_chat/chat_card_widget.dart';
import '../generated/assets.dart';
import 'chat.dart';
import 'my_students/bloc/chat_users_cubit/chat_users_cubit.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatUsersCubit, ChatUsersInitial>(
      listenWhen: (p, c) => c.statuses.done,
      listener: (context, state) async {},
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 100.0,
                  right: 29.0,
                  bottom: 40.0,
                ).r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13.0.r),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 16.0),
                  ],
                ),
                child: BlocBuilder<RoomsCubit, RoomsInitial>(
                  builder: (context, state) {
                    if (state.statuses.loading) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ImageMultiType(
                              url: Assets.svgMessage,
                              height: 100.0,
                              width: 100.0,
                            ),
                            DrawableText(
                              text: 'جاري التحميل يرجى الانتظار....',
                              drawablePadding: 10.0,
                              drawableEnd: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state.allRooms.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ImageMultiType(
                              url: Assets.svgMessage,
                              height: 100.0,
                              width: 100.0,
                            ),
                            DrawableText(text: 'يرجى إضافة محادثة للبدء')
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 5.0).r,
                      separatorBuilder: (context, i) {
                        return Divider(
                          color: Colors.grey[100],
                        );
                      },
                      itemCount: state.allRooms.length + 1,
                      itemBuilder: (context, i) {
                        if (state.allRooms.length == i) {
                          return BlocBuilder<ChatUsersCubit, ChatUsersInitial>(
                            builder: (context, state) {
                              if (state.statuses.loading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return TextButton(
                                onPressed: () {
                                  context.read<ChatUsersCubit>().getChatUsers(context);
                                },
                                child: DrawableText(
                                  selectable: false,
                                  text: 'تحديث المحادثات',
                                  drawableAlin: DrawableAlin.between,
                                  size: 18.0.sp,
                                  drawablePadding: 20.0.w,
                                  drawableEnd: const ImageMultiType(url: Icons.refresh),
                                ),
                              );
                            },
                          );
                        }
                        final openRoom = state.allRooms[i];
                        return isAdmin
                            ? ChatCardAdminWidget(room: openRoom)
                            : InkWell(
                                child: ChatCardWidget(room: openRoom),
                              );
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: BlocBuilder<MessagesCubit, MessagesInitial>(
                buildWhen: (p, c) => c.roomId != p.roomId && c.roomId == selectedId,
                builder: (context, state) {
                  if (state.roomId.isEmpty) return 0.0.verticalSpace;
                  return Container(
                    margin: const EdgeInsets.all(40.0).r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEAFF),
                      borderRadius: BorderRadius.circular(21.0.r),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: ChatPage(
                      room: state.room,
                      name: getChatMember(state.room.users).lastName ?? '',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
