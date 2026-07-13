/// Public URLs and contact details for store listings and in-app links.
abstract final class AppLinks {
  static const String supportEmail = 'surajjadhav1065@gmail.com';

  static const String privacyPolicyUrl = 'https://www.journeyplus.in/privacy';

  static const String termsAndConditionsUrl = 'https://www.journeyplus.in/terms';

  static Uri get privacyPolicyUri => Uri.parse(privacyPolicyUrl);

  static Uri get termsAndConditionsUri => Uri.parse(termsAndConditionsUrl);

  static Uri get supportEmailUri =>
      Uri(scheme: 'mailto', path: supportEmail, queryParameters: {
        'subject': 'JourneyPlus support',
      });
}
