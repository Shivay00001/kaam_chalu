import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    String? fullName,
    String? phone,
    @Default('en') String language, // 'en' or 'hi'
    DateTime? createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

/// Organization membership
@freezed
class Member with _$Member {
  const factory Member({
    required String id,
    required String organizationId,
    required String userId,
    @Default('member') String role, // 'owner', 'admin', 'member'
    DateTime? createdAt,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

extension MemberX on Member {
  bool get isOwner => role == 'owner';
  bool get isAdmin => role == 'admin' || role == 'owner';
}
