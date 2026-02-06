/// Application constants for KaamChalu B2B Automation Platform
class AppConstants {
  AppConstants._();

  // Supabase Configuration (Replace with your project credentials)
  static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';

  // App Info
  static const String appName = 'KaamChalu';
  static const String appNameHindi = 'काम चालू';
  static const String appTagline = 'Business Automation Made Simple';
  static const String appTaglineHindi = 'System banda ban gaya';

  // Pricing (INR)
  static const int proPlanPrice = 1500;
  static const int businessPlanPrice = 3000;

  // Workflow Execution
  static const int maxRetryAttempts = 2;
  static const Duration retryDelay = Duration(seconds: 30);

  // UX Modes
  static const String modeSimple = 'simple';
  static const String modeAdvanced = 'advanced';

  // Billing Plans
  static const String planFree = 'free';
  static const String planPro = 'pro';
  static const String planBusiness = 'business';

  // Languages
  static const String langEnglish = 'en';
  static const String langHindi = 'hi';
}
