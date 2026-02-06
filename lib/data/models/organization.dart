import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

@freezed
class Organization with _$Organization {
  const factory Organization({
    required String id,
    required String name,
    required String slug,
    @Default('simple') String mode, // 'simple' or 'advanced'
    @Default('free') String billingPlan, // 'free', 'pro', 'business'
    @Default('active') String billingStatus,
    DateTime? createdAt,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}

/// Helper extension for organization checks
extension OrganizationX on Organization {
  bool get isSimpleMode => mode == 'simple';
  bool get isAdvancedMode => mode == 'advanced';
  bool get isFreePlan => billingPlan == 'free';
  bool get isProPlan => billingPlan == 'pro';
  bool get isBusinessPlan => billingPlan == 'business';
  bool get canExecuteWorkflows => billingStatus == 'active' && !isFreePlan;
}
