import 'package:flutter/material.dart';

/// National / highway emergency numbers shown before place search results.
class EmergencyHotline {
  const EmergencyHotline({
    required this.label,
    required this.number,
    required this.subtitle,
    required this.icon,
  });

  final String label;
  final String number;
  final String subtitle;
  final IconData icon;

  static const indiaHotlines = <EmergencyHotline>[
    EmergencyHotline(
      label: '112',
      number: '112',
      subtitle: 'Universal emergency',
      icon: Icons.emergency,
    ),
    EmergencyHotline(
      label: '108',
      number: '108',
      subtitle: 'Ambulance',
      icon: Icons.local_hospital,
    ),
    EmergencyHotline(
      label: '100',
      number: '100',
      subtitle: 'Police',
      icon: Icons.local_police,
    ),
    EmergencyHotline(
      label: '1033',
      number: '1033',
      subtitle: 'NHAI highway helpline',
      icon: Icons.support_agent,
    ),
  ];
}
