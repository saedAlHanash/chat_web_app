part of 'room_messages_cubit.dart';

class RoomMessagesInitial  {
  final CubitStatuses statuses;
  final List<types.Message> allMessages;
  final String roomId;
  final types.Room room;
  final int oldLength;
  final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? stream;

  const RoomMessagesInitial({
    required this.statuses,
    required this.allMessages,
    required this.roomId,
    required this.room,
    required this.oldLength,
    this.stream,
  });

  factory RoomMessagesInitial.initial() {
    return RoomMessagesInitial(
      allMessages:
      roomMessage!.values.map((e) => types.Message.fromJson(jsonDecode(e))).toList()
        ..sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0)),
      roomId: '',
      room: const types.Room(id: '0', type: RoomType.direct, users: []),
      oldLength: roomMessage!.length,
      statuses: CubitStatuses.init,
    );
  }


  RoomMessagesInitial copyWith({
    CubitStatuses? statuses,
    List<types.Message>? allMessages,
    String? roomId,
    types.Room? room,
    int? oldLength,
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? stream,
  }) {
    return RoomMessagesInitial(
        statuses: statuses ?? this.statuses,
        allMessages: allMessages ?? this.allMessages,
        roomId: roomId ?? this.roomId,
        room: room ?? this.room,
        oldLength: oldLength ?? this.oldLength,
        stream: stream ?? this.stream);
  }
}