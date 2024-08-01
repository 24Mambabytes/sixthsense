import 'package:flutter/material.dart';

// A class representing a navigation destination in the app.
class NavDestination {
  const NavDestination({
    required this.label,
    required this.buttonInfo,
    required this.icon,
  });

  final String label;

  // The button info of the navigation destination.
  final String buttonInfo;

  // The icon of the navigation destination.
  final Icon icon;

  // The list of static navigation destinations.
  static const List<NavDestination> navDestinations = [
    NavDestination(
      label: 'SMART TEXT',
      buttonInfo: 'smart text tab',
      icon: Icon(Icons.notes),
    ),
    NavDestination(
      label: 'QR CODE',
      buttonInfo: 'qr code tab',
      icon: Icon(Icons.qr_code),
    ),
    NavDestination(
      label: 'SAFE STREET',
      buttonInfo: 'safe street tab',
      icon: Icon(Icons.groups),
    ),
  ];
}
