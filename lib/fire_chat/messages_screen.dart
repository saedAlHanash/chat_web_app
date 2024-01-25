import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/app_widget.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../fire_chat/chat_card_widget.dart';
import '../fire_chat/get_chats_rooms_bloc/get_rooms_cubit.dart';
import '../fire_chat/my_students/bloc/chat_users_cubit/chat_users_cubit.dart';
import '../fire_chat/users_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../generated/assets.dart';
import '../go_route_pages.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (userTypeFromUrl == 'a')
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return UsersPage();
                    },
                  ));
                },
                child: ImageMultiType(url: Icons.person_add, color: mainColor),
              ),
            ),
      body: BlocListener<ChatUsersCubit, ChatUsersInitial>(
        listener: (context, state) {},
        child: BlocBuilder<GetRoomsCubit, GetRoomsInitial>(
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
              padding: const EdgeInsets.all(50.0),
              separatorBuilder: (context, i) {
                return Divider(
                  color: Colors.grey[100],
                );
              },
              itemCount: state.allRooms.length,
              itemBuilder: (context, i) {
                final openRoom = state.allRooms[i];
                return ChatCardWidget(
                  room: openRoom,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
