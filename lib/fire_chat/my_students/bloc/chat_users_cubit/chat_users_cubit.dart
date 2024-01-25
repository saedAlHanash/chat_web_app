import 'dart:convert';

import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/go_route_pages.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util.dart';
import '../../data/response/chat_users_response.dart';

//teachers
part 'chat_users_state.dart';

class ChatUsersCubit extends Cubit<ChatUsersInitial> {
  ChatUsersCubit() : super(ChatUsersInitial.initial());

  Future<void> getChatUsers() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    final result = await _getChatUsersApi();

    if (result == null) {
      emit(state.copyWith(statuses: CubitStatuses.error));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.done, result: result));
    }
  }

  Future<List<MyChatUser>?> _getChatUsersApi() async {
    if(isAdmin) return [];
    final response = await APIService().getApi(
      url: isTeacher ? 'api/teacher/my-students' : "api/student/my-teachers",
    );
    if (response.statusCode == 200) {
      return ChatUsersResponse.fromJson(jsonDecode(response.body)).students;
    } else {
      return null;
    }
  }
}
