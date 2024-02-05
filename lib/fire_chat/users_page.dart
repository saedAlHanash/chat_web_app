import 'package:chat_web_app/app_widget.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive/hive.dart';
import 'package:image_multi_type/circle_image_widget.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/round_image_widget.dart';

import '../go_route_pages.dart';
import 'chat_card_widget.dart';
import 'get_chats_rooms_bloc/get_rooms_cubit.dart';
import 'my_students/bloc/chat_users_cubit/chat_users_cubit.dart';
import 'my_students/data/response/chat_users_response.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    context.read<ChatUsersCubit>().getChatUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: DrawableText(
          text: isTeacher ? 'طلابي' : "أساتذتي",
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ChatUsersCubit, ChatUsersInitial>(
        builder: (context, state) {
          if (state.statuses.loading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state.result.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageMultiType(
                    url: Icons.supervised_user_circle_outlined,
                    height: 100.0,
                    width: 100.0,
                  ),
                  DrawableText(
                    textAlign: TextAlign.center,
                    text:
                        'عذرًا، لا يوجد أي دورة نشطة حاليًا أو مشتركين في المحادثة. يُرجى التأكد من أنك مشترك في دورة قبل محاولة إنشاء محادثة.'
                        '\n إذا كنت قد تمت دعوتك إلى دورة معينة، يرجى الانتظار حتى يتم إضافتك إليها من',
                  )
                ],
              ),
            );
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

  Future<void> onTapUser() async {
    if (loading) return;
    setState(() => loading = true);
    final room =
        await context.read<GetRoomsCubit>().getRoomByUser(widget.user.id.toString());

    setState(() => loading = false);
    if (context.mounted && room != null) {
      if (context.mounted) {
        openRoomFunction(context, room);
      }
    } else {
      // Get.showSnackbar(const GetSnackBar(
      //   title: 'المستخدم غير موجود ',
      //   message: 'لم يقم المستخدم بتسجيل الدخول بعد تحديث التطبيق',
      //   backgroundColor: Colors.black54,
      //   duration: Duration(seconds: 5),
      //   borderRadius: 25,
      //   snackPosition: SnackPosition.TOP,
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.photo);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ListTile(
        onTap: onTapUser,
        horizontalTitleGap: 15.w,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0).r,
        title: Text(
          widget.user.getName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: loading
            ? const CircularProgressIndicator.adaptive()
            : CircleImageWidget(
                size: 50.0.r,
                url: widget.user.photo,
              ),
        trailing: SizedBox(
          width: 1.0.sw / 4.2,
          child: ImageMultiType(
            url: Icons.arrow_forward_ios_outlined,
            height: 12.0.r,
            width: 12.0.r,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
