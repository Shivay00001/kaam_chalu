// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Workflow _$WorkflowFromJson(Map<String, dynamic> json) {
  return _Workflow.fromJson(json);
}

/// @nodoc
mixin _$Workflow {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get templateId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Map<String, dynamic> get config =>
      throw _privateConstructorUsedError; // User-configured parameters
  String? get schedule => throw _privateConstructorUsedError; // Cron expression
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Workflow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowCopyWith<Workflow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowCopyWith<$Res> {
  factory $WorkflowCopyWith(Workflow value, $Res Function(Workflow) then) =
      _$WorkflowCopyWithImpl<$Res, Workflow>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String templateId,
      String name,
      Map<String, dynamic> config,
      String? schedule,
      bool isActive,
      DateTime? createdAt});
}

/// @nodoc
class _$WorkflowCopyWithImpl<$Res, $Val extends Workflow>
    implements $WorkflowCopyWith<$Res> {
  _$WorkflowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? templateId = null,
    Object? name = null,
    Object? config = null,
    Object? schedule = freezed,
    Object? isActive = null,
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
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      schedule: freezed == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowImplCopyWith<$Res>
    implements $WorkflowCopyWith<$Res> {
  factory _$$WorkflowImplCopyWith(
          _$WorkflowImpl value, $Res Function(_$WorkflowImpl) then) =
      __$$WorkflowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String templateId,
      String name,
      Map<String, dynamic> config,
      String? schedule,
      bool isActive,
      DateTime? createdAt});
}

/// @nodoc
class __$$WorkflowImplCopyWithImpl<$Res>
    extends _$WorkflowCopyWithImpl<$Res, _$WorkflowImpl>
    implements _$$WorkflowImplCopyWith<$Res> {
  __$$WorkflowImplCopyWithImpl(
      _$WorkflowImpl _value, $Res Function(_$WorkflowImpl) _then)
      : super(_value, _then);

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? templateId = null,
    Object? name = null,
    Object? config = null,
    Object? schedule = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$WorkflowImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      config: null == config
          ? _value._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      schedule: freezed == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowImpl implements _Workflow {
  const _$WorkflowImpl(
      {required this.id,
      required this.organizationId,
      required this.templateId,
      required this.name,
      final Map<String, dynamic> config = const {},
      this.schedule,
      this.isActive = true,
      this.createdAt})
      : _config = config;

  factory _$WorkflowImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String templateId;
  @override
  final String name;
  final Map<String, dynamic> _config;
  @override
  @JsonKey()
  Map<String, dynamic> get config {
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_config);
  }

// User-configured parameters
  @override
  final String? schedule;
// Cron expression
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Workflow(id: $id, organizationId: $organizationId, templateId: $templateId, name: $name, config: $config, schedule: $schedule, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._config, _config) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      templateId,
      name,
      const DeepCollectionEquality().hash(_config),
      schedule,
      isActive,
      createdAt);

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowImplCopyWith<_$WorkflowImpl> get copyWith =>
      __$$WorkflowImplCopyWithImpl<_$WorkflowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowImplToJson(
      this,
    );
  }
}

abstract class _Workflow implements Workflow {
  const factory _Workflow(
      {required final String id,
      required final String organizationId,
      required final String templateId,
      required final String name,
      final Map<String, dynamic> config,
      final String? schedule,
      final bool isActive,
      final DateTime? createdAt}) = _$WorkflowImpl;

