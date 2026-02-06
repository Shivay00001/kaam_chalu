import 'package:freezed_annotation/freezed_annotation.dart';

part 'integration.freezed.dart';
part 'integration.g.dart';

@freezed
class Integration with _$Integration {
  const factory Integration({
    required String id,
    required String organizationId,
    required String type, // 'whatsapp', 'email', 'google_sheets'
    @Default('active') String status,
    DateTime? createdAt,
    // Note: credentials are never exposed to frontend
  }) = _Integration;

  factory Integration.fromJson(Map<String, dynamic> json) =>
      _$IntegrationFromJson(json);
}

/// Integration type definitions
enum IntegrationType {
  whatsapp('whatsapp', 'WhatsApp Business', 'WhatsApp से messages भेजें'),
  email('email', 'Email (SMTP)', 'Email से reports and reminders'),
  googleSheets('google_sheets', 'Google Sheets', 'Sheets से data sync');

  const IntegrationType(this.id, this.name, this.descriptionHindi);

  final String id;
  final String name;
  final String descriptionHindi;
}

/// Required fields for each integration type
class IntegrationFields {
  static const Map<String, List<IntegrationField>> fields = {
    'whatsapp': [
      IntegrationField(
        key: 'phone_number_id',
        label: 'Phone Number ID',
        labelHindi: 'Phone Number ID',
        type: FieldType.text,
        required: true,
      ),
      IntegrationField(
        key: 'access_token',
        label: 'Access Token',
        labelHindi: 'Access Token',
        type: FieldType.password,
        required: true,
      ),
      IntegrationField(
        key: 'business_account_id',
        label: 'Business Account ID',
        labelHindi: 'Business Account ID',
        type: FieldType.text,
        required: true,
      ),
    ],
    'email': [
      IntegrationField(
        key: 'smtp_host',
        label: 'SMTP Host',
        labelHindi: 'SMTP Host',
        type: FieldType.text,
        required: true,
      ),
      IntegrationField(
        key: 'smtp_port',
        label: 'SMTP Port',
        labelHindi: 'SMTP Port',
        type: FieldType.number,
        required: true,
      ),
      IntegrationField(
        key: 'smtp_username',
        label: 'Username / Email',
        labelHindi: 'Username / Email',
        type: FieldType.text,
        required: true,
      ),
      IntegrationField(
        key: 'smtp_password',
        label: 'Password',
        labelHindi: 'Password',
        type: FieldType.password,
        required: true,
      ),
    ],
    'google_sheets': [
      IntegrationField(
        key: 'service_account_json',
        label: 'Service Account JSON',
        labelHindi: 'Service Account JSON',
        type: FieldType.textarea,
        required: true,
        hint: 'Paste the entire JSON content from Google Cloud Console',
      ),
    ],
  };
}

class IntegrationField {
  final String key;
  final String label;
  final String labelHindi;
  final FieldType type;
  final bool required;
  final String? hint;

  const IntegrationField({
    required this.key,
    required this.label,
    required this.labelHindi,
    required this.type,
    required this.required,
    this.hint,
  });
}

enum FieldType {
  text,
  password,
  number,
  textarea,
}
