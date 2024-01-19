import 'package:chat_web_app/app_widget.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
import 'package:hive/hive.dart';
import 'package:image_multi_type/round_image_widget.dart';

import 'chat_card_widget.dart';
import 'get_chats_rooms_bloc/get_rooms_cubit.dart';
import 'my_students/bloc/chat_users_cubit/chat_users_cubit.dart';
import 'my_students/data/response/chat_users_response.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocBuilder<ChatUsersCubit, ChatUsersInitial>(
        builder: (context, state) {
          if (state.statuses.loading) {
            return const CircularProgressIndicator.adaptive();
          }
          return ListView.separated(
            itemCount: state.result.length,
            separatorBuilder: (context, i) {
              return Divider(
                color: Colors.grey[100],
              );
            },
            itemBuilder: (context, index) {
              final user = state.result[index];

              return UserItem(user: user);
            },
          );
        },
      ),
    );
  }
}

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});

  final MyChatUser user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (loading) return;
        setState(() => loading = true);
        final room =
            await context.read<GetRoomsCubit>().getRoomByUser(widget.user.id.toString());

        setState(() => loading = false);
        if (context.mounted && room != null) {
          roomMessage = await Hive.openBox<String>(room.id);
          if (context.mounted) {
            context.read<GetRoomsCubit>().state.stream?.pause();
            Navigator.pop(context);
            openRoomFunction(context, room).then((value) {
              roomMessage.close();
              context.read<GetRoomsCubit>().state.stream?.resume();
            });
          }
        } else {

        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 6,
              height: MediaQuery.of(context).size.width / 6,
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: loading
                  ? const CircularProgressIndicator.adaptive()
                  : RoundImageWidget(
                      url: widget.user.photo,
                      color: mainColor,
                      height: 50.0,
                      width: 50.0,
                    ),
            ),
            Text(widget.user.getName),
          ],
        ),
      ),
    );
  }
}
