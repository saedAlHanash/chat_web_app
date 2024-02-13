import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../main.dart';

import '../chat_card_widget.dart';
import '../util.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesInitial> {
  MessagesCubit() : super(MessagesInitial.initial());

  Future<void> getChatRoomMessage(types.Room room) async {
    if (firebaseUser == null) return;

    final allMessages = (boxes.messageBox?.values ?? {})
        .map((e) => types.Message.fromJson(jsonDecode(e)))
        .toList()
      ..sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));

    emit(state.copyWith(room: room, allMessages: allMessages));

    messages(room);
  }

  Future<void> reInitial(types.Room room) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    if (selectedId.isNotEmpty && (boxes.messageBox?.isOpen ?? false)) {
      await boxes.messageBox?.close();
    }

    boxes.messageBox = await Hive.openBox<String>(room.id);

    await state.stream?.cancel();
    emit(MessagesInitial.initial());
  }

  /// Returns a stream of messages from Firebase for a given room.
  Future<void> messages(types.Room room) async {
    var query = FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .where(
          'createdAt',
          isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(
            getLatestUpdatedFromHive,
          ),
        );

    final stream = query.snapshots().listen((snapshot) async {
      if (boxes.latestMessagesBox == null) {
        await boxes.initialBoxes();
      }

      final newMessages = <types.Message>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final author = room.users.firstWhere(
          (u) => u.id == data['authorId'],
          orElse: () => types.User(id: data['authorId'] as String),
        );

        data['author'] = author.toJson();
        data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
        data['id'] = doc.id;
        data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

        await boxes.messageBox?.put(doc.id, jsonEncode(data));

        final message = types.Message.fromJson(data);
        newMessages.add(message);
      }

      if (!isClosed) {
        final allMessages = boxes.messageBox?.values
            .map((e) => types.Message.fromJson(jsonDecode(e)))
            .toList()
          ?..sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));

        if (allMessages?.firstOrNull != null) {
          await boxes.latestMessagesBox?.put(room.id, jsonEncode(allMessages?.first));
        }

        emit(state.copyWith(allMessages: allMessages));
      }
    });

    emit(state.copyWith(stream: stream, roomId: room.id));
  }

  int get getLatestUpdatedFromHive {
    final time = state.allMessages.firstOrNull?.updatedAt ?? 0;
    loggerObject.v(time);
    return time;
  }

  @override
  Future<Function> close() async {
    super.close();
    state.stream?.cancel();
    // if (state.oldLength < state.allMessages.length) {
    //   ctx?.read<GetRoomsCubit>().getChatRooms();
    // }
    return () {};
  }
}