  factory _Workflow.fromJson(Map<String, dynamic> json) =
      _$WorkflowImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get templateId;
  @override
  String get name;
  @override
  Map<String, dynamic> get config; // User-configured parameters
  @override
  String? get schedule; // Cron expression
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowImplCopyWith<_$WorkflowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowStep _$WorkflowStepFromJson(Map<String, dynamic> json) {
  return _WorkflowStep.fromJson(json);
}

/// @nodoc
mixin _$WorkflowStep {
  String get id => throw _privateConstructorUsedError;
  String get workflowId => throw _privateConstructorUsedError;
  int get stepOrder => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  Map<String, dynamic> get actionConfig => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WorkflowStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowStepCopyWith<WorkflowStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowStepCopyWith<$Res> {
  factory $WorkflowStepCopyWith(
          WorkflowStep value, $Res Function(WorkflowStep) then) =
      _$WorkflowStepCopyWithImpl<$Res, WorkflowStep>;
  @useResult
  $Res call(
      {String id,
      String workflowId,
      int stepOrder,
      String actionType,
      Map<String, dynamic> actionConfig,
      DateTime? createdAt});
}

/// @nodoc
class _$WorkflowStepCopyWithImpl<$Res, $Val extends WorkflowStep>
    implements $WorkflowStepCopyWith<$Res> {
  _$WorkflowStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workflowId = null,
    Object? stepOrder = null,
    Object? actionType = null,
    Object? actionConfig = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      stepOrder: null == stepOrder
          ? _value.stepOrder
          : stepOrder // ignore: cast_nullable_to_non_nullable
              as int,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      actionConfig: null == actionConfig
          ? _value.actionConfig
          : actionConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowStepImplCopyWith<$Res>
    implements $WorkflowStepCopyWith<$Res> {
  factory _$$WorkflowStepImplCopyWith(
          _$WorkflowStepImpl value, $Res Function(_$WorkflowStepImpl) then) =
      __$$WorkflowStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workflowId,
      int stepOrder,
      String actionType,
      Map<String, dynamic> actionConfig,
      DateTime? createdAt});
}

/// @nodoc
class __$$WorkflowStepImplCopyWithImpl<$Res>
    extends _$WorkflowStepCopyWithImpl<$Res, _$WorkflowStepImpl>
    implements _$$WorkflowStepImplCopyWith<$Res> {
  __$$WorkflowStepImplCopyWithImpl(
      _$WorkflowStepImpl _value, $Res Function(_$WorkflowStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workflowId = null,
    Object? stepOrder = null,
    Object? actionType = null,
    Object? actionConfig = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$WorkflowStepImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      stepOrder: null == stepOrder
          ? _value.stepOrder
          : stepOrder // ignore: cast_nullable_to_non_nullable
              as int,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      actionConfig: null == actionConfig
          ? _value._actionConfig
          : actionConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowStepImpl implements _WorkflowStep {
  const _$WorkflowStepImpl(
      {required this.id,
      required this.workflowId,
      required this.stepOrder,
      required this.actionType,
      required final Map<String, dynamic> actionConfig,
      this.createdAt})
      : _actionConfig = actionConfig;

  factory _$WorkflowStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowStepImplFromJson(json);

  @override
  final String id;
  @override
  final String workflowId;
  @override
  final int stepOrder;
  @override
  final String actionType;
  final Map<String, dynamic> _actionConfig;
  @override
  Map<String, dynamic> get actionConfig {
    if (_actionConfig is EqualUnmodifiableMapView) return _actionConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_actionConfig);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'WorkflowStep(id: $id, workflowId: $workflowId, stepOrder: $stepOrder, actionType: $actionType, actionConfig: $actionConfig, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowStepImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.stepOrder, stepOrder) ||
                other.stepOrder == stepOrder) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            const DeepCollectionEquality()
                .equals(other._actionConfig, _actionConfig) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      workflowId,
      stepOrder,
      actionType,
      const DeepCollectionEquality().hash(_actionConfig),
      createdAt);

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowStepImplCopyWith<_$WorkflowStepImpl> get copyWith =>
      __$$WorkflowStepImplCopyWithImpl<_$WorkflowStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowStepImplToJson(
      this,
    );
  }
}

abstract class _WorkflowStep implements WorkflowStep {
  const factory _WorkflowStep(
      {required final String id,
      required final String workflowId,
      required final int stepOrder,
      required final String actionType,
      required final Map<String, dynamic> actionConfig,
      final DateTime? createdAt}) = _$WorkflowStepImpl;

  factory _WorkflowStep.fromJson(Map<String, dynamic> json) =
      _$WorkflowStepImpl.fromJson;

