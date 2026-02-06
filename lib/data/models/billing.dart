import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing.freezed.dart';
part 'billing.g.dart';

@freezed
class Billing with _$Billing {
  const factory Billing({
    required String id,
    required String organizationId,
    required String plan,
    required int amountInr,
    @Default('pending') String status, // 'pending', 'paid', 'failed'
    DateTime? paymentDate,
    DateTime? validUntil,
    DateTime? createdAt,
  }) = _Billing;

  factory Billing.fromJson(Map<String, dynamic> json) =>
      _$BillingFromJson(json);
}

extension BillingX on Billing {
  bool get isPaid => status == 'paid';
  bool get isActive =>
      isPaid && validUntil != null && validUntil!.isAfter(DateTime.now());

  String get planDisplayName {
    switch (plan) {
      case 'free':
        return 'Free (Demo)';
      case 'pro':
        return 'Pro - ₹1,500/month';
      case 'business':
        return 'Business - ₹3,000/month';
      default:
        return plan;
    }
  }

  String get planDisplayNameHindi {
    switch (plan) {
      case 'free':
        return 'Free (Demo Mode)';
      case 'pro':
        return 'Pro - ₹1,500/महीना';
      case 'business':
        return 'Business - ₹3,000/महीना';
      default:
        return plan;
    }
  }
}
