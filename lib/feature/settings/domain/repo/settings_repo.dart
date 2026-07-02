abstract class SettingsRepo {
  // Privacy Policy

  Future<void> privacyUpdate({
    required String header,
    required String description,
  });

  Future<Map<String, dynamic>> privacyGet();

  // Terms and Conditions

  Future<void> termsAndConditionUpdate({
    required String header,
    required String description,
  });

  Future<Map<String, dynamic>> termsAndConditionGet();

  // Help and Support

  Future<void> helpAndSupportUpdate({
    required String contactNumber,
    required String eMail,
    required String whatsAppNUmber,
  });

  Future<Map<String, dynamic>> helpAndSupportGet();
}