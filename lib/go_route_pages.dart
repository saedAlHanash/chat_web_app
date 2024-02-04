import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'fire_chat/get_chats_rooms_bloc/get_rooms_cubit.dart';
import 'fire_chat/load_page.dart';
import 'fire_chat/messages_screen.dart';
import 'fire_chat/my_students/bloc/chat_users_cubit/chat_users_cubit.dart';

int initialTapNumber = 0;

String userIdFromUrl = '';
String userNameFromUrl = '';
String userPhotoFromUrl = '';
String userTokenFromUrl = '';
String userTypeFromUrl = '';

final appGoRouter = GoRouter(
  routes: <GoRoute>[
    ///messages
    GoRoute(
      name: GoRouteName.messages,
      path: _GoRoutePath.messages,
      builder: (BuildContext context, GoRouterState state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => GetRoomsCubit()..getChatRooms()),
          ],
          child: const MessagesScreen(),
        );
      },
    ),

    ///Load Data
    GoRoute(
      name: GoRouteName.loadData,
      path: _GoRoutePath.loadData,
      builder: (BuildContext context, GoRouterState state) {
        if (state.queryParams.isEmpty) return const Scaffold(backgroundColor: Colors.red);

        userIdFromUrl = state.queryParams['id'] ?? '';
        userNameFromUrl = state.queryParams['name'] ?? '';
        userPhotoFromUrl = state.queryParams['photo'] ?? '';
        userTokenFromUrl = state.queryParams['token'] ?? '';
        userTypeFromUrl = state.queryParams['type'] ?? '';

        var userChanged = false;
        if (AppSharedPreference.getMyId != userIdFromUrl ||
            AppSharedPreference.getTypeId != userTypeFromUrl) {
          userChanged = true;
          AppSharedPreference.cashMyId(userIdFromUrl);
          AppSharedPreference.cashToken(userTokenFromUrl);
          AppSharedPreference.cashTypeId(userTypeFromUrl);
        }

        return LoadData(userChanged: userChanged);
      },
    ),

    // ///homePage
    // GoRoute(
    //   name: GoRouteName.homePage,
    //   path: _GoRoutePath.homePage,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return Scaffold(
    //       body: Center(
    //         child: ElevatedButton(
    //             onPressed: () {
    //               context.pushNamed(
    //                 GoRouteName.loadData,
    //                 queryParams: {
    //                   'id': '0',
    //                   'name': 'admin',
    //                   'type': 'a',
    //                   'token': '889|R9yJZkErCt0wsd6oP0DfOhHlV7MVPoucFV5BsL41',
    //                 },
    //               );
    //             },
    //             child: DrawableText(text: 'saed')),
    //       ),
    //     );
    //   },
    // ),
  ],
);

class GoRouteName {
  static const messages = 'Message';
  static const loadData = 'LoadData';
  static const homePage = 'homePage';
}

class _GoRoutePath {
  // static const homePage = '/';

  static const loadData = '/';
  static const messages = '/messages';
}
