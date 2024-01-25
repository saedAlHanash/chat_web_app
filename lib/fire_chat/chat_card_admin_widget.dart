import 'package:chat_web_app/fire_chat/chat_card_widget.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:chat_web_app/fire_chat/src/chat_theme.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:drawable_text/drawable_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:hive/hive.dart';
import 'package:image_multi_type/circle_image_widget.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/round_image_widget.dart';

import '../../main.dart';
import 'get_chats_rooms_bloc/get_rooms_cubit.dart';

class ChatCardAdminWidget extends StatefulWidget {
  final Room room;

  const ChatCardAdminWidget({
    super.key,
    required this.room,
  });

  @override
  State<ChatCardAdminWidget> createState() => _ChatCardAdminWidgetState();
}

class _ChatCardAdminWidgetState extends State<ChatCardAdminWidget> {
  Future<void> openRoom(
    BuildContext context,
  ) async {
    if (context.mounted) {
      context.read<GetRoomsCubit>().state.stream?.pause();
      openRoomFunction(context, widget.room).then((value) {
        print('sa_____________________________________________________________');
        roomMessage?.close();
        context.read<GetRoomsCubit>().state.stream?.resume();
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openRoom(context),
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.1,
              blurRadius: 8,
              offset: const Offset(0, 10), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        margin:
            EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 162.4),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 6,
              height: MediaQuery.of(context).size.width / 6,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: const Color(0xFFFFC107)),
              ),
              alignment: Alignment.center,
              child: const CircleImageWidget(
                url: Icons.group,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawableText(
                  size: 12.0,
                  text: widget.room.users.first.lastName.toString(),
                  drawableStart: const ImageMultiType(
                    url: Icons.person,
                    color: Colors.black,
                    height: 20.0,
                    width: 20.0,
                  ),
                ),
                DrawableText(
                  size: 12.0,
                  text: widget.room.users.last.lastName.toString(),
                  drawableStart: const ImageMultiType(
                    url: Icons.person,
                    color: primary,
                    height: 20.0,
                    width: 20.0,
                  ),
                ),
                const Divider(),
                DrawableText(
                  color: Colors.grey,
                  size: 10.0,
                  text: DateTime.fromMillisecondsSinceEpoch(
                          widget.room.updatedAt ?? DateTime.now().millisecond)
                      .formatDuration(),
                )
              ],
            ),
            if (widget.room.isNotReed) ...[
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.circle,
                  color: secondaryDark,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
