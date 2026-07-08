class ZoomAccountModel {
  final String id;
  final String accountName;
  final String meetingId;
  final String meetingPasscode;
  final String meetingClientId;
  final String meetingClientSecret;
  final String accountId;
  final String clientId;
  final String clientSecret;
  final String webhookSecret;
  final String liveLink;

  ZoomAccountModel({
    required this.id,
    required this.accountName,
    required this.meetingId,
    required this.meetingPasscode,
    required this.meetingClientId,
    required this.meetingClientSecret,
    required this.accountId,
    required this.clientId,
    required this.clientSecret,
    required this.webhookSecret,
    required this.liveLink,
  });

  factory ZoomAccountModel.fromMap(String id, Map<String, dynamic> map) {
    return ZoomAccountModel(
      id: id,
      accountName: map['accountName'] ?? '',
      meetingId: map['meetingId'] ?? '',
      meetingPasscode: map['meetingPasscode'] ?? '',
      meetingClientId: map['meetingClientId'] ?? '',
      meetingClientSecret: map['meetingClientSecret'] ?? '',
      accountId: map['accountId'] ?? '',
      clientId: map['clientId'] ?? '',
      clientSecret: map['clientSecret'] ?? '',
      webhookSecret: map['webhookSecret'] ?? '',
      liveLink: map['liveLink'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountName': accountName,
      'meetingId': meetingId,
      'meetingPasscode': meetingPasscode,
      'meetingClientId': meetingClientId,
      'meetingClientSecret': meetingClientSecret,
      'accountId': accountId,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'webhookSecret': webhookSecret,
      'liveLink': liveLink,
    };
  }

  String get startWebhookUrl =>
      'https://us-central1-ecommerce-test-54853.cloudfunctions.net/zoomWebhookIhthisham/meetingStart/$id';

  String get endWebhookUrl =>
      'https://us-central1-ecommerce-test-54853.cloudfunctions.net/zoomWebhookIhthisham/meetingEnd/$id';

  String get webhookValidationUrl =>
      'https://us-central1-ecommerce-test-54853.cloudfunctions.net/zoomWebhookIhthisham/webhook/$id';

  String get recordingWebhookUrl =>
      'https://us-central1-ecommerce-test-54853.cloudfunctions.net/zoomWebhookIhthisham/recordingComplete/$id';
}
