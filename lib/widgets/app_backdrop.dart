import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class AppBackdrop extends StatelessWidget {
  final Widget child;
  const AppBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFBEB), AppColors.bg, Color(0xFFFFF1E6)],
            ),
          ),
        ),
        Positioned(top: -60, right: -30, child: _blob(180, AppColors.primary.withValues(alpha: 0.18))),
        Positioned(bottom: 120, left: -40, child: _blob(140, AppColors.secondary.withValues(alpha: 0.12))),
        SafeArea(child: child),
      ],
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
