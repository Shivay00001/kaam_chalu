/// All 10 predefined workflow templates
/// These are LOCKED - users can only configure parameters, not logic
class WorkflowTemplates {
  WorkflowTemplates._();

  static final List<WorkflowTemplate> all = [
    leadFollowup,
    dailySummary,
    staffReminder,
    paymentReminder,
    attendanceSummary,
    dataCleanup,
    monthlyMis,
    salesPerformance,
    clientReport,
    backupExport,
  ];

  /// Get template by ID
  static WorkflowTemplate? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filter by target audience
  static List<WorkflowTemplate> forSimpleMode() =>
      all.where((t) => t.targetMode.contains('simple')).toList();

  static List<WorkflowTemplate> forAdvancedMode() => all;

  // ========== WORKFLOW 1: LEAD FOLLOW-UP ==========
  static final leadFollowup = WorkflowTemplate(
    id: 'lead_followup',
    nameEn: 'Lead Follow-up Automation',
    nameHi: 'Leads का Follow-up System',
    descriptionEn: 'Automatically send WhatsApp message when new lead is added',
    descriptionHi: 'Leads ka follow-up system khud karega',
    icon: '📱',
    targetMode: ['simple', 'advanced'],
    targetAudience: 'noida',
    requiredIntegrations: ['whatsapp', 'google_sheets'],
    configFields: [
      ConfigField(
        key: 'sheet_url',
        labelEn: 'Google Sheet URL',
        labelHi: 'Google Sheet का Link',
        type: 'url',
        required: true,
        hint: 'Sheet with lead data',
      ),
      ConfigField(
        key: 'message_template',
        labelEn: 'WhatsApp Message',
        labelHi: 'WhatsApp Message',
        type: 'textarea',
        required: true,
        defaultValue: 'Namaste {{name}}! Thanks for your interest. We will contact you soon.',
      ),
      ConfigField(
        key: 'send_email',
        labelEn: 'Also send email?',
        labelHi: 'Email भी भेजें?',
        type: 'toggle',
        defaultValue: false,
      ),
      ConfigField(
        key: 'daily_summary_time',
        labelEn: 'Daily summary time',
        labelHi: 'Daily summary का time',
        type: 'time',
        defaultValue: '20:00',
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_sheet_data', description: 'Get new leads from sheet'),
      TemplateStep(order: 2, action: 'send_whatsapp', description: 'Send WhatsApp to each new lead'),
      TemplateStep(order: 3, action: 'send_email', description: 'Send email if enabled', conditional: 'send_email'),
      TemplateStep(order: 4, action: 'send_daily_summary', description: 'Send summary to owner'),
    ],
  );

  // ========== WORKFLOW 2: DAILY BUSINESS SUMMARY ==========
  static final dailySummary = WorkflowTemplate(
    id: 'daily_summary',
    nameEn: 'Daily Business Summary',
    nameHi: 'Aaj ka Kaam Summary',
    descriptionEn: 'Get simple daily numbers on WhatsApp',
    descriptionHi: 'Raat ko simple numbers WhatsApp pe',
    icon: '📊',
    targetMode: ['simple', 'advanced'],
    targetAudience: 'noida',
    requiredIntegrations: ['whatsapp', 'google_sheets'],
    configFields: [
      ConfigField(
        key: 'sheet_url',
        labelEn: 'Data Sheet URL',
        labelHi: 'Data Sheet का Link',
        type: 'url',
        required: true,
      ),
      ConfigField(
        key: 'summary_time',
        labelEn: 'Send at time',
        labelHi: 'किस time भेजें',
        type: 'time',
        defaultValue: '21:00',
      ),
      ConfigField(
        key: 'owner_phone',
        labelEn: 'Owner WhatsApp Number',
        labelHi: 'Owner का WhatsApp Number',
        type: 'phone',
        required: true,
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_sheet_data', description: 'Get today data'),
      TemplateStep(order: 2, action: 'calculate_summary', description: 'Calculate counts'),
      TemplateStep(order: 3, action: 'send_whatsapp', description: 'Send to owner'),
    ],
  );

  // ========== WORKFLOW 3: STAFF DEPENDENCY REMOVER ==========
  static final staffReminder = WorkflowTemplate(
    id: 'staff_reminder',
    nameEn: 'Staff Dependency Remover',
    nameHi: 'System याद रखेगा',
    descriptionEn: 'Auto reminders so staff doesn\'t forget tasks',
    descriptionHi: 'Banda bhool gaya? System yaad rakhega!',
    icon: '⏰',
    targetMode: ['simple', 'advanced'],
    targetAudience: 'noida',
    requiredIntegrations: ['whatsapp'],
    configFields: [
      ConfigField(
        key: 'reminder_list_url',
        labelEn: 'Task Sheet URL',
        labelHi: 'Task List Sheet',
        type: 'url',
        required: true,
      ),
      ConfigField(
        key: 'reminder_time',
        labelEn: 'Reminder time',
        labelHi: 'Reminder का time',
        type: 'time',
        defaultValue: '09:00',
      ),
      ConfigField(
        key: 'notify_owner_on_miss',
        labelEn: 'Notify owner if task missed',
        labelHi: 'Task miss होने पर owner को बताएं',
        type: 'toggle',
        defaultValue: true,
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_pending_tasks', description: 'Get pending tasks'),
      TemplateStep(order: 2, action: 'send_reminders', description: 'Send WhatsApp reminders'),
      TemplateStep(order: 3, action: 'notify_owner', description: 'Report to owner', conditional: 'notify_owner_on_miss'),
    ],
  );

  // ========== WORKFLOW 4: PAYMENT REMINDER ==========
  static final paymentReminder = WorkflowTemplate(
    id: 'payment_reminder',
    nameEn: 'Payment / Fees Reminder',
    nameHi: 'Payment Reminder',
    descriptionEn: 'Polite payment reminders before due date',
    descriptionHi: 'Due date से पहले polite reminder',
    icon: '💰',
    targetMode: ['simple', 'advanced'],
    targetAudience: 'both',
    requiredIntegrations: ['whatsapp'],
    configFields: [
      ConfigField(
        key: 'payment_sheet_url',
        labelEn: 'Payment Sheet URL',
        labelHi: 'Payment Sheet Link',
        type: 'url',
        required: true,
      ),
      ConfigField(
        key: 'days_before',
        labelEn: 'Remind days before due',
        labelHi: 'Due से कितने दिन पहले',
        type: 'number',
        defaultValue: 3,
      ),
      ConfigField(
        key: 'message_template',
        labelEn: 'Reminder Message',
        labelHi: 'Reminder Message',
        type: 'textarea',
        defaultValue: 'Namaste {{name}}, reminder: ₹{{amount}} payment due on {{due_date}}. Please ignore if already paid.',
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_upcoming_payments', description: 'Get upcoming dues'),
      TemplateStep(order: 2, action: 'filter_by_date', description: 'Filter by reminder window'),
      TemplateStep(order: 3, action: 'send_whatsapp', description: 'Send polite reminders'),
    ],
  );

  // ========== WORKFLOW 5: ATTENDANCE SUMMARY ==========
  static final attendanceSummary = WorkflowTemplate(
    id: 'attendance_summary',
    nameEn: 'Attendance / Activity Summary',
    nameHi: 'Attendance Report',
    descriptionEn: 'Simple count of who was present',
    descriptionHi: 'Kaun aaya, kitne aaye - simple count',
    icon: '📋',
    targetMode: ['simple', 'advanced'],
    targetAudience: 'noida',
    requiredIntegrations: ['whatsapp', 'google_sheets'],
    configFields: [
      ConfigField(
        key: 'attendance_sheet_url',
        labelEn: 'Attendance Sheet URL',
        labelHi: 'Attendance Sheet Link',
        type: 'url',
        required: true,
      ),
      ConfigField(
        key: 'frequency',
        labelEn: 'Summary frequency',
        labelHi: 'Summary कब भेजें',
        type: 'select',
        options: ['daily', 'weekly'],
        defaultValue: 'daily',
      ),
      ConfigField(
        key: 'summary_time',
        labelEn: 'Send time',
        labelHi: 'किस time',
        type: 'time',
        defaultValue: '18:00',
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_attendance_data', description: 'Get attendance'),
      TemplateStep(order: 2, action: 'calculate_counts', description: 'Count present/absent'),
      TemplateStep(order: 3, action: 'send_whatsapp', description: 'Send to owner'),
    ],
  );

  // ========== WORKFLOW 6: DATA CLEANUP ==========
  static final dataCleanup = WorkflowTemplate(
    id: 'data_cleanup',
    nameEn: 'Data Cleanup & Formatter',
    nameHi: 'Data Saaf Karo',
    descriptionEn: 'Fix messy sheets, remove duplicates',
    descriptionHi: 'Sheet saaf, duplicates hataao',
    icon: '🧹',
    targetMode: ['simple', 'advanced'],
    targetAudience: 'noida',
    requiredIntegrations: ['google_sheets'],
    configFields: [
      ConfigField(
        key: 'sheet_url',
        labelEn: 'Sheet to clean',
        labelHi: 'कौनसी Sheet saaf करें',
        type: 'url',
        required: true,
      ),
      ConfigField(
        key: 'remove_duplicates',
        labelEn: 'Remove duplicates',
        labelHi: 'Duplicate हटाएं',
        type: 'toggle',
        defaultValue: true,
      ),
      ConfigField(
        key: 'fix_phone_format',
        labelEn: 'Fix phone number format',
        labelHi: 'Phone number format fix करें',
        type: 'toggle',
        defaultValue: true,
      ),
      ConfigField(
        key: 'schedule',
        labelEn: 'Run frequency',
        labelHi: 'कब run हो',
        type: 'select',
        options: ['daily', 'weekly'],
        defaultValue: 'weekly',
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_sheet_data', description: 'Get sheet data'),
      TemplateStep(order: 2, action: 'remove_duplicates', description: 'Remove duplicates', conditional: 'remove_duplicates'),
      TemplateStep(order: 3, action: 'format_phones', description: 'Format phone numbers', conditional: 'fix_phone_format'),
      TemplateStep(order: 4, action: 'update_sheet', description: 'Save cleaned data'),
    ],
  );

  // ========== WORKFLOW 7: MONTHLY MIS REPORT ==========
  static final monthlyMis = WorkflowTemplate(
    id: 'monthly_mis',
    nameEn: 'Monthly MIS Report',
    nameHi: 'Monthly MIS Report',
    descriptionEn: 'Structured report with tables and basic charts',
    descriptionHi: 'Proper MIS report with PDF',
    icon: '📈',
    targetMode: ['advanced'],
    targetAudience: 'mumbai',
    requiredIntegrations: ['email', 'google_sheets'],
    configFields: [
      ConfigField(
        key: 'data_sheets',
        labelEn: 'Data Sheet URLs (comma separated)',
        labelHi: 'Data Sheet URLs',
        type: 'textarea',
        required: true,
      ),
      ConfigField(
        key: 'report_email',
        labelEn: 'Send report to email',
        labelHi: 'Report किस email पर',
        type: 'email',
        required: true,
      ),
      ConfigField(
        key: 'include_charts',
        labelEn: 'Include charts',
        labelHi: 'Charts include करें',
        type: 'toggle',
        defaultValue: true,
      ),
      ConfigField(
        key: 'send_day',
        labelEn: 'Day of month to send',
        labelHi: 'महीने की किस तारीख को',
        type: 'number',
        defaultValue: 1,
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_monthly_data', description: 'Get all monthly data'),
      TemplateStep(order: 2, action: 'generate_tables', description: 'Create summary tables'),
      TemplateStep(order: 3, action: 'generate_charts', description: 'Create charts', conditional: 'include_charts'),
      TemplateStep(order: 4, action: 'generate_pdf', description: 'Create PDF report'),
      TemplateStep(order: 5, action: 'send_email', description: 'Email report'),
    ],
  );

  // ========== WORKFLOW 8: SALES PERFORMANCE ==========
  static final salesPerformance = WorkflowTemplate(
    id: 'sales_performance',
    nameEn: 'Sales Performance Report',
    nameHi: 'Sales Performance Report',
    descriptionEn: 'Weekly/Monthly comparison vs last period',
    descriptionHi: 'पिछले period से comparison',
    icon: '📊',
    targetMode: ['advanced'],
    targetAudience: 'mumbai',
    requiredIntegrations: ['email', 'google_sheets'],
    configFields: [
      ConfigField(
        key: 'sales_sheet_url',
        labelEn: 'Sales Data Sheet',
        labelHi: 'Sales Data Sheet',
        type: 'url',
        required: true,
      ),
      ConfigField(
        key: 'frequency',
        labelEn: 'Report frequency',
        labelHi: 'Report कब',
        type: 'select',
        options: ['weekly', 'monthly'],
        defaultValue: 'weekly',
      ),
      ConfigField(
        key: 'email',
        labelEn: 'Send to email',
        labelHi: 'किस email पर',
        type: 'email',
        required: true,
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_current_period', description: 'Get current period data'),
      TemplateStep(order: 2, action: 'fetch_previous_period', description: 'Get previous period'),
      TemplateStep(order: 3, action: 'calculate_comparison', description: 'Compare periods'),
      TemplateStep(order: 4, action: 'generate_pdf', description: 'Create PDF'),
      TemplateStep(order: 5, action: 'send_email', description: 'Send report'),
    ],
  );

  // ========== WORKFLOW 9: CLIENT REPORT SENDER ==========
  static final clientReport = WorkflowTemplate(
    id: 'client_report',
    nameEn: 'Client Report Sender',
    nameHi: 'Client Report Sender',
    descriptionEn: 'Auto send PDF reports to client emails',
    descriptionHi: 'Clients को automatic PDF reports',
    icon: '📧',
    targetMode: ['advanced'],
    targetAudience: 'mumbai',
    requiredIntegrations: ['email', 'google_sheets'],
    configFields: [
      ConfigField(
        key: 'client_data_sheet',
        labelEn: 'Client Data Sheet',
        labelHi: 'Client Data Sheet',
        type: 'url',
        required: true,
      ),
      ConfigField(
        key: 'report_template',
        labelEn: 'Report template',
        labelHi: 'Report template',
        type: 'select',
        options: ['monthly_summary', 'performance', 'custom'],
        defaultValue: 'monthly_summary',
      ),
      ConfigField(
        key: 'frequency',
        labelEn: 'Send frequency',
        labelHi: 'कब भेजें',
        type: 'select',
        options: ['weekly', 'monthly'],
        defaultValue: 'monthly',
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_clients', description: 'Get client list'),
      TemplateStep(order: 2, action: 'generate_reports', description: 'Generate each report'),
      TemplateStep(order: 3, action: 'send_emails', description: 'Email to each client'),
    ],
  );

  // ========== WORKFLOW 10: BACKUP & EXPORT ==========
  static final backupExport = WorkflowTemplate(
    id: 'backup_export',
    nameEn: 'Backup & Export System',
    nameHi: 'Backup & Export',
    descriptionEn: 'Weekly backup of all your sheet data',
    descriptionHi: 'Weekly data backup - disaster recovery ready',
    icon: '💾',
    targetMode: ['simple', 'advanced'],
    targetAudience: 'both',
    requiredIntegrations: ['google_sheets', 'email'],
    configFields: [
      ConfigField(
        key: 'sheets_to_backup',
        labelEn: 'Sheet URLs to backup (comma separated)',
        labelHi: 'Backup करने वाली Sheets',
        type: 'textarea',
        required: true,
      ),
      ConfigField(
        key: 'backup_email',
        labelEn: 'Send backup to email',
        labelHi: 'Backup किस email पर',
        type: 'email',
        required: true,
      ),
      ConfigField(
        key: 'frequency',
        labelEn: 'Backup frequency',
        labelHi: 'Backup कब',
        type: 'select',
        options: ['daily', 'weekly'],
        defaultValue: 'weekly',
      ),
    ],
    steps: [
      TemplateStep(order: 1, action: 'fetch_all_sheets', description: 'Get all sheet data'),
      TemplateStep(order: 2, action: 'generate_csv', description: 'Create CSV files'),
      TemplateStep(order: 3, action: 'zip_files', description: 'Zip all CSVs'),
      TemplateStep(order: 4, action: 'send_email', description: 'Email backup'),
    ],
  );
}

/// Workflow template definition
class WorkflowTemplate {
  final String id;
  final String nameEn;
  final String nameHi;
  final String descriptionEn;
  final String descriptionHi;
  final String icon;
  final List<String> targetMode; // 'simple', 'advanced'
  final String targetAudience; // 'noida', 'mumbai', 'both'
  final List<String> requiredIntegrations;
  final List<ConfigField> configFields;
  final List<TemplateStep> steps;

  const WorkflowTemplate({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.icon,
    required this.targetMode,
    required this.targetAudience,
    required this.requiredIntegrations,
    required this.configFields,
    required this.steps,
  });

  String name(String lang) => lang == 'hi' ? nameHi : nameEn;
  String description(String lang) => lang == 'hi' ? descriptionHi : descriptionEn;
}

/// Configuration field for user input
class ConfigField {
  final String key;
  final String labelEn;
  final String labelHi;
  final String type; // 'text', 'url', 'email', 'phone', 'number', 'time', 'textarea', 'toggle', 'select'
  final bool required;
  final dynamic defaultValue;
  final String? hint;
  final List<String>? options; // For select type

  const ConfigField({
    required this.key,
    required this.labelEn,
    required this.labelHi,
    required this.type,
    this.required = false,
    this.defaultValue,
    this.hint,
    this.options,
  });

  String label(String lang) => lang == 'hi' ? labelHi : labelEn;
}

/// Fixed step in a workflow template
class TemplateStep {
  final int order;
  final String action;
  final String description;
  final String? conditional; // Config field key that must be true

  const TemplateStep({
    required this.order,
    required this.action,
    required this.description,
    this.conditional,
  });
}
