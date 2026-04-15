import 'package:flutter/material.dart';
import 'package:lab2/app_theme.dart';
import 'package:lab2/constants/assets.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: AppTheme.paddingSmall,
            right: AppTheme.paddingMedium,
          ),
          child: Image.asset(Assets.logo, height: 96),
        ),
        Stack(
          children: [
            Text(
              'Recept',
              style: AppTheme.logoTextTheme.headlineLarge?.copyWith(
                fontSize: 48,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 48),
              child: Text(
                'Sök',
                style: AppTheme.logoTextTheme.headlineLarge?.copyWith(
                  fontSize: 48,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
