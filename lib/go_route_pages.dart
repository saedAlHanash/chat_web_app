import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/api_manager/api_url.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'fire_chat/get_chats_rooms_bloc/get_rooms_cubit.dart';
import 'fire_chat/load_page.dart';
import 'fire_chat/messages_screen.dart';
import 'fire_chat/my_students/bloc/chat_users_cubit/chat_users_cubit.dart';

var metaQuery = MetaQuery.fromJson({});
var test = {
  'id': '82',
  'name': 'Farouk Alkheame',
  'photo':
      'https://lms.almas.education/public/storage/users/February2024/FOKyMdaRMI9wEyq3UMvl.jpg',
  'token': '1024|MAssY29iHqboBEiSuBkj86n77fROO2ORSpzSYIT9',
  'type': 't',
  'fcm':
      'cD2OaIqHQkmDgmlx8chs3W:APA91bELfrxiqpKFv3tioT13k14wgZ47v5dz3Bdm56fsBTwMB6wm1rCsZLVbssuYvXTcM-rylyZv1gyQzHOljmB8EbxGUNXL6cjOMIugHdvZTA3cShcJPIQwkcxYxT1dLb4_IiTN9ZdJ',
  'domain': testUrl,
};
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
//https://lmss-29085.web.app?
// id=82
// name=Farouk Alkheame
// photo=https://lms.almas.education/public/storage/users/February2024/FOKyMdaRMI9wEyq3UMvl.jpg
// token=1024|MAssY29iHqboBEiSuBkj86n77fROO2ORSpzSYIT9
// type=t
    ///Load Data
    GoRoute(
      name: GoRouteName.loadData,
      path: _GoRoutePath.loadData,
      builder: (BuildContext context, GoRouterState state) {
        if (state.queryParams.isEmpty) return const Scaffold(backgroundColor: Colors.red);
        // metaQuery = MetaQuery.fromJson(test);
        metaQuery = MetaQuery.fromJson(state.queryParams);
        return LoadData(userChanged: AppSharedPreference.cashMetta(metaQuery));
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

class MetaQuery {
  final String userId;
  final String userName;
  final String userPhoto;
  final String userToken;
  final String userType;
  final String userFcm;
  final String domain;

  MetaQuery({
    required this.userId,
    required this.userName,
    required this.userPhoto,
    required this.userToken,
    required this.userType,
    required this.userFcm,
    required this.domain,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': userName,
      'photo': userPhoto,
      'token': userToken,
      'type': userType,
      'fcm': userFcm,
      'domain': domain,
    };
  }

  factory MetaQuery.fromJson(Map<String, dynamic> map) {
    return MetaQuery(
      userId: map['id'] ?? '',
      userName: map['name'] ?? '',
      userPhoto: map['photo'] ?? '',
      userToken: map['token'] ?? '',
      userType: map['type'] ?? '',
      userFcm: map['fcm'] ?? '',
      domain: map['domain'] ?? '',
    );
  }
}
