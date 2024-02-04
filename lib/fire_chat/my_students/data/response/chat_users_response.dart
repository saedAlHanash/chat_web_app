import '../../../util.dart';

class ChatUsersResponse {
  ChatUsersResponse({
    required this.students,
  });

  final List<MyChatUser> students;

  factory ChatUsersResponse.fromJson(List<dynamic> json) {
    return ChatUsersResponse(
      students: List<MyChatUser>.from((json).map((x) => MyChatUser.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "students": students.map((x) => x.toJson()).toList(),
      };
}

class MyChatUser {
  String get getName => '$firstName $lastName';

  MyChatUser({
    required this.id,
    required this.roleId,
    required this.firstName,
    required this.email,
    required this.photo,
    required this.emailVerifiedAt,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
    required this.activatedAt,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.otherDetails,
    required this.isActive,
  });

  final int id;
  final String roleId;
  final String firstName;
  final String email;
  final String photo;
  final dynamic emailVerifiedAt;
  final Settings? settings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic activatedAt;
  final String lastName;
  final String phone;
  final String address;
  final String otherDetails;
  final dynamic isActive;

  factory MyChatUser.fromJson(Map<String, dynamic> json) {
    return MyChatUser(
      id: json["id"] ?? 0,
      roleId: json["role_id"] ?? "",
      firstName: json["first_name"] ?? "",
      email: json["email"] ?? "",
      photo:
          ('${((json["photo"] ?? "") as String).startsWith('http') ? '' : baseImageUrl}${json["photo"] ?? ""}'),
      emailVerifiedAt: json["email_verified_at"],
      settings: json["settings"] == null ? null : Settings.fromJson(json["settings"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      activatedAt: json["activated_at"],
      lastName: json["last_name"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      otherDetails: json["other_details"] ?? "",
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "first_name": firstName,
        "email": email,
        "photo": photo,
        "email_verified_at": emailVerifiedAt,
        "settings": settings?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "activated_at": activatedAt,
        "last_name": lastName,
        "phone": phone,
        "address": address,
        "other_details": otherDetails,
        "is_active": isActive,
      };
}

class Settings {
  Settings({
    required this.locale,
  });

  final String locale;

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      locale: json["locale"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "locale": locale,
      };
}
