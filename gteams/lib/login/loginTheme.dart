import 'dart:ui';
import 'package:flutter/cupertino.dart';

class LoginTheme {
  const LoginTheme();
  static const Color loginGradientStart = const Color(0xFF083663);
  static const Color loginGradientEnd = const Color(0xFF82B1FF);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