  @override
  String get id;
  @override
  String get workflowId;
  @override
  int get stepOrder;
  @override
  String get actionType;
  @override
  Map<String, dynamic> get actionConfig;
  @override
  DateTime? get createdAt;

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowStepImplCopyWith<_$WorkflowStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowRun _$WorkflowRunFromJson(Map<String, dynamic> json) {
  return _WorkflowRun.fromJson(json);
}

/// @nodoc
mixin _$WorkflowRun {
  String get id => throw _privateConstructorUsedError;
  String get workflowId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'running', 'success', 'failed'
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int get attemptCount => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this WorkflowRun to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowRunCopyWith<WorkflowRun> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowRunCopyWith<$Res> {
  factory $WorkflowRunCopyWith(
          WorkflowRun value, $Res Function(WorkflowRun) then) =
      _$WorkflowRunCopyWithImpl<$Res, WorkflowRun>;
  @useResult
  $Res call(
      {String id,
      String workflowId,
      String status,
      DateTime? startedAt,
      DateTime? completedAt,
      int attemptCount,
      String? errorMessage});
}

/// @nodoc
class _$WorkflowRunCopyWithImpl<$Res, $Val extends WorkflowRun>
    implements $WorkflowRunCopyWith<$Res> {
  _$WorkflowRunCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workflowId = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? attemptCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attemptCount: null == attemptCount
          ? _value.attemptCount
          : attemptCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowRunImplCopyWith<$Res>
    implements $WorkflowRunCopyWith<$Res> {
  factory _$$WorkflowRunImplCopyWith(
          _$WorkflowRunImpl value, $Res Function(_$WorkflowRunImpl) then) =
      __$$WorkflowRunImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workflowId,
      String status,
      DateTime? startedAt,
      DateTime? completedAt,
      int attemptCount,
      String? errorMessage});
}

/// @nodoc
class __$$WorkflowRunImplCopyWithImpl<$Res>
    extends _$WorkflowRunCopyWithImpl<$Res, _$WorkflowRunImpl>
    implements _$$WorkflowRunImplCopyWith<$Res> {
  __$$WorkflowRunImplCopyWithImpl(
      _$WorkflowRunImpl _value, $Res Function(_$WorkflowRunImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workflowId = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? attemptCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$WorkflowRunImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attemptCount: null == attemptCount
          ? _value.attemptCount
          : attemptCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowRunImpl implements _WorkflowRun {
  const _$WorkflowRunImpl(
      {required this.id,
      required this.workflowId,
      this.status = 'pending',
      this.startedAt,
      this.completedAt,
      this.attemptCount = 1,
      this.errorMessage});

  factory _$WorkflowRunImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowRunImplFromJson(json);

  @override
  final String id;
  @override
  final String workflowId;
  @override
  @JsonKey()
  final String status;
// 'pending', 'running', 'success', 'failed'
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final int attemptCount;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'WorkflowRun(id: $id, workflowId: $workflowId, status: $status, startedAt: $startedAt, completedAt: $completedAt, attemptCount: $attemptCount, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowRunImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.attemptCount, attemptCount) ||
                other.attemptCount == attemptCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, workflowId, status,
      startedAt, completedAt, attemptCount, errorMessage);

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowRunImplCopyWith<_$WorkflowRunImpl> get copyWith =>
      __$$WorkflowRunImplCopyWithImpl<_$WorkflowRunImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowRunImplToJson(
      this,
    );
  }
}

abstract class _WorkflowRun implements WorkflowRun {
  const factory _WorkflowRun(
      {required final String id,
      required final String workflowId,
      final String status,
      final DateTime? startedAt,
      final DateTime? completedAt,
      final int attemptCount,
      final String? errorMessage}) = _$WorkflowRunImpl;

  factory _WorkflowRun.fromJson(Map<String, dynamic> json) =
      _$WorkflowRunImpl.fromJson;

  @override
  String get id;
  @override
  String get workflowId;
  @override
  String get status; // 'pending', 'running', 'success', 'failed'
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  int get attemptCount;
  @override
  String? get errorMessage;

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowRunImplCopyWith<_$WorkflowRunImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowLog _$WorkflowLogFromJson(Map<String, dynamic> json) {
  return _WorkflowLog.fromJson(json);
}

/// @nodoc
mixin _$WorkflowLog {
  String get id => throw _privateConstructorUsedError;
  String get runId => throw _privateConstructorUsedError;
  String? get stepId => throw _privateConstructorUsedError;
  String get level =>
      throw _privateConstructorUsedError; // 'info', 'warn', 'error'
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WorkflowLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowLogCopyWith<WorkflowLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowLogCopyWith<$Res> {
  factory $WorkflowLogCopyWith(
          WorkflowLog value, $Res Function(WorkflowLog) then) =
      _$WorkflowLogCopyWithImpl<$Res, WorkflowLog>;
  @useResult
  $Res call(
      {String id,
      String runId,
      String? stepId,
      String level,
      String message,
      Map<String, dynamic> metadata,
      DateTime? createdAt});
}

/// @nodoc
class _$WorkflowLogCopyWithImpl<$Res, $Val extends WorkflowLog>
    implements $WorkflowLogCopyWith<$Res> {
  _$WorkflowLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? runId = null,
    Object? stepId = freezed,
    Object? level = null,
    Object? message = null,
    Object? metadata = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      runId: null == runId
          ? _value.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as String,
      stepId: freezed == stepId
          ? _value.stepId
          : stepId // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowLogImplCopyWith<$Res>
    implements $WorkflowLogCopyWith<$Res> {
  factory _$$WorkflowLogImplCopyWith(
          _$WorkflowLogImpl value, $Res Function(_$WorkflowLogImpl) then) =
      __$$WorkflowLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String runId,
      String? stepId,
      String level,
      String message,
      Map<String, dynamic> metadata,
      DateTime? createdAt});
}

/// @nodoc
class __$$WorkflowLogImplCopyWithImpl<$Res>
    extends _$WorkflowLogCopyWithImpl<$Res, _$WorkflowLogImpl>
    implements _$$WorkflowLogImplCopyWith<$Res> {
  __$$WorkflowLogImplCopyWithImpl(
      _$WorkflowLogImpl _value, $Res Function(_$WorkflowLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? runId = null,
    Object? stepId = freezed,
    Object? level = null,
    Object? message = null,
    Object? metadata = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$WorkflowLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      runId: null == runId
          ? _value.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as String,
      stepId: freezed == stepId
          ? _value.stepId
          : stepId // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowLogImpl implements _WorkflowLog {
  const _$WorkflowLogImpl(
      {required this.id,
      required this.runId,
      this.stepId,
      this.level = 'info',
      required this.message,
      final Map<String, dynamic> metadata = const {},
      this.createdAt})
      : _metadata = metadata;

  factory _$WorkflowLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowLogImplFromJson(json);

  @override
  final String id;
  @override
  final String runId;
  @override
  final String? stepId;
  @override
  @JsonKey()
  final String level;
// 'info', 'warn', 'error'
  @override
  final String message;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'WorkflowLog(id: $id, runId: $runId, stepId: $stepId, level: $level, message: $message, metadata: $metadata, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.stepId, stepId) || other.stepId == stepId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, runId, stepId, level,
      message, const DeepCollectionEquality().hash(_metadata), createdAt);

  /// Create a copy of WorkflowLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowLogImplCopyWith<_$WorkflowLogImpl> get copyWith =>
      __$$WorkflowLogImplCopyWithImpl<_$WorkflowLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowLogImplToJson(
      this,
    );
  }
}

abstract class _WorkflowLog implements WorkflowLog {
  const factory _WorkflowLog(
      {required final String id,
      required final String runId,
      final String? stepId,
      final String level,
      required final String message,
      final Map<String, dynamic> metadata,
      final DateTime? createdAt}) = _$WorkflowLogImpl;

  factory _WorkflowLog.fromJson(Map<String, dynamic> json) =
      _$WorkflowLogImpl.fromJson;

  @override
  String get id;
  @override
  String get runId;
  @override
  String? get stepId;
  @override
  String get level; // 'info', 'warn', 'error'
  @override
  String get message;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime? get createdAt;

  /// Create a copy of WorkflowLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowLogImplCopyWith<_$WorkflowLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
