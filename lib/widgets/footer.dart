import 'package:flutter/material.dart';
import 'package:memo_portfolio/constants/colors.dart';
import 'package:memo_portfolio/constants/text_styles.dart';
import 'package:memo_portfolio/data/portfolio_data.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: primaryColor.withOpacity(0.1), width: 1),
        ),
      ),
      child: Center(
        child: Text(
          '© 2024 ${PortfolioData.name}. All rights reserved.',
          style: AppTextStyles.bodySmall.copyWith(color: textMuted, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
