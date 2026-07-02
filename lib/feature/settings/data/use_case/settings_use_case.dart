import 'package:e_cource/feature/settings/domain/repo/settings_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SettingsUseCase {
  final SettingsRepo repo;

  SettingsUseCase(this.repo);

  //  Privacy Policy 

  Future<void> privacyUpdate({
    required String header,
    required String description,
  }) {
    return repo.privacyUpdate(header: header, description: description);
  }

  Future<Map<String, dynamic>> privacyGet() {
    return repo.privacyGet();
  }

  //  Terms & Conditions 

  Future<void> termsAndConditionUpdate({
    required String header,
    required String description,
  }) {
    return repo.termsAndConditionUpdate(
      header: header,
      description: description,
    );
  }

  Future<Map<String, dynamic>> termsAndConditionGet() {
    return repo.termsAndConditionGet();
  }

  // ---------------- Help & Support ----------------

  Future<void> helpAndSupportUpdate({
    required String contactNumber,
    required String eMail,
    required String whatsAppNUmber,
  }) {
    return repo.helpAndSupportUpdate(
      contactNumber: contactNumber,
      eMail: eMail,
      whatsAppNUmber: whatsAppNUmber,
    );
  }

  Future<Map<String, dynamic>> helpAndSupportGet() {
    return repo.helpAndSupportGet();
  }
}
