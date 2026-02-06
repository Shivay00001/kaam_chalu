// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'integration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Integration _$IntegrationFromJson(Map<String, dynamic> json) {
  return _Integration.fromJson(json);
}

/// @nodoc
mixin _$Integration {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'whatsapp', 'email', 'google_sheets'
  String get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Integration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IntegrationCopyWith<Integration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntegrationCopyWith<$Res> {
  factory $IntegrationCopyWith(
          Integration value, $Res Function(Integration) then) =
      _$IntegrationCopyWithImpl<$Res, Integration>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String type,
      String status,
      DateTime? createdAt});
}

/// @nodoc
class _$IntegrationCopyWithImpl<$Res, $Val extends Integration>
    implements $IntegrationCopyWith<$Res> {
  _$IntegrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? type = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IntegrationImplCopyWith<$Res>
    implements $IntegrationCopyWith<$Res> {
  factory _$$IntegrationImplCopyWith(
          _$IntegrationImpl value, $Res Function(_$IntegrationImpl) then) =
      __$$IntegrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String type,
      String status,
      DateTime? createdAt});
}

/// @nodoc
class __$$IntegrationImplCopyWithImpl<$Res>
    extends _$IntegrationCopyWithImpl<$Res, _$IntegrationImpl>
    implements _$$IntegrationImplCopyWith<$Res> {
  __$$IntegrationImplCopyWithImpl(
      _$IntegrationImpl _value, $Res Function(_$IntegrationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? type = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$IntegrationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntegrationImpl implements _Integration {
  const _$IntegrationImpl(
      {required this.id,
      required this.organizationId,
      required this.type,
      this.status = 'active',
      this.createdAt});

  factory _$IntegrationImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntegrationImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String type;
// 'whatsapp', 'email', 'google_sheets'
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Integration(id: $id, organizationId: $organizationId, type: $type, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntegrationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, organizationId, type, status, createdAt);

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntegrationImplCopyWith<_$IntegrationImpl> get copyWith =>
      __$$IntegrationImplCopyWithImpl<_$IntegrationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IntegrationImplToJson(
      this,
    );
  }
}

abstract class _Integration implements Integration {
  const factory _Integration(
      {required final String id,
      required final String organizationId,
      required final String type,
      final String status,
      final DateTime? createdAt}) = _$IntegrationImpl;

  factory _Integration.fromJson(Map<String, dynamic> json) =
      _$IntegrationImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get type; // 'whatsapp', 'email', 'google_sheets'
  @override
  String get status;
  @override
  DateTime? get createdAt;

  /// Create a copy of Integration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntegrationImplCopyWith<_$IntegrationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
