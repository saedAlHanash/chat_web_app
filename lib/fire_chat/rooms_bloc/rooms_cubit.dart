import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/fire_chat/chat_card_widget.dart';
import 'package:chat_web_app/go_route_pages.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../api_manager/api_url.dart';

import '../../main.dart';
import '../util.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsInitial> {
  RoomsCubit() : super(RoomsInitial.initial());

  Future<void> getChatRooms() async {
    if (await firebaseUserAsync == null) return;

    emit(state.copyWith(statuses: CubitStatuses.loading));

    rooms();
  }

  /// Returns a stream of messages from Firebase for a given room.
  void rooms() {
    late final Query<Map<String, dynamic>> query;

    if (!isAdmin) {
      query = FirebaseFirestore.instance
          .collection('rooms')
          .orderBy('updatedAt', descending: true)
          .where(
            'userIds',
            arrayContains: firebaseUser?.uid,
          )
          .where(
            'updatedAt',
            isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(
              getLatestUpdatedFromHive,
            ),
          );
    } else {
      query = FirebaseFirestore.instance
          .collection('rooms')
          .orderBy('updatedAt', descending: true)
          .where(
            'updatedAt',
            isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(
              getLatestUpdatedFromHive,
            ),
          );
    }

    final stream = query.snapshots().listen((snapshot) async {
      if (boxes.roomsBox == null) {
        await boxes.initialBoxes();
      }

      final listRooms = await processRoomsQuery(
        firebaseUser!,
        FirebaseFirestore.instance,
        snapshot,
        'users',
      );

      await storeRoomsInHive(listRooms);

      _setData();
    });

    emit(state.copyWith(stream: stream));
  }

  int get getLatestUpdatedFromHive {
    return state.allRooms.firstOrNull?.updatedAt ?? 0;
  }

  void _setData() {
    if (isClosed) return;

    final allRooms = getRoomsFromHive
      ?..sort(
        (a, b) => (b.updatedAt ?? 0).compareTo(a.updatedAt ?? 0),
      );

    emit(
      state.copyWith(
        allRooms: allRooms,
        statuses: CubitStatuses.done,
      ),
    );
  }

  List<types.Room>? get getRoomsFromHive {
    return boxes.roomsBox?.values.map((e) {
      return types.Room.fromJson(jsonDecode(e));
    }).toList();
  }

  Future<void> storeRoomsInHive(List<types.Room> rooms) async {
    for (var e in rooms) {
      await boxes.roomsBox?.put(e.id, jsonEncode(e));
    }
  }

  void updateRooms() {
    _setData();
  }

  Future<types.Room?> getRoomByUser(String? id) async {
    if (id == null) return null;
    for (var e in state.allRooms) {
      for (var e1 in e.users) {
        if (e1.firstName == '${isTestDomain ? 'test' : ''}$id') {
          return e;
        }
      }
    }

    for (var e in await getChatUsers()) {
      if (e.firstName == '${isTestDomain ? 'test' : ''}$id') {
        var newRoom = await FirebaseChatCore.instance.createRoom(e);

        return newRoom;
      }
    }
    return null;
  }

  void reInitial() {
    emit(RoomsInitial.initial());
  }

  void selectRoom(String selectedId) => emit(state.copyWith(selectedId: selectedId));

  @override
  Future<Function> close() async {
    super.close();
    state.stream?.cancel();
    return () {};
  }
}
