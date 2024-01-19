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
            BlocProvider(create: (_) => ChatUsersCubit()..getChatUsers()),
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
        loggerObject.wtf(state.queryParams);

        if (state.queryParams.isEmpty) return const Scaffold(backgroundColor: Colors.red);

        userIdFromUrl = state.queryParams['id'] ?? '';
        userNameFromUrl = state.queryParams['name'] ?? '';
        userPhotoFromUrl = state.queryParams['photo'] ?? '';
        userTokenFromUrl = state.queryParams['token'] ?? '';
        userTypeFromUrl = state.queryParams['type'] ?? '';

        var userChanged = false;
        loggerObject.w(AppSharedPreference.getMyId);
        if (AppSharedPreference.getMyId != userIdFromUrl) {
          userChanged = true;
          AppSharedPreference.cashMyId(userIdFromUrl);
          AppSharedPreference.cashToken(userTokenFromUrl);
          AppSharedPreference.cashTypeId(userTypeFromUrl);
        }

        return LoadData(userChanged: userChanged);
      },
    ),

    ///homePage
    GoRoute(
      name: GoRouteName.homePage,
      path: _GoRoutePath.homePage,
      builder: (BuildContext context, GoRouterState state) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(
                    GoRouteName.loadData,
                    queryParams: {
                      'id': '73',
                      'name': 'teacher',
                      'type': 't',
                      'token': 'dsfsfgsdf',
                    },
                  );
                },
                child: DrawableText(text: 'saed')),
          ),
        );
      },
    ),
  ],
);

class GoRouteName {
  static const homePage = 'Home Page';
  static const messages = 'Message';
  static const loadData = 'LoadData';
  static const driverInfo = 'driver info';
  static const debts = 'debts';
  static const createDriver = 'createDriver';
  static const updateDriver = 'updateDriver';
  static const createCarCategory = 'CreateCarCategory';
  static const createAdmin = 'createAdmin';
  static const adminInfo = 'adminInfo';
  static const clientInfo = 'clientInfo';
  static const pointInfo = 'pointInfo';
  static const tripInfo = 'tripInfo';
  static const sharedTripInfo = 'sharedTripInfo';
  static const createCoupon = 'createCoupon';
  static const createRole = 'createRole';
  static const tripsPae = 'tripsPae';
  static const sharedTripsPae = 'sharedTripsPae';
  static const createInstitution = 'createInstitution';
  static const createTempTrip = 'createTempTrip';
  static const tempTripInfo = 'tempTripInfo';
  static const area = 'area';
  static const redeems = 'redeems';

  static const createCompany = 'createCompany';
  static const createPlan = 'createPlan';
  static const agencyReport = 'agencyReport';
  static const createCompanyPath = 'createCompanyPath';
  static const companyPathInfo = 'companyPathInfo';
  static const createPlanTrip = 'createPlanTrip';
}

class _GoRoutePath {
  static const createCompany = '/createCompany';
  static const homePage = '/';
  static const driverInfo = '/DriverInfo';
  static const loadData = '/loadData';
  static const messages = '/messages';
  static const createDriver = '/createDriver';
  static const updateDriver = '/updateDriver';
  static const createCarCategory = '/CreateCarCategory';
  static const createAdmin = '/createAdmin';
  static const adminInfo = '/adminInfo';
  static const clientInfo = '/clientInfo';
  static const pointInfo = '/pointInfo';
  static const tripInfo = '/tripInfo';
  static const sharedTripInfo = '/sharedTripInfo';
  static const createCoupon = '/createCoupon';
  static const createRole = '/createRole';
  static const tripsPae = '/tripsPae';
  static const sharedTripsPae = '/sharedTripsPae';
  static const createInstitution = '/createInstitution';
  static const createTempTrip = '/createTempTrip';
  static const tempTripInfo = '/tempTripInfo';
  static const area = '/area';
  static const redeems = '/redeems';
  static const createPlan = '/createPlan';
  static const agencyReport = '/agencyReport';
  static const createCompanyPath = '/createCompanyPath';
  static const companyPathInfo = '/companyPathInfo';
  static const createPlanTrip = '/createPlanTrip';
}
