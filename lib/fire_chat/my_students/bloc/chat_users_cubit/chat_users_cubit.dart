import 'dart:convert';

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
    // final response = await APIController().getChatUsers();
    // if (response.statusCode == 200) {
    //   return ChatUsersResponse.fromJson(response.data).students;
    // } else {
    //   return null;
    // }
  }
}
