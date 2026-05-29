import 'package:url_launcher/url_launcher.dart';

/// Opens the device dialer for emergency / support numbers.
Future<bool> dialPhoneNumber(String number) async {
  final cleaned = number.replaceAll(RegExp(r'[^\d+]'), '');
  if (cleaned.isEmpty) return false;
  final uri = Uri(scheme: 'tel', path: cleaned);
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri);
}
