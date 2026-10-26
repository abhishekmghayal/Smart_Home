import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final Widget iconWidget;
  final VoidCallback onPressed;
  final bool isBrand;

  const SocialLoginButton({
    super.key,
    required this.iconWidget,
    required this.onPressed,
    this.isBrand = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: iconWidget,
        ),
      ),
    );
  }
}
