part of 'chat_users_cubit.dart';

class ChatUsersInitial extends Equatable {
  final CubitStatuses statuses;
  final List<MyChatUser> result;
  final String error;
  final int id;

  const ChatUsersInitial({
    required this.statuses,
    required this.result,
    required this.error,
    required this.id,
  });

  factory ChatUsersInitial.initial() {
    return const ChatUsersInitial(
      result: <MyChatUser>[],
      error: '',
      id: 0,
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<Object> get props => [statuses, result, error];

  ChatUsersInitial copyWith({
    CubitStatuses? statuses,
    List<MyChatUser>? result,
    String? error,
    int? id,
  }) {
    return ChatUsersInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
    );
  }

}
