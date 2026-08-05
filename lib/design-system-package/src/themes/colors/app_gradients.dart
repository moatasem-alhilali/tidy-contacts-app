import 'package:flutter/material.dart';

class AppGradients {
  // Plum -> Lavender (بطاقة مميزة)
  static const LinearGradient plumLavender = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF563F65), Color(0xFF8A6FA9)],
  );

  // Emerald Mist (بطاقة إنجاز/إحصاء)
  static const LinearGradient emeraldMist = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0EA5A5), Color(0xFFA7F3D0)],
  );

  // Navy Breeze (رأس قسم)
  static const LinearGradient navyBreeze = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF38BDF8)],
  );

  // Sand Glow (شارة/بطاقة لطيفة جدًا)
  static const LinearGradient sandGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8D29D), Color(0xFFF2E7C9)],
  );
}
